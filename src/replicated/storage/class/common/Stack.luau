--!strict
const runtimeobject = require("@game/ReplicatedStorage/runtimeobject")
const declare = require("@game/ReplicatedStorage/static/declare")
const doperate = require("@game/ReplicatedStorage/static/doperate")
const ftype = require("@game/ReplicatedStorage/static/ftype")

const private = {}
const class : doperate.stack = runtimeobject:new {
    type = "stack",
    max = 10000,
    
    pick = ftype:write(function <T> (self: doperate.stack) : T?
        const stack = private.stacks[self]
        const index = #stack
        const value = stack[index]
        stack[index] = nil
        return value
    end, ftype:opt(declare.anyt), "stack"),

    put = ftype:write(function <T> (self: doperate.stack, item: T) : ()
        const stack = private.stacks[self]
        stack[#stack + 1] = item

        assert(#stack <= self.max, "stack limit capacity reached")
    end, declare["nil"], "stack", declare.anyt),

    count = ftype:write(function (self: doperate.stack) : number
        return #private.stacks[self]
    end, declare.number, "stack")
}

class:host(function(new: doperate.stack)
    private.stacks[new] = {}
end)

do
    private.meta = table.freeze {__mode = "ks"}
    private.stacks = setmetatable({} :: {[doperate.stack]: {any}}, private.meta)
end

return class