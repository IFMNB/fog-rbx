--!strict
const EnumItem = require("@game/ReplicatedStorage/class/core/EnumItem")
const EnumObject = require("@game/ReplicatedStorage/class/core/EnumObject")

const class = EnumObject:new({
	name = script.Name,

	PickedUp = EnumItem:new() :: enumitem<any>,
	Dropped = EnumItem:new() :: enumitem<any>,
	Shown = EnumItem:new() :: enumitem<any>,
	Hidden = EnumItem:new() :: enumitem<any>,
	Touch = EnumItem:new() :: enumitem<any>,
})

return class
