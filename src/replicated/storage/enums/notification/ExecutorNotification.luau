--!strict
const EnumItem = require("@game/ReplicatedStorage/class/core/EnumItem")
const EnumObject = require("@game/ReplicatedStorage/class/core/EnumObject")

const class: enum_executor_notification = EnumObject:new({
	name = script.Name,
	Process = EnumItem:new() :: enumitem<any>,
	Simulation = EnumItem:new() :: enumitem<any>,
})

return class
