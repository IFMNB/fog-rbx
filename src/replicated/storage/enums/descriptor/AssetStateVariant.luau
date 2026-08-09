--!strict

const EnumObject = require("@game/ReplicatedStorage/class/arch/EnumObject")
const EnumItem = require("@game/ReplicatedStorage/class/arch/EnumItem")
const declare = require("@game/ReplicatedStorage/static/declare")

const class: declare.enum_asset_state_variant = EnumObject:new({
	name = script.Name,
	Fail = EnumItem:new() :: declare.enumitem<any>,
	Loaded = EnumItem:new() :: declare.enumitem<any>,
	Making = EnumItem:new() :: declare.enumitem<any>,
	Reload = EnumItem:new() :: declare.enumitem<any>,
	Never = EnumItem:new() :: declare.enumitem<any>,
})

return class
