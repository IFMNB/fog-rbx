const Players = game:GetService("Players")
const Disposable = require("@game/ReplicatedStorage/Disposable")
const Event = require("@game/ReplicatedStorage/class/event/Event")
const Face = require("@game/ReplicatedStorage/class/face/Face")
const Node = require("@game/ReplicatedStorage/class/node/Node")
const Service = require("@game/ReplicatedStorage/class/service/Service")
const Storage = require("@game/ReplicatedStorage/class/storage/Storage")
const Upload = require("@game/ReplicatedStorage/class/upload/Upload")
const Value = require("@game/ReplicatedStorage/class/value/Value")
const Wrapper = require("@game/ReplicatedStorage/class/wrapper/Wrapper")
const ServerState = require("@game/ReplicatedStorage/enums/ServerState")
const ShutdownReason = require("@game/ReplicatedStorage/enums/ShutdownReason")
const object = require("@game/ReplicatedStorage/object")
const namefield = require("@game/ReplicatedStorage/static/namefield")
const project = require("@game/ReplicatedStorage/static/project")
const Config = require("../../class/config/Config")

const private = {}
const class = {}
setmetatable(class, { __index = Node })

export type class = typeof(private.singletone)

class.type = namefield.server
class.session_id = game.JobId
class.private_server = game.PrivateServerId and true or false :: boolean
class.player_owner_id = class.private_server and game.PrivateServerOwnerId or 0 :: number

class.new = Service.new

do --on_initiate_region
	function class:on_initiate()
		const this = self :: class
		this:watch_free_event(function()
			this:shutdown()
		end)
	end
end

do --server_messaging_region
	function class:get_current_server_state(): number
		const this = self :: class
		const metadata = private.metadata:fetch(this)
		return Upload.fetch(metadata, "server_state", ServerState.Unknown)
	end

	private.notification_channel = project.version
end

do --events_region
	function class:get_shutdown_event()
		const this = self :: class
		const metadata = private.metadata:fetch(this)
		local face: Face.class<number>
		Upload.fetch(metadata, "shutdown_event", function()
			const new = Event.new()

			face = new:get_face()
			local fired = false

			game:BindToClose(function(reason: Enum.CloseReason): ...any
				if not fired then
					new:emit(ShutdownReason.map(reason))
				end
			end)

			face:once(function()
				fired = true

				Players.PlayerAdded:Connect(function(a0: Player) end)

				for i, v in Players:GetPlayers() do
					v:Kick("server shutting down by")
				end
			end)

			return new
		end)

		return face
	end
end

do --values_region
	function class:get_owner_joined_event()
		const this = self :: class
		const metadata = private.metadata

		assert(
			this.private_server or not project.debug,
			"attempt to access owner_joined_event when server isn't a private"
		)

		return Upload.fetch(metadata, "owner_joined_event", function()
			const new = Event.new()
			Players.PlayerAdded:Connect(function(a0: Player)
				if a0.UserId == this.player_owner_id then
					new:emit(Wrapper.new(a0))
				end
			end)
			return new
		end):get_face()
	end

	function class:get_votekick_value(): Value.generic<boolean>
		const this = self :: class
		const metadata = private.metadata:fetch(this)
		const name = "sv_votekick"
		return Upload.fetch(metadata, name, function()
			return Config.new(name)
		end)
	end

	function class:get_cheats_value()
		const this = self :: class
		const metadata = private.metadata:fetch(this)
		const name = "sv_cheats"
		return Upload.fetch(metadata, name, function()
			return Config.new(name)
		end)
	end
end

do --controls_region
	function class:stop()
		const metadata = private.metadata

		if metadata.thread then
			task.cancel(metadata.thread)
		else
			assert(not project.debug, "mainloop thread does not exist")
		end
	end

	function class:start(mainloop: () -> ())
		const this = self :: class
		const metadata = private.metadata:fetch(this)

		metadata.thread = task.defer(mainloop, this)
	end
end

function class:shutdown()
	const this = self :: class
	const metadata = private.metadata:fetch(this)
	metadata.server_state = ServerState.Shutdown

	if metadata.shutdown_event then
		metadata.shutdown_event:emit()
	end
end

private.metadata = Storage.new()

do --initiate_region
	const server = class.arch_new(class, true)

	private.singletone = server
	table.freeze(class)
	table.freeze(private)
end

return private.singletone
