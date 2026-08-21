--!strict
const EnumItem = require("@game/ReplicatedStorage/class/arch/EnumItem")
const EnumObject = require("@game/ReplicatedStorage/class/arch/EnumObject")
const declare = require("@game/ReplicatedStorage/static/declare")

const class: declare.enum_operation_variant = EnumObject:new({
	name = script.Name,
	Get = EnumItem:new() :: declare.enumitem<any>,
	Remove = EnumItem:new() :: declare.enumitem<any>,
	New = EnumItem:new() :: declare.enumitem<any>,
	Change = EnumItem:new() :: declare.enumitem<any>,
	Null = EnumItem:new() :: declare.enumitem<any>,
})

return class
