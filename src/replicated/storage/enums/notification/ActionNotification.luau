--!strict
const EnumItem = require("@game/ReplicatedStorage/class/core/EnumItem")
const EnumObject = require("@game/ReplicatedStorage/class/core/EnumObject")

const class: enum_action_notification = EnumObject:new({
	name = script.Name,
	Step = EnumItem:new() :: enumitem<any>,
	Signal = EnumItem:new() :: enumitem<any>,
	Emit = EnumItem:new() :: enumitem<any>,
	Unobservable = EnumItem:new() :: enumitem<any>,
	Observer = EnumItem:new() :: enumitem<any>,
})

return class
