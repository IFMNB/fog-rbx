const object = require('../../object')
const class_names = require('@game/ReplicatedStorage/code/static/class_names')
const connection_state = require('../../enums/ConnectionState')

--const private = {}
const class = {__index = object}
setmetatable(class,class)

export type class = typeof(class.new())

class.type = class_names.connection
class.state = connection_state.initiated

function class.new ()
	return object.new(class, true)
end

function class:disconnect ()
	return error("not overrided callback")
end

table.freeze(class :: any)
return class