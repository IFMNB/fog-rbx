const ReplicatedStorage = game:GetService("ReplicatedStorage")
const RunService = game:GetService("RunService")
const Service = require("../../Service")
const Event = require("../../class/event/Event")
const Face = require("../../class/face/Face")
const Storage = require("../../class/storage/Storage")
const Upload = require("../../class/upload/Upload")
const NetSource = require("../../enums/NetSource")
const SharedNetLink = require("../../enums/SharedNetLink")
const SharedNetVariant = require("../../enums/SharedNetVariant")
const StorageMode = require("../../enums/StorageMode")
const object = require("../../object")
const namefield = require("../../static/namefield")
const project = require("../../static/project")
const Liberator = require("../../struct/Liberator")
const NetPack = require("../../struct/NetPack")

const private = {}
const class = {}
setmetatable(class, { __index = Service })

export type class = object.class<typeof(class)>
type metadata = {
	variant: number,
	link: number,
	event: BaseRemoteEvent,
	types: { string },
}

class.type = namefield.sharednet

--[=[
	Регулирует внутренние таймауты в секундах
]=]
class.timeout = 3

--[=[
	Сколько раз за сессию к сервису `SharedNet` был совершен вызов `:get_event()`
	с учетом генерации с нуля. По сути, сколько ивентов было создано за сессию
]=]
class.generated = 0

--[=[
	Сколько раз за сессию к сервису `SharedNet` был совершен вызов `:emit_event()`
]=]
class.emited = 0

--[=[
	Сколько раз за сессию к сервису `SharedNet` был совершен вызов `:get_event()`
]=]
class.access = 0

--[=[
	Возвращает текущий `shared` экземпляр, в котором будут создаваться все события `SharedNet`
]=]
function class.get_current_shared(): Instance
	return Upload.fetch(private, "current_shared", function()
		const new_shared = Instance.new("Folder")
		new_shared.Name = "shared"
		new_shared.Parent = ReplicatedStorage
		return new_shared
	end)
end

--[=[
	Для указания конкретной директории, в которой будут создаваться все события `SharedNet`

	Это нужно для параллельной работы нескольких `SharedNet` в одном проекте, чтобы не было коллизий имен
]=]
function class.set_current_shared(to: Instance?)
	private.current_shared = to
end

--[=[
   Если событие существует и если оно доступено из этого `Face.class`, будет совершен
   вызов с переданными аргументами.
]=]
function class:emit_event(face: Face.class<NetPack.class> | string, netpack: NetPack.class?): boolean
	const this = self :: class
	const event = private.direct[object.is(face, Face.type) and (face :: Face.class).owner_identity or face :: string]

	this.actions += 1

	if event then
		netpack = netpack or NetPack.new()
		const metadata = private.metadata_by(event)
		const emitter = private.emitter_variants[metadata.variant]

		if not private.check_types(metadata, netpack) then
			project.console_out_error("type mismatch")
			return false
		end

		emitter(this, event, metadata, netpack)

		if private.is_server and netpack then
			netpack.from = NetSource.FromServer
		end

		this.emited += 1

		return true
	else
		this.errors += 1
		project.console_out_error("unknown Face.class, abort")
	end

	return false
end

function private.check_types(metadata: metadata, netpack: NetPack.class): boolean
	if not metadata.types then
		return true
	end

	const payload: { unknown } = netpack.loaded
	for i, v in metadata.types do
		if typeof(payload[i]) ~= v then
			return false
		end
	end

	return true
end

--[=[
	Устанавливает ожидаемые типы для `NetPack` в событии, которое привязано к `Face.class`

	Если только это событие было создано через `SharedNet`, то есть оно было получено через `:get_event()`
]=]
function class:set_expected_types(face: Face.class<NetPack.class> | string, types: { string }): boolean
	const this = self :: class
	const event = private.direct[object.is(face, Face.type) and (face :: Face.class).owner_identity or face :: string]

	this.actions += 1

	if event then
		const metadata = private.metadata_by(event)
		metadata.types = types
		return true
	else
		this.errors += 1
		project.console_out_error("unknown Face.class, abort")
		return false
	end
