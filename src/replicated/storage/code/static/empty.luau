--!strict

const userdata = newproxy(true)
const mt = getmetatable(userdata)

type empty = setmetatable<{
    type: string|"any",
    is: (...any) -> true,
    is_empty_sentinel: true
} & {[any]: any}, {[any]: any}>

const noop = function(...) return userdata end
const ret_self = function(a) return a end
const ret_index_or_nil = function (a, b)
    if type(b) == "string" then
        if b:sub(1, #"__") ~= "__" then
            const result = mt[b]
            return result ~= nil and result or userdata
        end
    end

    return userdata
end
const ret_userdata = function () : empty return userdata end
const ret_false = function() : false return false end
const ret_true = function() : true return true end
const ret_zero = function() return 0 end
const ret_empty = function() return "" end
const noinit = function (...) return noop end

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

mt.type = "any"
mt.is = ret_true
mt.is_empty_sentinel = true 

table.freeze(mt)
const empty = userdata :: empty

type function neg(t)
	return types.negationof(t)
end
type f = {foo: () -> ()}
type b = setmetatable<{ beta: string }, {__index: f}>
type a = setmetatable<{alpha: number}, { __index: b }> & {}
type z = a

local function a (...: z)
    for _, v : z & neg<nil> in {...} do
        v.beta = ""
        v.alpha = 4
        v.foo()
        v.foo = function () end
    end
end

return empty