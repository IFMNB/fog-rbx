--!strict
const EnumItem = require("@game/ReplicatedStorage/class/arch/EnumItem")
const EnumObject = require("@game/ReplicatedStorage/class/arch/EnumObject")
const declare = require("@game/ReplicatedStorage/static/declare")
const dgame = require("@game/ReplicatedStorage/static/dgame")

const class: dgame.enum_inventory_notification = EnumObject:new({
	name = script.Name,

	ItemAdded = EnumItem:new() :: declare.enumitem<any>,
	ItemRemoved = EnumItem:new() :: declare.enumitem<any>,
})

return class
