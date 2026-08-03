--!strict

const EnumObject = require("@game/ReplicatedStorage/class/arch/EnumObject")
const EnumItem = require("@game/ReplicatedStorage/class/arch/EnumItem")
const declare = require("@game/ReplicatedStorage/static/declare")

const class = EnumObject:new({
	name = "NodeNotificationVariant",

	Normal = EnumItem:new({ name = "Normal" }),
	ChangingCallOn = EnumItem:new({ name = "ChangingCallOn" }),
})

return class
