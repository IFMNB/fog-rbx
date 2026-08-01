--!strict

const object = require("@game/ReplicatedStorage/code/object")
const declare = require("@game/ReplicatedStorage/code/static/declare")
const namefield = require("@game/ReplicatedStorage/code/static/namefield")

const class: declare.record = object:new({
    type = namefield.record,

    get_dictionary = function (self: declare.record) : {[string]: number|boolean|string}
        const result: {[string]: number|boolean|string} = {}

        for i,v in self :: {[unknown]: unknown} do 
            const i_T = type(i)
            const v_T = type(v)

            if i_T == "string" then
                if v_T == "number" or v_T == "string" or v_T == "boolean" then
                    result[i :: string] = v :: number|boolean|string
                end
            end
        end

        return result
    end,

    immutable = function (self: declare.record) : declare.record
        return table.freeze(self:new())
    end,

    is_immutable = function (self: declare.record) : boolean
        return table.isfrozen(self)
    end
})


return class