--!strict
const EnumItem = require("@game/ReplicatedStorage/class/arch/EnumItem")
const EnumObject = require("@game/ReplicatedStorage/class/arch/EnumObject")
const declare = require("@game/ReplicatedStorage/static/declare")

const class: declare.enum_input_notification = EnumObject:new({
	name = script.Name,

	CodeAdded = EnumItem:new() :: declare.enumitem<any>,
	CodeRemoved = EnumItem:new() :: declare.enumitem<any>,
	Pressed = EnumItem:new() :: declare.enumitem<any>,
	Clamped = EnumItem:new() :: declare.enumitem<any>,
	Unpressed = EnumItem:new() :: declare.enumitem<any>,
	Unclampled = EnumItem:new() :: declare.enumitem<any>,
	RelatedChanged = EnumItem:new() :: declare.enumitem<any>,
	RelatedNullified = EnumItem:new() :: declare.enumitem<any>,
})

return class
