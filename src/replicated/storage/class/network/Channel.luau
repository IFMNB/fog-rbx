--!strict
const EnumObject = require("@game/ReplicatedStorage/class/arch/EnumObject")
const Observable = require("@game/ReplicatedStorage/class/arch/Observable")
const Maid = require("@game/ReplicatedStorage/class/common/Maid")
const Maybe = require("@game/ReplicatedStorage/class/common/Maybe")
const Reference = require("@game/ReplicatedStorage/class/common/Reference")
const Notification = require("@game/ReplicatedStorage/class/common/notification/Notification")
const Package = require("@game/ReplicatedStorage/class/common/notification/Package")
const Event = require("@game/ReplicatedStorage/class/common/signal/Event")
const User = require("@game/ReplicatedStorage/class/local/User")
const ChannelVariant = require("@game/ReplicatedStorage/enums/descriptor/ChannelVariant")
const ConnectionVariant = require("@game/ReplicatedStorage/enums/descriptor/ConnectionVariant")
const OperationVariant = require("@game/ReplicatedStorage/enums/descriptor/OperationVariant")
const ChannelNotification = require("@game/ReplicatedStorage/enums/notification/ChannelNotification")
const DisposableNotification = require("@game/ReplicatedStorage/enums/notification/DisposableNotification")
const declare = require("@game/ReplicatedStorage/static/declare")
const namefield = require("@game/ReplicatedStorage/static/namefield")
const project = require("@game/ReplicatedStorage/static/project")
const Result = require("@game/ReplicatedStorage/struct/common/Result")

const private = {}
const class: declare.channel = Observable:new({
	type = namefield.channel,

	enabled = false,
	echo = false,
    attempts = project.retry,
	time_to_hold = 0,
	time_to_response = project.retry_time,

    event = Event:new() :: declare.event<declare.enumitem_network_replication, ...unknown>,
    reference = Reference:new() :: declare.reference<declare.channel_internal_reference?>,

	send = function(self: declare.channel, to: declare.enumitem_network_replication, ...: unknown): ()
        const base = self.reference:get_instance()
        if base then
            if self.time_to_hold > 0 then 
                task.wait(self.time_to_hold)
            end

            if game.RunService:IsServer() then
                for _, v in private.peers[self] do
                    const player = v:get_player():get_instance()
                    if player then
                        base.send:FireClient(player, to.hashlink, ...)
                    end
                end
            else
                base.send:FireServer(to.hashlink, ...)
            end
        end

        if self.echo then
            self.event:invoke(to :: declare.enumitem<any>, ...)
        end
	end,

	await = function(self: declare.channel, to: declare.enumitem_network_replication, ...: unknown): declare.result<{ unknown }, ...unknown>

	end,

    async = function(self: declare.channel, to: declare.enumitem_network_replication, ...: unknown): declare.result<declare.object>

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

        for _, v in peers do
            table.insert(result, v)
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

    get_variant = function (self: declare.channel ) : declare.enumitem_channel_variant?
        return private.variant[self]
    end,

    set_variant = function (self: declare.channel, to: declare.enumitem_channel_variant?) : ()
        ChannelVariant:assert_is_my_enumitem(to)
        private.variant[self] = to

        if to then
            self.reference:set_instance(private.get_base(to))
        else
            self.reference:set_instance(nil)
        end

        self:notificate(Notification:new {on = ChannelNotification.VariantChanged})
    end,

    is_variant = function (self: declare.channel, of: declare.enumitem_channel_variant) : boolean
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


    new.reference:notice(Package:new <<declare.enumitem_operation_variant>> {
        on = {
            OperationVariant.Change,
            OperationVariant.New
        },
        pack = Package:new {
            on = ConnectionVariant.Ever,
            pack = {
                function ()
                    if private.maids:exist(new) then
                        private.get_maid(new):free()
                    end

                    private.build(new, private.checker(new.reference:get_instance() :: any))
                end
            }
        }
    })

    new.reference:subscribe(OperationVariant.Null, ConnectionVariant.Ever, function ()
        if private.maids:exist(new) then
            private.get_maid(new):free()
        end
    end)

    private.peers[new] = {}

end)

do
    type rbx_type = declare.channel_internal_reference
    type enumitem_hashlink = string|unknown

    private.meta = table.freeze {__mode = 'ks'}
    private.async = setmetatable({} :: { [declare.channel]: { [declare.enumitem_network_replication]: ((...unknown) -> declare.object)?}}, private.meta)
	private.await = setmetatable({} :: { [declare.channel]: { [declare.enumitem_network_replication]: ((...unknown) -> ...unknown)? } }, private.meta)
    private.variant = setmetatable({} :: { [declare.channel]: declare.enumitem_channel_variant? } , private.meta)
	private.peers = setmetatable({} :: { [declare.channel]: {[string]: declare.user} }, private.meta)
    private.requests = setmetatable({} :: { [declare.channel]: number?}, private.meta)
    
    private.maids = Maybe:new()

	private.get_base = function(variant: declare.enumitem<any>): rbx_type
		if game.RunService:IsServer() then
			const folder = game.ReplicatedStorage.shared:FindFirstChild(variant.hashlink)

			if folder then
				return folder :: any
			else
				const new_folder = Instance.new("Folder")
				const new_event = Instance.new("RemoteEvent")
				const new_async = Instance.new("RemoteFunction")
				const new_await = Instance.new("RemoteFunction")


				new_folder.Name = variant.hashlink
				new_event.Name = "send"
				new_async.Name = "async"
                new_await.Name = "await"

				new_event.Parent = new_folder
				new_async.Parent = new_folder
				new_await.Parent = new_folder
                new_folder.Parent = shared

				return new_folder :: any
			end
		else
			const unknown_that: any = game.ReplicatedStorage.shared:WaitForChild(variant.hashlink, 5)
            private.checker(unknown_that)

            return unknown_that :: rbx_type
		end
	end

    private.checker = function (of: Instance )
		assert(of:IsA("Folder"), "class doesn't matches")
		assert(assert(of:FindFirstChild("send"), "folder doesn't have event"):IsA("RemoteEvent"))
		assert(assert(of:FindFirstChild("async"), "folder doesn't have function"):IsA("RemoteFunction"))
        assert(assert(of:FindFirstChild("await"), "folder doesn't have function"):IsA("RemoteFunction"))
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
        maid:add_key(of.async :: {[string]: unknown}, "OnServerInvoke")
        maid:add_key(of.async :: {[string]: unknown}, "OnClientInvoke")
        maid:add_key(of.await :: {[string]: unknown}, "OnServerInvoke")
        maid:add_key(of.await :: {[string]: unknown}, "OnClientInvoke")

        if game.RunService:IsServer() then
            maid:add_key(of.send :: {[unknown]: unknown}, of.send.OnServerEvent:Connect(function(a0: Player, to: enumitem_hashlink, ...)
                const enumitem = private.get_enumitem_from_string(to)
                private.requests[channel] = a0.User.Id
                channel.event:invoke(enumitem, ...)
            end)) 

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
            maid:add_key(of.send :: {[unknown]: unknown}, of.send.OnClientEvent:Connect(function(to: enumitem_hashlink, ...)
                const enumitem = private.get_enumitem_from_string(to)
                channel.event:invoke(enumitem, ...)
            end))

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
