const Disposable = require("@game/ReplicatedStorage/Disposable")
const object = require("@game/ReplicatedStorage/object")
const namefield = require("@game/ReplicatedStorage/static/namefield")
const lifeform = require("@game/ServerStorage/class/lifeform/Lifeform")

const private = {}
const class = { __index = lifeform }
setmetatable(class, class)

class.type = namefield.human
class.classname = "Humanoid"

function class.new()
	return Disposable.new(class, true)
end

return table.freeze(class)
