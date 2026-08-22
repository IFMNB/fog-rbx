--!strict
const RunService = game:GetService("RunService")
const EnumObject = require("@game/ReplicatedStorage/class/arch/EnumObject")
const Observable = require("@game/ReplicatedStorage/class/arch/Observable")
const Maid = require("@game/ReplicatedStorage/class/common/Maid")
const Maybe = require("@game/ReplicatedStorage/class/common/Maybe")
const Reference = require("@game/ReplicatedStorage/class/common/Reference")
const Notification = require("@game/ReplicatedStorage/class/common/notification/Notification")
const Package = require("@game/ReplicatedStorage/class/common/notification/Package")
const Event = require("@game/ReplicatedStorage/class/common/signal/Event")
const User = require("@game/ReplicatedStorage/class/local/User")
const ConnectionVariant = require("@game/ReplicatedStorage/enums/descriptor/ConnectionVariant")
const OperationVariant = require("@game/ReplicatedStorage/enums/descriptor/OperationVariant")
const ChannelNotification = require("@game/ReplicatedStorage/enums/notification/ChannelNotification")
const DisposableNotification = require("@game/ReplicatedStorage/enums/notification/DisposableNotification")
const declare = require("@game/ReplicatedStorage/static/declare")
const namefield = require("@game/ReplicatedStorage/static/namefield")
const project = require("@game/ReplicatedStorage/static/project")

