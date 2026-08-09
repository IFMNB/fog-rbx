--!strict

const EnumObject = require("@game/ReplicatedStorage/class/arch/EnumObject")
const EnumItem = require("@game/ReplicatedStorage/class/arch/EnumItem")
const declare = require("@game/ReplicatedStorage/static/declare")

const class: declare.enum_asset_variant = EnumObject:new({
	name = script.Name,
	Model = EnumItem:new() :: declare.enumitem<any>,
	Sound = EnumItem:new() :: declare.enumitem<any>,
	Image = EnumItem:new() :: declare.enumitem<any>,
})

return class
