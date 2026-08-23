--!strict
const EnumItem = require("@game/ReplicatedStorage/class/arch/EnumItem")
const EnumObject = require("@game/ReplicatedStorage/class/arch/EnumObject")
const declare = require("@game/ReplicatedStorage/static/declare")

const class: declare.enum_item_notification = EnumObject:new({
	name = script.Name,

    Equipped = EnumItem:new() :: declare.enumitem<any>,
    Unequipped = EnumItem:new() :: declare.enumitem<any>,
})

return class
