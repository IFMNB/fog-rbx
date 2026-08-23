--!strict
const EnumItem = require("@game/ReplicatedStorage/class/arch/EnumItem")
const EnumObject = require("@game/ReplicatedStorage/class/arch/EnumObject")
const declare = require("@game/ReplicatedStorage/static/declare")

const class: declare.enum_pickup_notification = EnumObject:new({
	name = script.Name,

    PickedUp = EnumItem:new() :: declare.enumitem<any>,
    Dropped = EnumItem:new() :: declare.enumitem<any>,
})

return class
