--!strict

const EnumObject = require("@game/ReplicatedStorage/class/arch/EnumObject")
const EnumItem = require("@game/ReplicatedStorage/class/arch/EnumItem")
const declare = require("@game/ReplicatedStorage/static/declare")

const class = EnumObject:new({
	name = "InstanceNotificationVariant",

	InstanceDestroyed = EnumItem:new({ name = "InstanceDestroyed" }),
	InstanceNew = EnumItem:new({ name = "InstanceNew" }),
	InstanceChanged = EnumItem:new({ name = "InstanceChanged" }),
	InstanceNullified = EnumItem:new({ name = "InstanceNullified" }),
})

return class
