--!strict

const EnumObject = require("@game/ReplicatedStorage/code/class/arch/EnumObject")
const EnumItem = require("@game/ReplicatedStorage/code/class/arch/EnumItem")
const declare = require("@game/ReplicatedStorage/code/static/declare")

const class = EnumObject:new({
	name = "NodeNotificationVariant",

	Invoke = EnumItem:new({ name = "Invoke" }),
    Await = EnumItem:new({ name = "Await" }),
})

return class
