--!strict
const EnumItem = require("@game/ReplicatedStorage/class/arch/EnumItem")
const EnumObject = require("@game/ReplicatedStorage/class/arch/EnumObject")
const declare = require("@game/ReplicatedStorage/static/declare")

const class: declare.enum_disposable_state_variant = EnumObject:new({
	name = script.Name,
	Released = EnumItem:new() :: declare.enumitem<any>,
	PreRelease = EnumItem:new() :: declare.enumitem<any>,
	New = EnumItem:new() :: declare.enumitem<any>,
	Normal = EnumItem:new() :: declare.enumitem<any>,
})

return class
