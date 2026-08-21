--!strict
const Record = require("@game/ReplicatedStorage/class/arch/Record")
const declare = require("@game/ReplicatedStorage/static/declare")
const namefield = require("@game/ReplicatedStorage/static/namefield")

const class : declare.result = Record:new {
    type = namefield.result,
    state = false,
    result = nil,

    call_of = function <T,U> (self: declare.result, f: (...T) -> U, ...: T) : declare.result
        const state, out = pcall(f, ...)
        return self:renew({
            state = state,
            result = out
        })
    end,

    unpack = function (self: declare.result) : ...unknown
        if type(self.result) == declare.table then
            return unpack(self.result :: {unknown})
        else
            return nil
        end
    end
}

return class