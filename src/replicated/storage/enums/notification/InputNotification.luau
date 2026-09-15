--!strict
const EnumItem = require("@game/ReplicatedStorage/class/core/EnumItem")
const EnumObject = require("@game/ReplicatedStorage/class/core/EnumObject")

const class: enum_input_notification = EnumObject:new({
	name = script.Name,

	CodeAdded = EnumItem:new() :: enumitem<any>,
	CodeRemoved = EnumItem:new() :: enumitem<any>,
	Pressed = EnumItem:new() :: enumitem<any>,
	Clamped = EnumItem:new() :: enumitem<any>,
	Stopped = EnumItem:new() :: enumitem<any>,
	RelatedChanged = EnumItem:new() :: enumitem<any>,
	RelatedNullified = EnumItem:new() :: enumitem<any>,
	NetworkEnabled = EnumItem:new() :: enumitem<any>,
	NetworkDisabled = EnumItem:new() :: enumitem<any>,
})

return class
