--!strict

const EnumObject = require("@game/ReplicatedStorage/class/arch/EnumObject")
const EnumItem = require("@game/ReplicatedStorage/class/arch/EnumItem")
const declare = require("@game/ReplicatedStorage/static/declare")

const class: declare.enum_bb_variant = EnumObject:new({
	name = script.Name,

	AABB = EnumItem:new() :: declare.enumitem<any>,
	OBB = EnumItem:new() :: declare.enumitem<any>,
})

return class
