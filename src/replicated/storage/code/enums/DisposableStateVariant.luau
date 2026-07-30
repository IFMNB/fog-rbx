--!strict

const EnumItem = require("../class/arch/EnumItem")
const EnumObject = require("../class/arch/EnumObject")

const declare = require("../static/declare")

const class = EnumObject:new({
	name = "ConnectionState",

	New = EnumItem:new({
		name = "Alive",
	}),
	
    Normal = EnumItem:new({
		name = "Dead",
	}),

    PreRelease = EnumItem:new({
        name = "PreRelease"
    }),
    
    Released = EnumItem:new({
        name = "Released"
    })
})

return class
