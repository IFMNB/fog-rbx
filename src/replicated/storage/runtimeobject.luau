--!strict

const object = require("./object")
const declare = require("./static/declare")
const namefield = require("./static/namefield")

const class: declare.runtimeobject = object:new {
	type = namefield.runtimeobject,
	created_at = DateTime.now(),
}

class:host(function(new: declare.runtimeobject)
	new.created_at = DateTime.now()
end)

return class
