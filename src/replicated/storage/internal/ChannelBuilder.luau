--!strict



const ReplicatedStorage = game:GetService("ReplicatedStorage")
const RunService = game:GetService("RunService")

const EnumObject = require("@game/ReplicatedStorage/class/arch/EnumObject")
const declare = require("@game/ReplicatedStorage/static/declare")
const project = require("@game/ReplicatedStorage/static/project")

type rbx_type = Folder & {
	read send: RemoteEvent,
	read await: RemoteFunction,
	read async: RemoteFunction,
	read build: RemoteFunction,
}
type enumitem_hashlink = string | unknown

const internal = {}

internal.get_base = function(variant: declare.enumitem<any>): rbx_type
	if RunService:IsServer() then
		const folder = ReplicatedStorage.shared:FindFirstChild(variant.hashlink)

		if folder then
			if project.debug and project.debug_show_channel_internal then
				project.console_out("found precreated channel base")
			end

			return folder :: any
		else
			const new_folder = Instance.new("Folder")
			const new_event = Instance.new("RemoteEvent")
			const new_async = Instance.new("RemoteFunction")
			const new_await = Instance.new("RemoteFunction")
			--const new_build = Instance.new("RemoteFunction")

			assert(not ReplicatedStorage.shared:FindFirstChild(variant.hashlink), "name collision of bases")

			new_folder.Name = variant.hashlink
			new_event.Name = "send"
			new_async.Name = "async"
			new_await.Name = "await"
			--new_build.Name = "build"

			new_event.Parent = new_folder
			new_async.Parent = new_folder
			new_await.Parent = new_folder
			--new_build.Parent = new_folder
			new_folder.Parent = ReplicatedStorage.shared

			if project.debug and project.debug_show_channel_internal then
				project.console_out("connected internal watcher-api")

				if RunService:IsServer() then
					new_event.OnServerEvent:Connect(function(a0: Player, ...)
						project.console_out("raw event content ", a0.Name, ...)
					end)
				else
					new_event.OnClientEvent:Connect(function(...)
						project.console_out("raw event content ", ...)
					end)
				end
			end

			if project.debug and project.debug_show_channel_internal then
				project.console_out("created channel base")
			end

			return new_folder :: any
		end
	else
		if project.debug and project.debug_show_channel_internal then
			project.console_out(`trying fetch the channel base on client of \n{variant.name}\n{variant.hashlink}`)
		end

		const unknown_that: any = ReplicatedStorage.shared:FindFirstChild(variant.hashlink)
			or ReplicatedStorage.shared:WaitForChild(variant.hashlink, project.timeout)
		if unknown_that == nil then
			project.console_out_error("cannot find base on the client", variant.hashlink)
		else
			if project.debug and project.debug_show_channel_internal then
				project.console_out(`found base for {variant.name}`)
			end
		end

		return unknown_that :: rbx_type
	end
end

internal.checker = function(of: Instance)
	assert(of:IsA("Folder"), "class doesn't matches")
	assert(assert(of:FindFirstChild("send"), "folder doesn't have event"):IsA("RemoteEvent"))
	assert(assert(of:FindFirstChild("async"), "folder doesn't have function"):IsA("RemoteFunction"))
	assert(assert(of:FindFirstChild("await"), "folder doesn't have function"):IsA("RemoteFunction"))
	--assert(assert(of:FindFirstChild("build"), "folder doesn't have function"):IsA("RemoteFunction"))

	return of :: rbx_type
end

internal.build = function(maid: declare.maid, channel: declare.channel, of: rbx_type)
	if project.debug and project.debug_show_channel_internal then
		project.console_out("building channel low-level")
	end

	if RunService:IsServer() then
		const send_event_rbx = of.send.OnServerEvent:Connect(function(a0: Player, to: enumitem_hashlink, ...)
			const enumitem = internal.get_enumitem_from_string(to)
			internal.requests[channel] = a0.User.Id

			if project.debug and project.debug_show_channel_send_actions then
				project.console_out(enumitem.name, a0.Name, " | received a data packet from the client")
			end

			channel.event:invoke(enumitem, ...)
		end)

		maid:add_object(send_event_rbx)

		of.async.OnServerInvoke = function(player: Player, to: enumitem_hashlink, ...)
			assert(type(to) == declare.string, tostring(to))
			const enumitem = internal.get_enumitem_from_string(to)
			const f = channel:get_async_response(enumitem)

			if project.debug and project.debug_show_channel_internal then
				project.console_out(enumitem.name, player.Name, " | received a object request from the client")
			end

			if f then
				internal.requests[channel] = player.User.Id
				return f(...)
			else
				project.console_out_error("machine doesn't know how to work with received message")
				return nil :: never
			end
		end

		of.await.OnServerInvoke = function(player: Player, to: enumitem_hashlink, ...)
			assert(type(to) == declare.string, tostring(to))
			const enumitem = EnumObject.get_enumitem_by_hashlink(to :: string)
			const f = channel:get_sync_response(enumitem :: declare.enumitem_network_replication)

			if project.debug and project.debug_show_channel_internal then
				project.console_out(enumitem.name, player.Name, " | received a data request from the client")
			end

			if f then
				internal.requests[channel] = player.User.Id
				return f(...)
			else
				project.console_out_error("machine doesn't know how to work with received message")
				return nil :: never
			end
		end

		if project.debug and project.debug_show_channel_internal then
			project.console_out("building server low-level")
		end
	else
		const send_event_rbx = of.send.OnClientEvent:Connect(function(to: enumitem_hashlink, ...)
			const enumitem = internal.get_enumitem_from_string(to)

			if project.debug and project.debug_show_channel_send_actions then
				project.console_out(enumitem.name, " | received a data packet from the server")
			end

			channel.event:invoke(enumitem, ...)
		end)

		maid:add_object(send_event_rbx)

		of.async.OnClientInvoke = function(to: enumitem_hashlink, ...)
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
		of.await.OnClientInvoke = function(to: enumitem_hashlink, ...)
			assert(type(to) == declare.string)
			const enumitem = EnumObject.get_enumitem_by_hashlink(to :: string)
			const f = channel:get_sync_response(enumitem :: declare.enumitem_network_replication)

			if f then
				return f(...)
			else
				project.console_out_error("machine doesn't know how to work with received message")
				return nil :: never
			end
		end

		if project.debug and project.debug_show_channel_internal then
			project.console_out("building client low-level")
		end
	end
end

internal.get_enumitem_from_string = function(hashlink: enumitem_hashlink)
	assert(type(hashlink) == declare.string, "unexpected hashlink type")
	const enumitem = EnumObject.get_enumitem_by_hashlink(hashlink :: string)
	return enumitem :: declare.enumitem_network_replication
end

return internal