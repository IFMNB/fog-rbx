--!strict

const object = require("@game/ReplicatedStorage/code/object")
const declare = require("@game/ReplicatedStorage/code/static/declare")
const namefield = require("@game/ReplicatedStorage/code/static/namefield")

const private = {}
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
        return table.freeze(self:clone())
    end,

    is_immutable = function (self: declare.record) : boolean
        return table.isfrozen(self)
    end,

    clone = function (self: declare.record) : any
        const base = assert(self:get_base<<declare.record>>(namefield.record), "cannot clone nil")
        return base:new(private.recursive_convertion(self))
    end,

    each = function (self: declare.record, type: string, f: (value: any) -> any) : ()
        return private.for_each_element_with_type_do(self, type, f) :: any
    end
})

do
    function private.for_each_element_with_type_do(that: declare.record, type: string, f: (value: unknown) -> unknown)
        for i, v in that :: { [unknown]: unknown } do
            if typeof(v) == type then
                that[i] = f(v)
            end
        end

        return that
    end

    function private.recursive_convertion(self: {[unknown]: unknown}|{}): { [unknown]: unknown }
        const result: {[unknown]: unknown} = {}

        for i, v in self :: {[unknown]: unknown} do
            result[ class.is(class.get_base(i), namefield.record) and class.clone(i) or
                type(i) == "table" and private.recursive_convertion(i :: {[unknown]: unknown} or
                i) ] = class.is(class.get_base(v), namefield.record) and class.clone(v) or
                type(v) == "table" and private.recursive_convertion(v :: {[unknown]: unknown} or
                v)
        end

        return result
    end
end



return class