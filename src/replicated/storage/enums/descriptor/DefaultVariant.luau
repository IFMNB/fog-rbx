--!strict
const EnumItem = require("@game/ReplicatedStorage/class/arch/EnumItem")
const EnumObject = require("@game/ReplicatedStorage/class/arch/EnumObject")
const declare = require("@game/ReplicatedStorage/static/declare")

const class: declare.enum_default_variant = EnumObject:new({
	name = script.Name,
	Unknown = EnumItem:new() :: declare.enumitem<any>,
	Any = EnumItem:new() :: declare.enumitem<any>,
})

return class
