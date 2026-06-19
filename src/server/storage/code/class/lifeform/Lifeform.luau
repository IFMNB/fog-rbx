const object = require("@game/ReplicatedStorage/code/object")
const class_names = require("@game/ReplicatedStorage/code/static/class_names")
const project_settings = require("@game/ReplicatedStorage/code/static/project_settings")
const Creature = require("../creature/Creature")

const private = {}
const class = {__index = Creature}
setmetatable(class, class)

export type class = typeof(class.new())

class.type = class_names.lifeform

function class.new()
    return object.new(class, true)
end

return table.freeze(class)