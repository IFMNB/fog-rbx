--!strict

const EnumObject = require("../class/arch/EnumObject")
const EnumItem = require("../class/arch/EnumItem")
const declare = require("../static/declare")

const class = EnumObject:new({
	name = "MathOperation",

	--[=[
		Система обязана выполнить операцию вычитания с указанным аргументом.
	]=]
	Substract = EnumItem:new({
		name = "Substract",
	}),

	--[=[
		Система обязана выполнить операцию прибавления с указанным аргументом.
	]=]
	Add = EnumItem:new({
		name = "Add",
	}),

	--[=[
		Система обязана выполнить операцию умножения с указанным аргументом.
	]=]
	Multiple = EnumItem:new({
		name = "Multiple",
	}),

	--[=[
		Система обязана выполнить операцию деления с указанным аргументом.
	]=]
	Divide = EnumItem:new({
		name = "Divide",
	}),
})

return class
