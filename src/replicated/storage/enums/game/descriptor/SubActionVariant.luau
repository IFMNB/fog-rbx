--!strict
const EnumItem = require("@game/ReplicatedStorage/class/core/EnumItem")
const EnumObject = require("@game/ReplicatedStorage/class/core/EnumObject")

const class = EnumObject:new({
	name = script.Name,

	PeekLeft = EnumItem:new() :: enumitem<any>,
	PeekRight = EnumItem:new() :: enumitem<any>,

	PickInventorySlot = EnumItem:new() :: enumitem<any>,
	PickToInventoryItemInZone = EnumItem:new() :: enumitem<any>,
	PickToInventoryItemOnLineOfSight = EnumItem:new() :: enumitem<any>,
	PickItemInZone = EnumItem:new() :: enumitem<any>,
	PickItemOnLineOfSight = EnumItem:new() :: enumitem<any>,

	DoPrimary = EnumItem:new() :: enumitem<any>,
	DoSecondary = EnumItem:new() :: enumitem<any>,
	DoSpecial = EnumItem:new() :: enumitem<any>,
	DoAction = EnumItem:new() :: enumitem<any>,

	Say = EnumItem:new() :: enumitem<any>,
})

return class
