--!strict

const EnumObject = require("../class/arch/EnumObject")
const EnumItem = require("../class/arch/EnumItem")
const declare = require("../static/declare")

const class = EnumObject:new({
	name = "RuntimeMode",

	--[=[
		Будет использовано текущее состояние runtime-систем.
	]=]
	Inherit = EnumItem:new({
		name = "Inherit",
	}),

	--[=[
		Принудительно будет обрабатываться только в синхронном контексте.
	]=]
	Synchro = EnumItem:new({
		name = "PrimarySynchro",
	}),

	--[=[
		Принудительно будет обрабатываться только в параллельном контексте.
	]=]
	Parallel = EnumItem:new({
		name = "Parallel",
	}),

	--[=[
		Не будет обрабатываться ни в каких случаях.
	]=]
	Disabled = EnumItem:new({
		name = "Disabled",
	}),
})

return class
