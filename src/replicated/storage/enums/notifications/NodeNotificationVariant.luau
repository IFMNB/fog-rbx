--!strict

const EnumObject = require("@game/ReplicatedStorage/class/arch/EnumObject")
const EnumItem = require("@game/ReplicatedStorage/class/arch/EnumItem")
const declare = require("@game/ReplicatedStorage/static/declare")

const class = EnumObject:new({
	name = "NodeNotificationVariant",

	ProcessStepped = EnumItem:new({ name = "ProcessStepped" }),
	SimulationStepped = EnumItem:new({ name = "SimulationStepped" }),
	AttributeAdded = EnumItem:new({ name = "AttributeAdded" }),
	AttributeRemoved = EnumItem:new({ name = "AttributeRemoved" }),
})

return class
