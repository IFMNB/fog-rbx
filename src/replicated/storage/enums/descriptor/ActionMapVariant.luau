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
})

return class
