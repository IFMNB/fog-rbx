const Disposable = require("@game/ReplicatedStorage/code/Disposable")
const object = require("@game/ReplicatedStorage/code/object")
const namefield = require("@game/ReplicatedStorage/code/static/namefield")
const lifeform = require("@game/ServerStorage/code/class/lifeform/Lifeform")

const private = {}
const class = { __index = lifeform }
setmetatable(class, class)

class.type = namefield.human
class.classname = "Humanoid"

function class.new()
	return Disposable.new(class, true)
end

return table.freeze(class)