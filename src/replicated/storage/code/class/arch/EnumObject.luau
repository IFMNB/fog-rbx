--!strict

const object = require("../../object")
const declare = require("../../static/declare")
const namefield = require("../../static/namefield")
const EnumItem = require("./EnumItem")

const class : declare.enumobject = object:new({
    type = namefield.enumobject,
    Unknown = EnumItem:new({name = "Unknown"}),
    name = "EnumObject",

    get_enums_list = function <T> (self: declare.enumobject) 
        const result: { declare.enumitem } = {}
        for i, v in self :: { [string]: unknown } do
            if object.is(v, self.type) then
                table.insert(result, v :: declare.enumitem)
            end 
        end

        return result
    end,

    get_enums_count = function (self: declare.enumobject) : number
        return #self:get_enums_list()
    end,

    get_enums_name = function (...: declare.enumitem): ...string
        const result: {string} = {}
        for i,v in {...} do
            table.insert(result, v.name)
        end

        return unpack(result)
    end,

    generate_enumitem = function (self: declare.enumobject, itemname: string) : declare.enumitem
        return require "./EnumItem":new({
            name = itemname,
            enumobject = self
        })
    end,

    is_my_enumitem = function (self: declare.enumobject, that: declare.enumitem) : boolean
        return self[that.name] ~= nil
    end
});

return class