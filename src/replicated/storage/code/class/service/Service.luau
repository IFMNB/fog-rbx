const object = require("@game/ReplicatedStorage/code/object")
const class_names = require("../../static/class_names")

const class = {__index = object}
setmetatable(class, class)

class.type = class_names.service

function class.new ()
	return error("new() is not allowed")
end

table.freeze(class)
return class