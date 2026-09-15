--!strict
const EnumItem = require("@game/ReplicatedStorage/class/core/EnumItem")
const EnumObject = require("@game/ReplicatedStorage/class/core/EnumObject")
const declare = require("@game/ReplicatedStorage/static/declare")
const dgame = require("@game/ReplicatedStorage/static/dgame")

const class: dgame.enum_weapon_variant = EnumObject:new({
	name = script.Name,

	Ray = EnumItem:new() :: declare.enumitem<any>,
	Shell = EnumItem:new() :: declare.enumitem<any>,
	Zone = EnumItem:new() :: declare.enumitem<any>,
})

return class
