--!strict
const EnumItem = require("@game/ReplicatedStorage/class/arch/EnumItem")
const EnumObject = require("@game/ReplicatedStorage/class/arch/EnumObject")
const declare = require("@game/ReplicatedStorage/static/declare")
const dgame = require("@game/ReplicatedStorage/static/dgame")

const class: dgame.enum_subaction_variant = EnumObject:new({
	name = script.Name,

	PeekLeft = EnumItem:new() :: declare.enumitem<any>,
    PeekRight = EnumItem:new() :: declare.enumitem<any>,

    PickInventorySlot = EnumItem:new() :: declare.enumitem<any>,
    PickToInventoryItemInZone = EnumItem:new() :: declare.enumitem<any>,
    PickToInventoryItemOnLineOfSight = EnumItem:new() :: declare.enumitem<any>,
    PickItemInZone = EnumItem:new() :: declare.enumitem<any>,
    PickItemOnLineOfSight = EnumItem:new() :: declare.enumitem<any>,

    DoPrimary = EnumItem:new() :: declare.enumitem<any>,
    DoSecondary = EnumItem:new() :: declare.enumitem<any>,
    DoSpecial = EnumItem:new() :: declare.enumitem<any>,
    DoAction = EnumItem:new() :: declare.enumitem<any>,

    Say = EnumItem:new() :: declare.enumitem<any>,
})

return class
