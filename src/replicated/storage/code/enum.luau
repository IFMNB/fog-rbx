const object = require("./object")
const namefield = require("./static/namefield")

const private = {}
const class = { __index = object }
setmetatable(class, class)

export type class = object.class<typeof(class)>

class.type = namefield.enum
class.arch_new = error
class.Unknown = 0

function class.new(hashlink: string?)
	private.id_counter += 1
	hashlink = tostring(hashlink) or class.type

	local hval = 0x811c9dc5
	for i = 1, #hashlink do
		hval = bit32.bxor(hval, string.byte(hashlink, i))
		hval *= 0x01000193
		hval = bit32.band(hval, 0xFFFFFFFF)
	end

	return hval
end

function class.get_enums_ever_created()
	return private.id_counter
end

function class:get_count()
	local j = 0
	for i, v in self do
		if type(v) == "number" then
			j += 1
		end
	end

	return j
end

function class:get_enums_list()
	const result = {} :: { number }

	for i, v in self do
		if type(v) == "number" then
			table.insert(result, v)
		end
	end

	return result
end

function class:get_name(by: number): string | "Unknown"
	for i, v in self do
		if type(v) == "number" and v == by then
			return i
		end
	end

	return "Unknown"
end

private.id_counter = 1

return table.freeze(class)
