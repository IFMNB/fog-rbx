--!strict

const EnumItem = require("../class/arch/EnumItem")
const EnumObject = require("../class/arch/EnumObject")

const declare = require("../static/declare")

const class  = EnumObject:new({
	name = "ConnectionState",

	Alive = EnumItem:new({
		name = "Alive",
	}),
    Dead = EnumItem:new({
        name = "Dead"
    })
})

return class
