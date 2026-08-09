--!strict

const EnumObject = require("@game/ReplicatedStorage/class/arch/EnumObject")
const EnumItem = require("@game/ReplicatedStorage/class/arch/EnumItem")
const declare = require("@game/ReplicatedStorage/static/declare")

const class : declare.enum_instance_notification_variant = EnumObject:new({
	name = script.Name,
	Destroyed = EnumItem:new() :: declare.enumitem<any>,
	Newwie = EnumItem:new() :: declare.enumitem<any>,
	Changed = EnumItem:new() :: declare.enumitem<any>,
	Nullified = EnumItem:new() :: declare.enumitem<any>,
})

return class
