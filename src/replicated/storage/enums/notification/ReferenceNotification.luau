--!strict
const EnumItem = require("@game/ReplicatedStorage/class/arch/EnumItem")
const EnumObject = require("@game/ReplicatedStorage/class/arch/EnumObject")
const declare = require("@game/ReplicatedStorage/static/declare")

const class: declare.enum_reference_notification = EnumObject:new({
	name = script.Name,

	NewInstance = EnumItem:new() :: declare.enumitem<any>,
	ChangedInstance = EnumItem:new() :: declare.enumitem<any>,
	DestroyedInstance = EnumItem:new() :: declare.enumitem<any>,
	NullifiedInstance = EnumItem:new() :: declare.enumitem<any>,
})

return class