end

private.emitter_variants = table.freeze({
	[SharedNetVariant.Internal] = function(this: class, event: Event.class, metadata: metadata, netpack: NetPack.class)
		const flat = netpack:get_flat()
		if netpack.rpc then
			const that: BindableEvent = metadata.event :: any
			that:Fire(flat)
		else
			if netpack.expected then
				event:launch(netpack.expected :: number, flat)
			else
				event:emit(flat)
			end
		end
	end,
	[SharedNetVariant.Safe] = function(this: class, event: Event.class, metadata: metadata, netpack: NetPack.class)
		const that: RemoteEvent = metadata.event :: any
		const players = netpack:get_players()
		const flat = netpack:get_flat()

		for _, player in players do
			if private.is_server then
				that:FireClient(player, flat)
			else
				that:FireServer(flat)
			end
		end

		if netpack.rpc then
			if netpack.expected then
				event:launch(netpack.expected :: number, flat)
			else
				event:emit(flat)
			end
		end
	end,
	[SharedNetVariant.Unsafe] = function(this: class, event: Event.class, metadata: metadata, netpack: NetPack.class)
		return private.emitter_variants[SharedNetVariant.Safe](this, event, metadata, netpack)
	end,
	[SharedNetVariant.Unknown] = function(this: class, event: Event.class, metadata: metadata, netpack: NetPack.class)
		project.console_out_error("unexpected SharedNetVariant")
		return
	end,
}) :: { (class, Event.class, metadata, NetPack.class) -> () }

--[=[
    Возвращает транспортировочное событие, которое привязано к экземпляру
    класса `BaseRemoteEvent`

    Транспортировочное событие не гарантирует мгновенной привязки к экземпляру
    на клиенте, поскольку созданием и управлением ими занимается сервер
]=]
function class:get_event(link: number?, variant: number?): Face.class<NetPack.class>
	const this = self :: class

	this.actions += 1

	variant = variant or SharedNetVariant.Safe
	link = link or SharedNetLink.Unknown

	-- Не создавайте проверку на `link`, чтобы не заниматься постоянным дополнением `SharedNetLink`
	-- на предмет новых значений  (QoL)

	const correct = SharedNetVariant:is_my_enumitem(variant)

	if not correct then
		this.errors += 1
		project.console_out_error("unexpected SharedNetVariant or SharedNetLink")
		return Face.new()
	else
		this.access += 1
		return private.fetch_event(this, variant, link):get_face()
	end
end

