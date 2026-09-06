--!strict

const EnumObject = require("@game/ReplicatedStorage/class/arch/EnumObject")
const EnumItem = require("@game/ReplicatedStorage/class/arch/EnumItem")
const declare = require("@game/ReplicatedStorage/static/declare")

const class: declare.enum_direction_variant = EnumObject:new({
	name = script.Name,

	Up = EnumItem:new() :: declare.enumitem<any>,
	Bottom = EnumItem:new() :: declare.enumitem<any>,
	Left = EnumItem:new() :: declare.enumitem<any>,
	Right = EnumItem:new() :: declare.enumitem<any>,
	Front = EnumItem:new() :: declare.enumitem<any>,
	Back = EnumItem:new() :: declare.enumitem<any>,
})

return class
