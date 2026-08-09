--!strict

const EnumObject = require("@game/ReplicatedStorage/class/arch/EnumObject")
const EnumItem = require("@game/ReplicatedStorage/class/arch/EnumItem")
const declare = require("@game/ReplicatedStorage/static/declare")

const class : declare.enum_controller_notification_variant = EnumObject:new({
	name = script.Name,
	Continue = EnumItem:new() :: declare.enumitem<any>,
	Pause = EnumItem:new() :: declare.enumitem<any>,
	Reset = EnumItem:new() :: declare.enumitem<any>,
})

return class
