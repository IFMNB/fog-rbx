--!strict

const EnumObject = require("@game/ReplicatedStorage/class/arch/EnumObject")
const EnumItem = require("@game/ReplicatedStorage/class/arch/EnumItem")
const declare = require("@game/ReplicatedStorage/static/declare")

const class = EnumObject:new({
	name = "NodeNotificationVariant",

	Invoke = EnumItem:new({ name = "Invoke" }),
	Await = EnumItem:new({ name = "Await" }),
})

return class