do --get_event_private
	function private.fetch_event(this: class, variant: number, link: number): Event.class
		return Upload.fetch(private.remotes:fetch(variant), link, function()
			const new_event = Event.new()
			const remote = private.create_instance(variant, link)

			private.setup_behaviour(new_event, remote)
			private.metadata_by(new_event, variant, link, remote)
			private.direct[new_event.identity] = new_event
			new_event:watch_free_event(Liberator.new(private.direct, new_event.identity, true))

			return new_event
		end)
	end

	function private.metadata_by(that: Event.class, variant: number?, link: number?, remote: BaseRemoteEvent?)
		return private.metadata:fetch(that, function()
			return {
				variant = variant or SharedNetVariant.Unknown,
				link = link or SharedNetLink.Unknown,
				event = remote,
			} :: metadata
		end)
	end

	function private.setup_behaviour(new: Event.class, remote: BaseRemoteEvent)
		if remote:IsA("BindableEvent") then
			private.setup_internal_event(new, remote)
		elseif remote:IsA("RemoteEvent") or remote:IsA("UnreliableRemoteEvent") then
			if private.is_server then
				private.setup_serverside_event(new, remote)
			else
				private.setup_clientside_event(new, remote)
			end
		end
	end

	function private.setup_internal_event(new: Event.class, remote: BaseRemoteEvent)
		return private.setup_clientside_event(new, remote)
	end

	function private.setup_clientside_event(new: Event.class, remote: BaseRemoteEvent)
		const signal = private.get_signal_from_unknown_subtype_remote(remote)
		signal:Connect(function(a0: NetPack.flat, ...)
			const netpack = NetPack.convert_flat(a0)
			if netpack.expected then
				new:launch(netpack.expected :: number, netpack)
			else
				new:emit(netpack)
			end
		end)
	end

	function private.setup_serverside_event(new: Event.class, remote: BaseRemoteEvent)
		const signal = private.get_signal_from_unknown_subtype_remote(remote)
		signal:Connect(function(sender: Player, a0: NetPack.flat, ...)
			const netpack = NetPack.convert_flat(a0) :: any

			if netpack.from == NetSource.FromServer then
				sender:Kick(
					"nuh uh, dear, you're warned from that thing for now. I'm dissapointed in you. Do not replace my netpack.from, that's not allowed "
				)
				return
			else
				netpack.from = NetSource.FromClient
			end

			netpack.sender = sender.User:ToString()

			if netpack.expected then
				new:launch(netpack.expected :: number, netpack)
			else
				new:emit(netpack)
			end
		end)
	end

	function private.create_instance(variant: number, link: number)
		const name = private.get_name_of_event_by(variant, link)
		const instance_class = variant == SharedNetVariant.Internal and "BindableEvent"
			or variant == SharedNetVariant.Safe and "RemoteEvent"
			or variant == SharedNetVariant.Unsafe and "UnreliableRemoteEvent"
			or variant == SharedNetVariant.Unknown and "RemoteEvent"
			or "RemoteEvent"
		const placement = private.singletone.get_current_shared()

		local result: BaseRemoteEvent
		if private.is_server then
			const instance = Instance.new(instance_class) :: BaseRemoteEvent
			instance.Name = name
			instance.Parent = placement
			result = instance
		else
			if instance_class == "BindableEvent" then
				const needle = Instance.new(instance_class)
				needle.Name = name
				needle.Parent = placement
				result = needle
			else
				const needle = placement:WaitForChild(
					name,
					private.singletone and private.singletone.timeout or class.timeout
				) or game
				result = (needle:IsA("BaseRemoteEvent") and needle or nil) :: BaseRemoteEvent
				if not result then
					const replacement = Instance.new("BindableEvent") :: any
					replacement.Name = name .. "error"
					replacement.Parent = game.StarterPlayer.client_runtime
					result = replacement :: BaseRemoteEvent
					project.console_out_error("unexpected event type, replaced")
				end
			end
		end

		return result
	end

	function private.get_name_of_event_by(variant: number, link: number): string
		return tostring(variant) .. "_runtime_" .. tostring(link)
	end

	function private.get_signal_from_unknown_subtype_remote(get: BaseRemoteEvent): RBXScriptSignal<...any>
		if get:IsA("RemoteEvent") then
			const that = get :: RemoteEvent
			if private.is_server then
				return that.OnServerEvent
			else
				return that.OnClientEvent
			end
		elseif get:IsA("UnreliableRemoteEvent") then
			const that = get :: UnreliableRemoteEvent
			if private.is_server then
				return that.OnServerEvent
			else
				return that.OnClientEvent
			end
		elseif get:IsA("BindableEvent") then
			const that = get :: BindableEvent
			return that.Event
		end

		return project.console_out_error("unexpected Instance for expected BaseRemoteEvent")
	end
end

do --init_region
	const sharednet = object.new(class, "")

	private.metadata = Upload.new()
	private.direct = Storage.create_table_with(StorageMode.LazyValues) :: { [typeof(object.identity)]: Event.class? }
	private.remotes = Storage.new() -- {[variant]: {link: EventInstance}}
	private.is_server = RunService:IsServer()
	private.current_shared = ReplicatedStorage.shared :: Instance?
	private.singletone = sharednet
end

return private.singletone
