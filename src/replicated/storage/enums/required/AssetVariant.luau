--!strict

const EnumObject = require("@game/ReplicatedStorage/class/arch/EnumObject")
const EnumItem = require("@game/ReplicatedStorage/class/arch/EnumItem")
const declare = require("@game/ReplicatedStorage/static/declare")

const class = EnumObject:new({
	name = "AssetVariant",

	Model = EnumItem:new({ name = "Model" }),
	Sound = EnumItem:new({ name = "Sound" }),
	Image = EnumItem:new({ name = "Image" }),
})

return class
