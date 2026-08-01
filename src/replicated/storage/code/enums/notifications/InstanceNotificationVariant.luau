--!strict

const EnumObject = require("@game/ReplicatedStorage/code/class/arch/EnumObject")
const EnumItem = require("@game/ReplicatedStorage/code/class/arch/EnumItem")
const declare = require("@game/ReplicatedStorage/code/static/declare")

const class = EnumObject:new({
	name = "InstanceNotificationVariant",

	InstanceDestroyed = EnumItem:new({ name = "InstanceDestroyed" }),
	InstanceNew = EnumItem:new({ name = "InstanceNew" }),
	InstanceChanged = EnumItem:new({ name = "InstanceChanged" }),
	InstanceNullified = EnumItem:new({ name = "InstanceNullified" }),
})

return class
