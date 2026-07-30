--!strict

const EnumObject = require("../class/arch/EnumObject")
const EnumItem = require("../class/arch/EnumItem")
const declare = require("../static/declare")


const class = EnumObject:new({
	name = "BoundBoxDirection",

	--[=[
		Направление согласно `Enum.Axis`

		Конкретно это направление `Vector3.yAxis`
	]=]
	Top = EnumItem:new({
		name = "Top",
	}),

	--[=[
		Направление согласно `Enum.Axis`

		Конкретно это направление `-Vector3.yAxis`
	]=]
	Bottom = EnumItem:new({
		name = "Bottom",
	}),

	--[=[
		Направление согласно `Enum.Axis`

		Конкретно это направление `Vector3.xAxis`
	]=]
	Right = EnumItem:new({
		name = "Right",
	}),

	--[=[
		Направление согласно `Enum.Axis`

		Конкретно это направление `-Vector3.xAxis`
	]=]
	Left = EnumItem:new({
		name = "Left",
	}),

	--[=[
		Направление согласно `Enum.Axis`

		Конкретно это направление `-Vector3.zAxis`
	]=]
	Front = EnumItem:new({
		name = "Front",
	}),

	--[=[
		Направление согласно `Enum.Axis`

		Конкретно это направление `Vector3.zAxis`
	]=]
	Back = EnumItem:new({
		name = "Back",
	}),

	--[=[
		Является направлением __от__ центра мирового пространства
		к этому центру, то есть это результат вычисления направления,
		куда нужно идти от центра мира, чтобы прийти сюда.
	]=]
	Center = EnumItem:new({
		name = "Center",
	}),
})

return class
