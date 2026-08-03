--!strict

const EnumObject = require("@game/ReplicatedStorage/code/class/arch/EnumObject")
const EnumItem = require("@game/ReplicatedStorage/code/class/arch/EnumItem")
const declare = require("@game/ReplicatedStorage/code/static/declare")

const class = EnumObject:new({
	name = "DirectionVariant",

	pX = EnumItem:new({ name = "pX" }),
	mX = EnumItem:new({ name = "mX" }),
	pY = EnumItem:new({ name = "pY" }),
	mY = EnumItem:new({ name = "mY" }),
	pZ = EnumItem:new({ name = "pZ" }),
	mZ = EnumItem:new({ name = "mZ" }),
})

return class
