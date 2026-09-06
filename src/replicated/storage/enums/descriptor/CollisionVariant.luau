--!strict
const EnumItem = require("@game/ReplicatedStorage/class/arch/EnumItem")
const EnumObject = require("@game/ReplicatedStorage/class/arch/EnumObject")
const declare = require("@game/ReplicatedStorage/static/declare")

const class: declare.enum_collision_variant = EnumObject:new({
	name = script.Name,

    DefaultGroup= EnumItem:new() :: declare.enumitem<any>,
    ItemGroup= EnumItem:new() :: declare.enumitem<any>,
    CharacterGroup= EnumItem:new() :: declare.enumitem<any>,
    DebrisGroup= EnumItem:new() :: declare.enumitem<any>,
})

return class
