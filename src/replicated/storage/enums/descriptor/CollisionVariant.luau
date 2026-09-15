--!strict
const EnumItem = require("@game/ReplicatedStorage/class/core/EnumItem")
const EnumObject = require("@game/ReplicatedStorage/class/core/EnumObject")

const class: enum_collision_variant = EnumObject:new({
	name = script.Name,

	DefaultGroup = EnumItem:new() :: enumitem<any>,
	ItemGroup = EnumItem:new() :: enumitem<any>,
	CharacterGroup = EnumItem:new() :: enumitem<any>,
	DebrisGroup = EnumItem:new() :: enumitem<any>,
})

return class
