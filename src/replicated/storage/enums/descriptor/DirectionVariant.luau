--!strict

const EnumObject = require("@game/ReplicatedStorage/class/core/EnumObject")
const EnumItem = require("@game/ReplicatedStorage/class/core/EnumItem")

const class: enum_direction_variant = EnumObject:new({
	name = script.Name,

	Up = EnumItem:new() :: enumitem<any>,
	Bottom = EnumItem:new() :: enumitem<any>,
	Left = EnumItem:new() :: enumitem<any>,
	Right = EnumItem:new() :: enumitem<any>,
	Front = EnumItem:new() :: enumitem<any>,
	Back = EnumItem:new() :: enumitem<any>,
})

return class
