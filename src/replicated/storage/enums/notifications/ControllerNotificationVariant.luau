--!strict

const EnumObject = require("@game/ReplicatedStorage/class/arch/EnumObject")
const EnumItem = require("@game/ReplicatedStorage/class/arch/EnumItem")
const declare = require("@game/ReplicatedStorage/static/declare")

const class = EnumObject:new({
	name = "ControllerNotificationVariant",

	Continue = EnumItem:new({ name = "Continue" }),
	Pause = EnumItem:new({ name = "Pause" }),
	Reset = EnumItem:new({ name = "Reset" }),
})

return class
