--!strict
const EnumItem = require("@game/ReplicatedStorage/class/arch/EnumItem")
const EnumObject = require("@game/ReplicatedStorage/class/arch/EnumObject")
const declare = require("@game/ReplicatedStorage/static/declare")
const dgame = require("@game/ReplicatedStorage/static/dgame")

const class: dgame.enum_pickup_notification = EnumObject:new({
	name = script.Name,

	PickedUp = EnumItem:new() :: declare.enumitem<any>,
	Dropped = EnumItem:new() :: declare.enumitem<any>,
	Shown = EnumItem:new() :: declare.enumitem<any>,
	Hidden = EnumItem:new() :: declare.enumitem<any>,
	Touch = EnumItem:new() :: declare.enumitem<any>,
})

return class
