--!strict
const EnumItem = require("@game/ReplicatedStorage/class/arch/EnumItem")
const EnumObject = require("@game/ReplicatedStorage/class/arch/EnumObject")
const declare = require("@game/ReplicatedStorage/static/declare")
const dgame = require("@game/ReplicatedStorage/static/dgame")

const class: dgame.enum_soul_require = EnumObject:new({
	name = script.Name,

	LoadOut = EnumItem:new() :: declare.enumitem<any>,
    LoadClass = EnumItem:new() :: declare.enumitem<any>,
    WeaponStat = EnumItem:new() :: declare.enumitem<any>,
    WeaponryOpened = EnumItem:new() :: declare.enumitem<any>,
    ArmorStat = EnumItem:new() :: declare.enumitem<any>,
    ArmoryOpened = EnumItem:new() :: declare.enumitem<any>,
    Misc  = EnumItem:new() :: declare.enumitem<any>,
})

return class
