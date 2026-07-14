const object = require("@game/ReplicatedStorage/code/object")
const namefield = require("@game/ReplicatedStorage/code/static/namefield")
const project = require("@game/ReplicatedStorage/code/static/project")
const Disposable = require("../../Disposable")
const Face = require("../face/Face")
const Connection = require("../connection/Connection")
const ConnectionState = require("../../enums/ConnectionState")
const Attribute = require("../attribute/Attribute")
const Node = require("../node/Node")
const Event = require("@game/ReplicatedStorage/code/class/event/Event")
const Storage = require("@game/ReplicatedStorage/code/class/storage/Storage")
const Upload = require("@game/ReplicatedStorage/code/class/upload/Upload")

const private = {}
const class = {__index = Disposable}
setmetatable(class, class)

export type class = typeof(class.new())
export type get_set_funcs <T=any> = {
    get_value: (self: unknown) -> T,
    set_value: (self: unknown, to: T) -> (),
    set_default_value: (self: unknown, default: T) -> ()
}
export type generic<T=any> = setmetatable<get_set_funcs<T>, {__index: class}>

class.type = namefield.value

function class.new(generate_default_type: "number"|"string"|"boolean"?)
    const this = Disposable.new(class, true)

    if (generate_default_type) then
        private.default_generator[generate_default_type](this)
    end

    return this
end

private.default_generator = table.freeze {
    number = function (this: class)
        this:set_default_value(0)
        this:set_expected_type(0)
    end,
    string = function (this: class)
        this:set_default_value("")
        this:set_expected_type("")
    end,
    boolean = function (this: class)
        this:set_default_value(false)
        this:set_expected_type(false)
    end
}

function class:get_value () : unknown
    const this = self :: class
    const metadata = private.values:fetch(this)
    return metadata.value or metadata.default
end

function class:set_expected_type(value_that_should_converted_to_type: any|"any")
    const this = self :: class
    private.values:fetch(this).value_type = value_that_should_converted_to_type == "any" and value_that_should_converted_to_type or typeof(value_that_should_converted_to_type)
end

function class:get_expected_type() : string|"any"
    const this = self :: class
    return private.values:fetch(this).value_type or "any"
end

function class:set_default_value(default: any)
   const this = self :: class
   private.values:fetch(this).default = default 
end

function class:set_value (to: any)
    const this = self :: class
    const T = typeof(to)
    const metadata = private.values:fetch(this)

    if (metadata.value == to) then
        return
    end

    const expected_T = metadata.value_type

    if (T ~= expected_T and expected_T ~= "any") then
        project.console_output("attempt to set unexpected value with wrong type")
        return
    end

    const old_value = metadata.value
    metadata.value = to

    if (private.changed_event_ctrl:is_exists(this)) then
        private.changed_event_ctrl:fetch(this, Event.new):emit(to, old_value)
    end
end

function class:get_changed_event()
    const this = self :: class
    return private.changed_event_ctrl:fetch(this, Event.new, function (new: Event.class)
       this:watch_free_event(new)
    end):get_face() :: Face.class<any, any>
end

-- Кооперация с нодами.
function class:create_attribute (to: Node.class, name: string)
    const this = self :: class
    const instance = to:get_instance()
    const attribute = Attribute.new(instance, name, this:get_value())
    
    local newly
    const connection = this:get_changed_event():connect(function(a0, a1)
        if (a0 == newly) then
            return
        else
            newly = a0
            attribute:set(a0)
        end
    end)
    const connection2 = attribute:get_face():connect(function(a0, a1)
        if (a0 == newly) then
            return
        else
            newly = a0
            this:set_value(a0)
        end
    end)

    local attribute_free : () -> ()
    attribute_free = function ()
        connection:disconnect()
        connection2:disconnect()

        if (attribute.is_free) then
            this:unwatch_free_event(attribute_free)
        end
        if (this.is_free) then
            attribute:unwatch_free_event(attribute_free)
        end
    end

    attribute:watch_free_event(attribute_free)
    this:watch_free_event(attribute_free)

    return attribute
end

function class:bind_attribute (to: Node.class, name: string?)
    const this = self :: class
    if (to:is_initiated()) then
        this:create_attribute(to, name)
    else
        local connection : Connection.class
        const watcher = function()
            if (connection.state == ConnectionState.connected) then
                connection:disconnect()
            end
        end
        connection = to:get_initiate_event():once(function()
            this:create_attribute(to, name)
            this:unwatch_free_event(watcher)
        end)
    end
end

private.changed_event_ctrl = Upload.new()
private.values = Storage.new()

return table.freeze(class)