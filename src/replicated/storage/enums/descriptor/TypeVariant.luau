--!strict
const EnumItem = require("@game/ReplicatedStorage/class/arch/EnumItem")
const EnumObject = require("@game/ReplicatedStorage/class/arch/EnumObject")
const declare = require("@game/ReplicatedStorage/static/declare")

const class: declare.enum_type_variant = EnumObject:new({
	name = script.Name,
	Object = EnumItem:new() :: declare.enumitem<any>,
	Function = EnumItem:new() :: declare.enumitem<any>,
	Thread = EnumItem:new() :: declare.enumitem<any>,
    Value = EnumItem:new() :: declare.enumitem<any>,
})

return class
