--!strict
const EnumItem = require("@game/ReplicatedStorage/class/core/EnumItem")
const EnumObject = require("@game/ReplicatedStorage/class/core/EnumObject")

const class: enum_state = EnumObject:new({
	name = script.Name,
	Failure = EnumItem:new() :: enumitem<any>,
	Loading = EnumItem:new() :: enumitem<any>,
	Successful = EnumItem:new() :: enumitem<any>,
	Nothing = EnumItem:new() :: enumitem<any>,
})

return class
