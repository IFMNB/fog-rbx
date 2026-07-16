--!strict

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
const NetPack = require("../../struct/NetPack")

const private = {}
const class = {}
setmetatable(class, { __index = Service })

export type class = object.class<typeof(class)>

class.type = namefield.sharednet
class.timeout = 60

function class.get_current_shared (): Instance
    return Upload.fetch(private, "current_shared", function()
        const new_shared = Instance.new "Folder"
		new_shared.Name = "shared"
        new_shared.Parent = ReplicatedStorage
        return new_shared
    end)
end

--[=[
    ?TODO

    function class.set_current_shared (to: Instance?)
        private.current_shared = to
    end
]=]

--[=[
   Если событие существует и если оно доступено из этого `Face.class`, будет совершен
   вызов с переданными аргументами.
]=]
function class:emit_event (face: Face.class<...any>, ...: unknown)
    
end

function private.event_fire(this: class, variant: number, link: number, ...: unknown)
    
end

--[=[
    Возвращает транспортировочное событие, которое привязано к экземпляру
    класса `BaseRemoteEvent`

    Транспортировочное событие не гарантирует мгновенной привязки к экземпляру
    на клиенте, поскольку созданием и управлением ими занимается сервер
]=]
function class:get_event(variant: number, link: number) : Face.class<NetPack.class>
	const this = self :: class

	assert(SharedNetVariant:is_my_enumitem(variant), "unexpected SharedNetVariant")
	assert(SharedNetLink:is_my_enumitem(link), "unexpected SharedNetLink")

	return private.fetch_event(this, variant, link):get_face()
end

function private.fetch_event (this: class, variant: number, link: number) : Event.class
    return Upload.fetch(private.remotes:fetch(variant), link, function()
		const new_event = Event.new()

		task.defer(function()
			if private.is_server then
                private.setup_serverside_event(this, variant, link, new_event)
			else
                private.setup_clientside_event(this, variant, link, new_event)
			end
		end)

		return new_event
	end)
end

function private.setup_clientside_event (this: class, variant: number, link: number, new: Event.class)
    const name = private.get_name_of_event_by(variant, link)
    const instance = this.get_current_shared():WaitForChild(name, this.timeout)
    if (not instance) then
        project.console_output "unable to fetch SharedNet :event, maybe your shared folder terminated?"
        return
    else
        if (not instance:IsA "BaseRemoteEvent") then
            project.console_output "unexpected instance for SharedNet"
            return
        end

        const signal :RBXScriptSignal<...any> = private.get_signal_from_unknown_subtype_remote(instance)
        signal:Connect(function(replicated_enum: number?, ...: any)
			if replicated_enum then
				new:launch(replicated_enum, NetPack.new(NetSource.FromClient))
			else
				new:emit(...)
			end
        end)
    end
end

function private.setup_serverside_event (this: class, variant: number, link: number, new: Event.class)
	const classname: string? = SharedNetVariant.get_variant(variant)

	if classname then
		const new_remote = Instance.new(classname) :: BaseRemoteEvent
		const signal = private.get_signal_from_unknown_subtype_remote(new_remote)
		new_remote.Name = private.get_name_of_event_by(variant, link)
		new_remote.Parent = this.get_current_shared()
		signal:Connect(function(a0: Player, replicated_enum: number?, ...: any)
            if (replicated_enum) then
                new:launch(replicated_enum, a0, ...)
            else
                new:emit(a0, ...)
            end
        end)
	else
		project.console_output(string.format("unexpected classname for SharedNetVariant %s", tostring(classname)))
	end
end

function private.get_name_of_event_by(variant: number, link: number): string
    return tostring(variant).."_runtime_"..tostring(link)
end

function private.get_signal_from_unknown_subtype_remote(get: BaseRemoteEvent): RBXScriptSignal<...any>
    if (get:IsA "RemoteEvent") then
        const that = get :: RemoteEvent
        if (private.is_server) then
            return that.OnServerEvent
        else 
            return that.OnClientEvent
        end
    elseif (get:IsA "UnreliableRemoteEvent") then
        const that = get :: UnreliableRemoteEvent
		if private.is_server then
			return that.OnServerEvent
		else
			return that.OnClientEvent
		end
    end

    return project.console_output "unexpected Instance for expected BaseRemoteEvent"
end

do --init_region
	const sharednet = object.new(class, "")

    private.direct = Storage.new(StorageMode.LazyValues) -- {[identity]: Event.class}
	private.remotes = Storage.new() -- {[variant]: {link: EventInstance}}
	private.is_server = RunService:IsServer()
    private.current_shared = ReplicatedStorage.shared :: Instance?
	private.singletone = sharednet
end

return private.singletone
