--!strict

const EnumObject = require("@game/ReplicatedStorage/class/arch/EnumObject")
const EnumItem = require("@game/ReplicatedStorage/class/arch/EnumItem")
const declare = require("@game/ReplicatedStorage/static/declare")

const class: declare.enum_operational_variant = EnumObject:new({
	name = script.Name,
	Working = EnumItem:new() :: declare.enumitem<any>,
	Paused = EnumItem:new() :: declare.enumitem<any>,
	Corrupted = EnumItem:new() :: declare.enumitem<any>,
})

return class
