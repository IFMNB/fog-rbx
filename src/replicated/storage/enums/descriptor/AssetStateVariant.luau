--!strict

const EnumObject = require("@game/ReplicatedStorage/class/arch/EnumObject")
const EnumItem = require("@game/ReplicatedStorage/class/arch/EnumItem")
const declare = require("@game/ReplicatedStorage/static/declare")

const class = EnumObject:new({
	name = "AssetStateVariant",

	Fail = EnumItem:new({ name = "Fail" }),
	Loaded = EnumItem:new({ name = "Loaded" }),
	Making = EnumItem:new({ name = "Making" }),
	Reload = EnumItem:new({ name = "Reload" }),
	Never = EnumItem:new({ name = "Never" }),
})

return class
