--!strict
const EnumItem = require("@game/ReplicatedStorage/class/arch/EnumItem")
const EnumObject = require("@game/ReplicatedStorage/class/arch/EnumObject")
const declare = require("@game/ReplicatedStorage/static/declare")

const class: declare.enum_disposable_notification = EnumObject:new({
	name = script.Name,
	OnRelease = EnumItem:new() :: declare.enumitem<any>,
	Released = EnumItem:new() :: declare.enumitem<any>,
})

return class
