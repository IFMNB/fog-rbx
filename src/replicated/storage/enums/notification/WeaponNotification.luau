--!strict
const EnumItem = require("@game/ReplicatedStorage/class/arch/EnumItem")
const EnumObject = require("@game/ReplicatedStorage/class/arch/EnumObject")
const declare = require("@game/ReplicatedStorage/static/declare")

const class: declare.enum_weapon_notification = EnumObject:new({
	name = script.Name,

    Shoot = EnumItem:new() :: declare.enumitem<any>,
    Aim = EnumItem:new() :: declare.enumitem<any>,
    Special = EnumItem:new() :: declare.enumitem<any>,
    Action = EnumItem:new() :: declare.enumitem<any>,
})

return class
