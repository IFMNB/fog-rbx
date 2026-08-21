--!strict

const EnumObject = require("@game/ReplicatedStorage/class/arch/EnumObject")
const EnumItem = require("@game/ReplicatedStorage/class/arch/EnumItem")
const declare = require("@game/ReplicatedStorage/static/declare")

const class: declare.enum_ammo_variant = EnumObject:new({
	name = script.Name,

	["5.8x"] = EnumItem:new() :: declare.enumitem<any>,
	["6.4x"] = EnumItem:new() :: declare.enumitem<any>,
	["14.4x"] = EnumItem:new() :: declare.enumitem<any>,
	["9.3x"] = EnumItem:new() :: declare.enumitem<any>,
})

return class
