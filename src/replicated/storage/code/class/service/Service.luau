const object = require("@game/ServerStorage/code/object")

const class = {}
class.__index = object
setmetatable(class, class)

function class.new ()
	error("new() is not allowed")
end


table.freeze(class :: any)
return class