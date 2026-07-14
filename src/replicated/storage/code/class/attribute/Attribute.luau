const Disposable = require("../../Disposable")
const object = require("../../object")
const namefield = require("../../static/namefield")
const project = require("../../static/project")
const Event = require("../event/Event")
const Face = require("../face/Face")
const Storage = require("../storage/Storage")
const Upload = require("../upload/Upload")

const private = {}
const class = {}
setmetatable(class, {__index = Disposable})

export type class = object.class<typeof(class)>

class.type = namefield.attribute

function class.new (of: Instance, name: string?, default: unknown?)
    const this = Disposable.new(class, true)
    const metadata = private.metadata:fetch(this)
    metadata.name = name or "@attribute"..this.identity
    metadata.instance = of
    metadata.last_value = default or "@never"

    if (default ~= nil and private.attribute_expected_types[typeof(default)] == nil) then
        assert(not project.debug_mode, "unexpected value type")
    end

    of.Destroying:Once(function()
        this:free()
    end)

    of:SetAttribute(metadata.name, metadata.last_value)
    const connection = of:GetAttributeChangedSignal(metadata.name):Connect(function(...)
        const new_value = of:GetAttribute(metadata.name)
        if (private.events:is_exists(this)) then
            private.events:fetch(this, Event.new):emit(new_value, metadata.last_value)
        end
        metadata.last_value = new_value
    end)

    this:watch_free_event(connection)

   return this
end

function class:get_name() : string
    const this = self :: class
    const metadata = private.metadata:fetch(this)
    return metadata.name
end

function class:set (to: any)
    const this = self :: class
    const metadata = private.metadata:fetch(this)
    const instance = metadata.instance :: Instance
    
    if (private.attribute_expected_types[typeof(to)] ~= nil) then
        instance:SetAttribute(metadata.name, to)
    else
        assert(not project.debug_mode, "attempt to set unexpected value to attribute, abort")
    end
end

function class:get_value()
    const this = self :: class
    const metadata = private.metadata:fetch(this)
    const instance = metadata.instance :: Instance
    return instance:GetAttribute(metadata.name)
end

function class:get_previous_value ()
    const this = self :: class
    const metadata = private.metadata:fetch(this)
    return metadata.last_value
end

function class:get_face ()
    const this = self :: class
    return private.events:fetch(this, Event.new):get_face() :: Face.class<any,any>
end

private.events = Upload.new()
private.metadata = Storage.new()
private.attribute_expected_types = table.freeze ({
    string = true,
    boolean = true,
    number = true,
    Vector3 = true,
    Vector2 = true,
    CFrame = true,
    Color3 = true,
    UDim = true,
    UDim2 = true,
    BrickColor = true,
    NumberSequence = true,
    ColorSequence = true,
    NumberRange = true,
    Font = true,
    Rect = true,
    EnumItem = true
}) :: {[string]: boolean}

return table.freeze(class)