const private = {}
const class: declare.channel = Observable:new({
	type = namefield.channel,

	enabled = false,
	echo = false,
    attempts = project.retry,
	time_to_hold = 0,
	time_to_response = project.retry_time,
    everyone = false,

    event = Event:new() :: declare.event<declare.enumitem_network_replication, ...unknown>,
    reference = Reference:new() :: declare.reference<declare.channel_internal_reference?>,

	send = function(self: declare.channel, to: declare.enumitem_network_replication, ...: unknown): ()
        const base = self.reference:get_instance()
        if base then
            if self.time_to_hold > 0 then 
                task.wait(self.time_to_hold)
            end

            if RunService:IsServer() then
                if project.debug and project.debug_show_channel_send_actions then
                    project.console_out(to.name, " | sending data to the peers in a batch", ...)
                end

                for _, v in self:get_peer() do
                    const player = v:get_player():get_instance()
                    if player then
                        base.send:FireClient(player, to.hashlink, ...)
                    end
                end
            else
                if project.debug and project.debug_show_channel_send_actions then
                    project.console_out(to.name, " | sending data to the server in a batch", ...)
                end

                base.send:FireServer(to.hashlink, ...)
            end
        else
            if self:get_variant() then
                project.console_out_error ("base has not been found, although the channel variant has been installed. Internal class error", base )
            else
                project.console_out("the channel does not have an installed variant, the network event has been dropped")
            end

        end

        if self.echo then
            private.requests[self] = nil
            self.event:invoke(to, ...)
        end
	end,

	await = function(self: declare.channel, to: declare.enumitem_network_replication, ...: unknown): {[declare.user]: (() -> ...unknown)?}
        const base = self.reference:get_instance()
        if base then
            if RunService:IsServer() then
                const result: {[declare.user]: (() -> ...unknown)?} = {}
                const peers = self:get_peer()
                local to_wait = #peers
                const run = coroutine.running()

                for _, v in peers do
                    const player = v:get_player():get_instance()

                    if player then
                        task.defer(function (...)
                            const thread = coroutine.running()
                            task.delay(self.time_to_response, function ()
                                if not result[v] then
                                    task.cancel(thread)
                                    coroutine.close(thread)

                                    to_wait -= 1
                                    if to_wait <= 0 then
                                        coroutine.resume(run)
                                    end
                                end
                            end)
                            
                            const state, out = pcall(function(...)
                                return base.await:InvokeClient(player, ...)
                            end, ...)

                            if state then
                                const pack = {out}

                                result[v] = function ()
                                    return unpack(pack)
                                end
                            else
                                project.console_out "fail to catch data, exception"
                            end

                            to_wait -= 1

                            if to_wait <= 0 then
                                coroutine.resume(run)
                            end
                        end, ...)
                    end
                end

                coroutine.yield()

                return result
            else
                const pack = {base.await:InvokeServer(...)}

                return {
                    [User:get_local_user()] = function ()
                        return unpack(pack)
                    end
                }
            end
        else
            project.console_out_error("cannot find base")
            return { }
        end
	end,

    async = function(self: declare.channel, to: declare.enumitem_network_replication, ...: unknown): {[declare.user]: (() -> ...unknown)?}
        const base = self.reference:get_instance()
        if base then
            if RunService:IsServer() then
                const result: {[declare.user]: (() -> ...unknown)?} = {}
                const peers = self:get_peer()

                for _, v in peers do
                    const player = v:get_player():get_instance()

                    if player then
                        task.defer(function (...)
                            const thread = coroutine.running()
                            task.delay(self.time_to_response, function ()
                                if not result[v] then
                                    task.cancel(thread)
                                    coroutine.close(thread)
                                end
                            end)
                            
                            const pack = {base.await:InvokeClient(player, ...)}

                            result[v] = function ()
                                return unpack(pack)
                            end
                        end, ...)
                    end
                end

                return result
            else
                const result: {[declare.user]: (() -> ...unknown)?} = {}

                task.defer(function (...)
                    const pack = {base.await:InvokeServer(...)}

                    result[User:get_local_user()] = function ()
                        return unpack(pack)
                    end
                end, ...)

                return result
            end
        else
            project.console_out_error("cannot find base")
            return { }
        end
	end,

	get_await_response = function(self: declare.channel, to: declare.enumitem<any>): ((...unknown) -> ...unknown)?
        return private.await[self][to]
    end,

	set_await_response = function(self: declare.channel, to: declare.enumitem<any>, f: ((...unknown) -> ...unknown)?): ()
        private.await[self][to] = f
        self:notificate(Notification:new {on = f and ChannelNotification.AwaitChanged or ChannelNotification.AwaitRemoved})
    end,

    get_async_response = function(self: declare.channel, to: declare.enumitem<any>): ((...unknown) -> declare.object)?
        return private.async[self][to]
    end,

	set_async_response = function(self: declare.channel, to: declare.enumitem<any>, f: ((...unknown) -> declare.object)?): ()
        private.async[self][to] = f
        self:notificate(Notification:new {on = f and ChannelNotification.AsyncChanged or ChannelNotification.AsyncRemoved})
    end,

    get_peer = function (self: declare.channel): {declare.user}
        const peers = private.peers[self]
        const result: {declare.user} = {}

        if self.everyone then
            for _, v in game:GetService("Players"):GetPlayers() do
                table.insert(result, User:new {uid = v.User.Id})
            end
        else
            for _, v in peers do
                table.insert(result, v)
            end
        end


        return result
    end,

    set_peer = function (self: declare.channel, of: declare.user, to: boolean?) : ()
        const peers = private.peers[self]
        if to == false then
            peers[tostring(of.uid)] = nil
            self:notificate(Notification:new {on = ChannelNotification.PeerRemoved})
            return
        end

        peers[tostring(of.uid)] = of
        self:notificate(Notification:new {on = ChannelNotification.PeerAdded})
    end,

    is_peer = function (self: declare.channel, of: declare.user) : boolean
	    const peers = private.peers[self]
        return peers[tostring(of.uid)] ~= nil
    end,

    request_from = function (self: declare.channel) : declare.user?
        const uid = private.requests[self]

        if uid then
            return User:new {
                uid = uid
            }
        else
            return nil
        end
    end,

    get_variant = function (self: declare.channel ) : declare.enumitem_network_replication?
        return private.variant[self]
    end,

    set_variant = function (self: declare.channel, to: declare.enumitem_network_replication?) : ()
        private.variant[self] = to

        if to then
            const base = private.get_base(to)
            if base then
                self.reference:set_instance(base)
            else
                project.console_out_error("it is not possible to establish a base for the channel, further network communication will be interrupted")
            end
        else
            self.reference:set_instance(nil)

            if project.debug then
                project.console_out "base related to nil, is this perhaps an incorrect behavior?"
            end
        end

        self:notificate(Notification:new {on = ChannelNotification.VariantChanged})
    end,

    is_variant = function (self: declare.channel, of: declare.enumitem_network_replication) : boolean
        const variant = private.variant[self]
        if variant then
            return variant.hashlink == of.hashlink
        else
            return false
        end
    end
})

