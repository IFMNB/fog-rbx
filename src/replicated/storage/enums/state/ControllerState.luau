--!strict

const EnumObject = require("@game/ReplicatedStorage/class/core/EnumObject")
const EnumItem = require("@game/ReplicatedStorage/class/core/EnumItem")

const class: enum_controller_state = EnumObject:new({
	name = script.Name,
	Continue = EnumItem:new() :: enumitem<any>,
	Pause = EnumItem:new() :: enumitem<any>,
	Reset = EnumItem:new() :: enumitem<any>,
})

return class
