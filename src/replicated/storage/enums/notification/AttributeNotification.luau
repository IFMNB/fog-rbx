--!strict
const EnumItem = require("@game/ReplicatedStorage/class/arch/EnumItem")
const EnumObject = require("@game/ReplicatedStorage/class/arch/EnumObject")
const declare = require("@game/ReplicatedStorage/static/declare")

const class: declare.enum_attribute_notification = EnumObject:new({
	name = script.Name,
	Added = EnumItem:new() :: declare.enumitem<any>,
	Changed = EnumItem:new() :: declare.enumitem<any>,
	Removed = EnumItem:new() :: declare.enumitem<any>,
})

return class
