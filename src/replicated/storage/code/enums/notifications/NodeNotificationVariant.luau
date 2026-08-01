--!strict

const EnumObject = require("@game/ReplicatedStorage/code/class/arch/EnumObject")
const EnumItem = require("@game/ReplicatedStorage/code/class/arch/EnumItem")
const declare = require("@game/ReplicatedStorage/code/static/declare")

const class = EnumObject:new({
	name = "NodeNotificationVariant",

	ProcessStepped = EnumItem:new({ name = "ProcessStepped" }),
	SimulationStepped = EnumItem:new({ name = "SimulationStepped" }),
	AttributeAdded = EnumItem:new({ name = "AttributeAdded" }),
	AttributeRemoved = EnumItem:new({ name = "AttributeRemoved" }),

})

return class
