--!strict
const EnumItem = require("@game/ReplicatedStorage/class/core/EnumItem")
const EnumObject = require("@game/ReplicatedStorage/class/core/EnumObject")

const class: enum_character_parameter_variant = EnumObject:new({
	name = script.Name,

	Health = EnumItem:new() :: enumitem<any>,
	Speed = EnumItem:new() :: enumitem<any>,
	Stamina = EnumItem:new() :: enumitem<any>,
	RunSpeed = EnumItem:new() :: enumitem<any>,
	JumpCooldown = EnumItem:new() :: enumitem<any>,
	RunCooldown = EnumItem:new() :: enumitem<any>,
	Revives = EnumItem:new() :: enumitem<any>,
})

return class