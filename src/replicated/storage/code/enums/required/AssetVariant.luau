--!strict

const EnumObject = require("@game/ReplicatedStorage/code/class/arch/EnumObject")
const EnumItem = require("@game/ReplicatedStorage/code/class/arch/EnumItem")
const declare = require("@game/ReplicatedStorage/code/static/declare")

const class = EnumObject:new({
	name = "AssetVariant",

	Model = EnumItem:new({ name = "Model" }),
	Sound = EnumItem:new({ name = "Sound" }),
	Image = EnumItem:new({ name = "Image" }),
})

return class
