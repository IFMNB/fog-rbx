--!strict

const EnumObject = require("@game/ReplicatedStorage/class/arch/EnumObject")
const EnumItem = require("@game/ReplicatedStorage/class/arch/EnumItem")
const declare = require("@game/ReplicatedStorage/static/declare")

const class: declare.enum_value_notification_variant = EnumObject:new({
	name = script.Name,

	LazyValueNew = EnumItem:new() :: declare.enumitem<any>,
	LazyValueGet = EnumItem:new() :: declare.enumitem<any>,
	LazyValueRemoved = EnumItem:new() :: declare.enumitem<any>,
	LazyValueChanged = EnumItem:new() :: declare.enumitem<any>,
	ValueNew = EnumItem:new() :: declare.enumitem<any>,
	ValueGet = EnumItem:new() :: declare.enumitem<any>,
	ValueRemoved = EnumItem:new() :: declare.enumitem<any>,
	ValueChanged = EnumItem:new() :: declare.enumitem<any>,
})

return class
