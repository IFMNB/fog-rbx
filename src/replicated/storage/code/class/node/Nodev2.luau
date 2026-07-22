--!strict

const Disposable = require("../../Disposable")
const object = require("../../object")
const namefield = require("../../static/namefield")
const Attribute = require("../attribute/Attribute")
const Face = require("../face/Face")

const private = {}
const class = {__index = Disposable}
setmetatable(class, class)

export type class<T = Instance> = object.class<typeof(class)>

class.type = namefield.node
class.tag = "#"..class.type
class.instancetype = "Object" :: "Object"|string

function class.new (as: Instance?)
    const this = Disposable.new(class, true)

    return this
end



function class:beep (d: Disposable.class)
    
end

function class:initiate (as: Instance)
    
end

function class:get_attribute_list () : {Attribute.class}
    
end

function class:get_initiate_event () : Face.class
    
end

function class:get_notification_event () : Face.class<>
    
end

return table.freeze(class)