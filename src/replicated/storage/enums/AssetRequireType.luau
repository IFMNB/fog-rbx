--!strict

const EnumObject = require("../class/arch/EnumObject")
const EnumItem = require("../class/arch/EnumItem")
const declare = require("../static/declare")

const class = EnumObject:new({
	name = "AssetRequireType",

	--[=[
		Ожидает объект, тип которого соответствует этому значению.
	]=]
	Mesh = EnumItem:new({
		name = "Mesh",
	}),

	--[=[
		Ожидает объект, тип которого соответствует этому значению.
	]=]
	Animation = EnumItem:new({
		name = "Animation",
	}),

	--[=[
		Ожидает объект, тип которого соответствует этому значению.
	]=]
	Module = EnumItem:new({
		name = "Module",
	}),

	--[=[
		Ожидает объект, тип которого соответствует этому значению.
	]=]
	Image = EnumItem:new({
		name = "Image",
	}),

	--[=[
		Ожидает объект, тип которого соответствует этому значению.
	]=]
	Sound = EnumItem:new({
		name = "Sound",
	}),

	--[=[
		Ожидает объект, тип которого соответствует этому значению.
	]=]
	Model = EnumItem:new({
		name = "Model",
	}),
})

return class