class:host(function(new: declare.channel)
    do
		(new :: any).reference = Reference:new();
        (new :: any).event = Event:new()
    end

    private.peers[new] = {}

    new.reference:notice(Package:new <<declare.enumitem_operation_variant>> {
        on = {
            OperationVariant.Change,
            OperationVariant.New
        },
        pack = {
            Package:new {
                on = ConnectionVariant.Ever,
                pack = {
                    function ()
                        if project.debug and project.debug_show_channel_internal then
                            project.console_out ("reference changed, rebuilding")
                        end

                        if private.maids:exist(new) then
                            private.get_maid(new):free()
                        end

                        private.build(new, private.checker(new.reference:get_instance() :: any))
                    end
                }
            }
        }
    })

    new.reference:subscribe(OperationVariant.Null, ConnectionVariant.Ever, function ()
        if private.maids:exist(new) then
            private.get_maid(new):free()
        end
    end)
end)

do
    type rbx_type = declare.channel_internal_reference
    type enumitem_hashlink = string|unknown

    private.meta = table.freeze {__mode = 'ks'}
    private.async = setmetatable({} :: { [declare.channel]: { [declare.enumitem_network_replication]: ((...unknown) -> declare.object)?}}, private.meta)
	private.await = setmetatable({} :: { [declare.channel]: { [declare.enumitem_network_replication]: ((...unknown) -> ...unknown)? } }, private.meta)
    private.variant = setmetatable({} :: { [declare.channel]: declare.enumitem_network_replication? } , private.meta)
	private.peers = setmetatable({} :: { [declare.channel]: {[string]: declare.user} }, private.meta)
    private.requests = setmetatable({} :: { [declare.channel]: number?}, private.meta)
    
    private.maids = Maybe:new()

	private.get_base = function(variant: declare.enumitem<any>): rbx_type
		if RunService:IsServer() then
			const folder = game.ReplicatedStorage.shared:FindFirstChild(variant.hashlink)

			if folder then
                if project.debug and project.debug_show_channel_internal then
                    project.console_out ("found precreated channel base")
                end

				return folder :: any
			else
				const new_folder = Instance.new("Folder")
				const new_event = Instance.new("RemoteEvent")
				const new_async = Instance.new("RemoteFunction")
				const new_await = Instance.new("RemoteFunction")
                --const new_build = Instance.new("RemoteFunction")

				new_folder.Name = variant.hashlink
				new_event.Name = "send"
				new_async.Name = "async"
                new_await.Name = "await"
                --new_build.Name = "build"

				new_event.Parent = new_folder
				new_async.Parent = new_folder
				new_await.Parent = new_folder
                --new_build.Parent = new_folder
                new_folder.Parent = game.ReplicatedStorage.shared

                if project.debug and project.debug_show_channel_internal then
                    if RunService:IsServer() then
                        new_event.OnServerEvent:Connect(function(a0: Player, ...)
                            project.console_out("raw event content ", a0.Name, ...)
                        end)
                    else
                        new_event.OnClientEvent:Connect(function(...)
                            project.console_out("raw event content " , ...) 
                        end)
                    end
                end

                if project.debug and project.debug_show_channel_internal then
                    project.console_out ("creating channel base")
                end

				return new_folder :: any
			end
		else
			const unknown_that: any = game.ReplicatedStorage.shared:WaitForChild(variant.hashlink, 5)
            if not unknown_that then
                project.console_out_error("cannot find base on the client")
            end

            return unknown_that :: rbx_type
		end
	end

    private.checker = function (of: Instance )
		assert(of:IsA("Folder"), "class doesn't matches")
		assert(assert(of:FindFirstChild("send"), "folder doesn't have event"):IsA("RemoteEvent"))
		assert(assert(of:FindFirstChild("async"), "folder doesn't have function"):IsA("RemoteFunction"))
        assert(assert(of:FindFirstChild("await"), "folder doesn't have function"):IsA("RemoteFunction"))
        --assert(assert(of:FindFirstChild("build"), "folder doesn't have function"):IsA("RemoteFunction"))

        return of :: rbx_type
    end

    private.get_maid = function (channel: declare.channel)
        return private.maids:extract(channel, function()
            const maid = Maid:new()
            maid:subscribe(DisposableNotification.OnRelease, ConnectionVariant.Once, function ()
                private.maids:erase(channel)
            end)

            return maid
        end)

    end

    private.get_enumitem_from_string = function (hashlink: enumitem_hashlink)
        assert(type(hashlink) == declare.string)
                
        const enumitem = EnumObject.get_enumitem_by_hashlink(hashlink :: string)

        return enumitem :: declare.enumitem_network_replication
    end

    -- TODO rewrite legacy code

    private.build = function (channel: declare.channel, of: rbx_type)
        const maid = private.get_maid(channel)

        if project.debug and project.debug_show_channel_internal then
            project.console_out ("building channel low-level")
        end

        if RunService:IsServer() then
            const send_event_rbx = of.send.OnServerEvent:Connect(function(a0: Player, to: enumitem_hashlink, ...)
                const enumitem = private.get_enumitem_from_string(to)
                private.requests[channel] = a0.User.Id

                if project.debug and project.debug_show_channel_send_actions then
                    project.console_out(enumitem.name, a0.Name, " | received a data packet from the client")
                end

                channel.event:invoke(enumitem, ...)
            end)

            maid:add_object(send_event_rbx)

            of.async.OnServerInvoke = function (player: Player, to: enumitem_hashlink, ...)
                const enumitem = private.get_enumitem_from_string(to)
                const f = channel:get_async_response(enumitem)

                if f then
                    private.requests[channel] = player.User.Id
                    return f(...)
                else
                    project.console_out_error("machine doesn't know how to work with received message")
                    return nil :: never
                end
            end
            of.await.OnServerInvoke = function (player: Player, to: enumitem_hashlink, ...)
                assert(type(to) == declare.string)
                const enumitem = EnumObject.get_enumitem_by_hashlink(to :: string)
                const f = channel:get_await_response(enumitem :: declare.enumitem_network_replication)

                if f then
                    private.requests[channel] = player.User.Id
                    return f(...)
                else
                    project.console_out_error("machine doesn't know how to work with received message")
                    return nil :: never
                end
            end
        else
            const send_event_rbx = of.send.OnClientEvent:Connect(function(to: enumitem_hashlink, ...)
                const enumitem = private.get_enumitem_from_string(to)
                
                if project.debug and project.debug_show_channel_send_actions then
                    project.console_out(enumitem.name, " | received a data packet from the server")
                end
                
                channel.event:invoke(enumitem, ...)
            end)

            maid:add_object(send_event_rbx)

            of.async.OnClientInvoke = function (to: enumitem_hashlink, ...)
                assert(type(to) == declare.string)
                
                const enumitem = EnumObject.get_enumitem_by_hashlink(to :: string)
                const f = channel:get_async_response(enumitem :: declare.enumitem_network_replication)

                if f then
                    return f(...)
                else
                    project.console_out_error("machine doesn't know how to work with received message")
                    return nil :: never
                end
            end
            of.await.OnClientInvoke = function (to: enumitem_hashlink, ...)
                assert(type(to) == declare.string)
                const enumitem = EnumObject.get_enumitem_by_hashlink(to :: string)
                const f = channel:get_await_response(enumitem :: declare.enumitem_network_replication)

                if f then
                    return f(...)
                else
                    project.console_out_error("machine doesn't know how to work with received message")
                    return nil :: never
                end
            end
        end

        
    end
end

return class
