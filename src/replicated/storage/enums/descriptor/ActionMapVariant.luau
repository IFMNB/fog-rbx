--!strict
const EnumItem = require("@game/ReplicatedStorage/class/arch/EnumItem")
const EnumObject = require("@game/ReplicatedStorage/class/arch/EnumObject")
const declare = require("@game/ReplicatedStorage/static/declare")

const class: declare.enum_action_map_variant = EnumObject:new({
	name = script.Name,
    
    MoveForward = EnumItem:new() :: declare.enumitem<any>,
    MoveBackward = EnumItem:new() :: declare.enumitem<any>,
    MoveLeft = EnumItem:new() :: declare.enumitem<any>,
    MoveRight = EnumItem:new() :: declare.enumitem<any>,
    MoveJump = EnumItem:new() :: declare.enumitem<any>,
    MoveCrounch = EnumItem:new() :: declare.enumitem<any>,
    MoveLying = EnumItem:new() :: declare.enumitem<any>,
    MoveRun = EnumItem:new() :: declare.enumitem<any>,
    MoveSlow = EnumItem:new() :: declare.enumitem<any>,
    
    PeekLeft= EnumItem:new() :: declare.enumitem<any>,
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
