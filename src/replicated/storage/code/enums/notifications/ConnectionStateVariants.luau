--!strict

const EnumObject = require("@game/ReplicatedStorage/code/class/arch/EnumObject")
const EnumItem = require("@game/ReplicatedStorage/code/class/arch/EnumItem")
const declare = require("@game/ReplicatedStorage/code/static/declare")

const class = EnumObject:new({
	name = "NodeNotificationVariant",

	Normal = EnumItem:new({ name = "Normal" }),
    ChangingCallOn = EnumItem:new({ name = "ChangingCallOn" }),
})

return class
