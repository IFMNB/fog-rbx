--!strict
const EnumItem = require("@game/ReplicatedStorage/class/arch/EnumItem")
const EnumObject = require("@game/ReplicatedStorage/class/arch/EnumObject")
const declare = require("@game/ReplicatedStorage/static/declare")

const class: declare.enum_executor_notification = EnumObject:new({
	name = script.Name,
	Process = EnumItem:new() :: declare.enumitem<any>,
	Simulation = EnumItem:new() :: declare.enumitem<any>,
})

return class
