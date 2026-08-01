--!strict

const EnumObject = require("@game/ReplicatedStorage/code/class/arch/EnumObject")
const EnumItem = require("@game/ReplicatedStorage/code/class/arch/EnumItem")
const declare = require("@game/ReplicatedStorage/code/static/declare")

const class = EnumObject:new({
	name = "ControllerNotificationVariant",

	Continue = EnumItem:new({ name = "Continue" }),
	Pause = EnumItem:new({ name = "Pause" }),
	Reset = EnumItem:new({ name = "Reset" }),
})

return class
