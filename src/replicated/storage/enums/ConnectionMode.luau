--!strict

const EnumItem = require("../class/arch/EnumItem")
const EnumObject = require("../class/arch/EnumObject")

const declare = require("../static/declare")

const class = EnumObject:new({
	name = "ConnectionState",

	Once = EnumItem:new({
		name = "Once",
	}),
	Connection = EnumItem:new({
		name = "Connection",
	}),
})

return class
