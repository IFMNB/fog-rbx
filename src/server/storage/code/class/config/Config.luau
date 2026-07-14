const ConfigService = game:GetService("ConfigService")
const Disposable = require("@game/ReplicatedStorage/code/Disposable")
const Event = require("@game/ReplicatedStorage/code/class/event/Event")
const Storage = require("@game/ReplicatedStorage/code/class/storage/Storage")
const Timer = require("@game/ReplicatedStorage/code/class/timer/Timer")
const Value = require("@game/ReplicatedStorage/code/class/value/Value")
const object = require("@game/ReplicatedStorage/code/object")
const namefield = require("@game/ReplicatedStorage/code/static/namefield")
const project = require("@game/ReplicatedStorage/code/static/project")
const Result = require("@game/ReplicatedStorage/code/struct/Result")
const config_names = require("../../static/config_names")

const private = {}
const class = {}
setmetatable(class, {__index = Value})

export type class <T=unknown> = object.generic<Value.get_set_funcs<T>, {__index: typeof(class)}>

class.type = namefield.config
class.updateable = project.default_config_update_override_value

function class.new (associate_with: string|config_names.config_names?, default: unknown?)
    const this = Disposable.new(class, true)
    if (associate_with) then
        this:set_association(associate_with)
    end

    this:get_update_event():connect(function()
        if (not this.updateable) then
            return
        end
        
        const association = this:get_association()
        if (association ~= "" and type(association) == "string") then
            this:set_value(private.snapshot.result:GetValue(association))
        end
    end)

    if (default) then
        this:set_default_value(default)
    end

    return this
end

function class:get_update_event ()
    return private.update_event:get_face()
end

function class:set_association (with: string|config_names.config_names)
    const this = self :: class
    const metadata = private.metadata:fetch(this)
    metadata.associate_with = with
end

function class:get_association () : string|config_names.config_names
    const this = self :: class
    const metadata = private.metadata:fetch(this)
    return metadata.associate_with or ""
end

private.metadata = Storage.new()
private.update_event = Event.new()
private.snapshot = Result.new() :: Result.class<ConfigSnapshot>
private.cycle_connection = nil :: RBXScriptConnection?

function private.update_cycle ()
    const timer = Timer.new(2.5)
    
    repeat
        private.snapshot = Result.call_of(function(...: unknown): unknown
            return ConfigService:GetConfigAsync()
        end)
        timer:wait_service()
    until (not private.snapshot.state)
    timer:queue_free()

    private.cycle_connection = private.snapshot.result.UpdateAvailable:Once(function()
        private.update_cycle()
        private.update_event:emit()
    end)
end

private.update_cycle()

return table.freeze(class)