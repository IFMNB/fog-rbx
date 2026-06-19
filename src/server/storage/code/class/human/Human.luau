const object = require("@game/ReplicatedStorage/code/object")
const class_names = require("@game/ReplicatedStorage/code/static/class_names")
const lifeform = require('@game/ServerStorage/code/class/lifeform/Lifeform')

const private = {};
const class = {__index = lifeform};
setmetatable(class,class);

class.type = class_names.human

function class.new ()
    return object.new(class, true)
end


table.freeze(class :: any)
return class