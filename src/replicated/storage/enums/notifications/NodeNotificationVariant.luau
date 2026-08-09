--!strict

const EnumObject = require("@game/ReplicatedStorage/class/arch/EnumObject")
const EnumItem = require("@game/ReplicatedStorage/class/arch/EnumItem")
const declare = require("@game/ReplicatedStorage/static/declare")

const class: declare.enum_node_notification_variant = EnumObject:new({
	name = script.Name,
	ProcessStepped = EnumItem:new() :: declare.enumitem<any>,
	SimulationStepped = EnumItem:new() :: declare.enumitem<any>,
	AttributeAdded = EnumItem:new() :: declare.enumitem<any>,
	AttributeRemoved = EnumItem:new() :: declare.enumitem<any>,
})

return class
