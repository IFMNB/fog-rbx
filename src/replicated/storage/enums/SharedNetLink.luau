--!strict

const EnumObject = require("../class/arch/EnumObject")
const EnumItem = require("../class/arch/EnumItem")
const declare = require("../static/declare")

const class = EnumObject:new({
	name = "CommandSource",

	Konsole = EnumItem:new({
		name = "Konsole",
	}),

	Cmdr = EnumItem:new({
		name = "Cmdr",
	}),

	ActMap = EnumItem:new({
		name = "ActMap",
	}),
})

return class
