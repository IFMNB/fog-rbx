const object = require("@game/ReplicatedStorage/object")
const Warfare = require("../warfare/Warfare")
const namefield = require("@game/ReplicatedStorage/static/namefield")

const private = {}
const class = { __index = object }
setmetatable(class, class)

export type class = typeof(class.new())

class.type = namefield.gameloop

function class.new()
	return object.new(class, true)
end

function class:start()
	error("gameloop should be overrided")
end

return table.freeze(class)
