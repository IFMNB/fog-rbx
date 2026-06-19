const object = require("./object")

const private = {};
const class = {__index = object};
setmetatable(class,class)

export type class = typeof(class.new())
export type item = number

class.type = "enum" :: "enum"

private.id_counter = 1

function private.check_id(id: number?)
	if not id then
		private.id_counter += 1
		return private.id_counter
	else
		return id
	end
end

function private.check_name(name: string?)
	if not name then
		return "unnamed_enum"..private.id_counter
	else
		return name
	end
end

function class.new(class: {}, _: string?, id: number?) : item
	if (id) then
		return id
	else
		private.id_counter += 1
		return private.id_counter
	end
end

table.freeze(class :: any)
return class