--!strict
const EnumItem = require("@game/ReplicatedStorage/class/arch/EnumItem")
const EnumObject = require("@game/ReplicatedStorage/class/arch/EnumObject")
const declare = require("@game/ReplicatedStorage/static/declare")

const class: declare.enum_internal_channel_variant = EnumObject:new({
	name = script.Name,

	UserData = EnumItem:new() :: declare.enumitem<any>,
})

return class
