--!strict

const EnumObject = require("../class/arch/EnumObject")
const EnumItem = require("../class/arch/EnumItem")
const declare = require("../static/declare")

const class = EnumObject:new({
	name = "AgentOrderNotificationType",

	Executre = EnumItem:new({
		name = "Execute",
	}),
})

return class
