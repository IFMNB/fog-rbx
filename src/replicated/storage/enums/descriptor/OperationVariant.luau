--!strict
const EnumItem = require("@game/ReplicatedStorage/class/core/EnumItem")
const EnumObject = require("@game/ReplicatedStorage/class/core/EnumObject")

const class: enum_operation_variant = EnumObject:new({
	name = script.Name,
	Remove = EnumItem:new() :: enumitem<any>,
	New = EnumItem:new() :: enumitem<any>,
	Change = EnumItem:new() :: enumitem<any>,
	Null = EnumItem:new() :: enumitem<any>,
})

return class
