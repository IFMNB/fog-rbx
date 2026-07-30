--!strict
const namefield = require("./namefield")
const project = require("./project")

const userdata : instance = newproxy(true)
const mt = getmetatable(userdata)
const out = "empty-instance used" :: "empty-instance used"

export type instance = setmetatable<{
	type: string | "any",
	is: (...any) -> true,
	is_empty_sentinel: true,
    [any]: any
}, { [any]: any }>

const noop = function <T> (...: any) : T
	project.console_out_error(out, ...)
	return nil
end
const ret_self = function <T> (a: T): T
	project.console_out_error(out)
	return a
end
const ret_index_or_nil = function(a: any, b: string) : any
	project.console_out_error(out, a, b)

	if type(b) == "string" then
		if b:sub(1, #"__") ~= "__" then
			const result = mt[b]
			return result ~= nil and result
		end
	end

	return userdata
end
const ret_userdata = function()
	project.console_out_error(out)
	return 
end
const ret_false = function(): false
	project.console_out_error(out)
	return false
end
const ret_true = function(): true
	project.console_out_error(out)
	return true
end
const ret_zero = function(): number
	project.console_out_error(out)
	return 0
end
const ret_empty = function(): string
	project.console_out_error(out)
	return ""
end
const noinit = function(...: any): (...any) -> any
	project.console_out_error(out)
	return noop
end

mt.__index = ret_index_or_nil
mt.__newindex = noop
mt.__namecall = ret_userdata
mt.__call = ret_userdata
mt.__tostring = ret_empty
mt.__metatable = userdata
mt.__len = ret_zero
mt.__eq = ret_false
mt.__lt = ret_false
mt.__le = ret_false
mt.__add = ret_self
mt.__sub = ret_self
mt.__mul = ret_self
mt.__div = ret_self
mt.__idiv = ret_self
mt.__mod = ret_self
mt.__pow = ret_self
mt.__unm = ret_self
mt.__concat = ret_empty
mt.__iter = noinit

mt.type = namefield.anyt
mt.is = ret_true
mt.is_empty_sentinel = true
table.freeze(mt)

return userdata