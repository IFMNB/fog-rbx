--!strict
const EnumItem = require("@game/ReplicatedStorage/class/arch/EnumItem")
const EnumObject = require("@game/ReplicatedStorage/class/arch/EnumObject")
const declare = require("@game/ReplicatedStorage/static/declare")

const class: declare.enum_physx_mode_variant = EnumObject:new({
	name = script.Name,
	Local = EnumItem:new() :: declare.enumitem<any>,
	Global = EnumItem:new() :: declare.enumitem<any>,
})

return class
