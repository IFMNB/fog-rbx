--!strict
const runtimeobject = require("@game/ReplicatedStorage/runtimeobject")
const declare = require("@game/ReplicatedStorage/static/declare")

const private = {}
const class : declare.stack = runtimeobject:new {
    type = "stack",
    max = 10000,
    
    pick = function <T> (self: declare.stack) : T?
        const stack = private.stacks[self]
        const index = #stack
        const value = stack[index]
        stack[index] = nil
        return value
    end,

    put = function <T> (self: declare.stack, item: T) : ()
        const stack = private.stacks[self]
        stack[#stack + 1] = item

        assert(#stack <= self.max, "stack limit capacity reached")
    end,

    count = function (self: declare.stack) : number
        return #private.stacks[self]
    end
}

class:host(function(new: declare.stack)
    private.stacks[new] = {}
end)

do
    private.meta = table.freeze {__mode = "ks"}
    private.stacks = setmetatable({} :: {[declare.stack]: {any}}, private.meta)
end

return class