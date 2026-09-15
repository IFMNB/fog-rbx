--!strict
const EnumItem = require("@game/ReplicatedStorage/class/core/EnumItem")
const EnumObject = require("@game/ReplicatedStorage/class/core/EnumObject")

const class: enum_disposable_notification = EnumObject:new({
	name = script.Name,
	OnRelease = EnumItem:new() :: enumitem<any>,
	Released = EnumItem:new() :: enumitem<any>,
})

return class
