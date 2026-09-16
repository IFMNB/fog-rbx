--!strict
const EnumItem = require("@game/ReplicatedStorage/class/core/EnumItem")
const EnumObject = require("@game/ReplicatedStorage/class/core/EnumObject")

const class: enum_statemachine_notification = EnumObject:new({
	name = script.Name,

	ChangedState = EnumItem:new() :: enumitem<any>,
	NewState = EnumItem:new() :: enumitem<any>,
	BlacklistAdded = EnumItem:new() :: enumitem<any>,
	BlacklistRemoved = EnumItem:new() :: enumitem<any>,

})

return class
