--!strict

const EnumObject = require("../class/arch/EnumObject")
const EnumItem = require("../class/arch/EnumItem")
const declare = require("../static/declare")

const class = EnumObject:new({
	name = "Notification",

	Signal = EnumItem:new({name = "Signal"}),
	Initialize = EnumItem:new({name = "Initialize"}),
	Setup = EnumItem:new({name = "Setup"}),
	PreRelease = EnumItem:new({name = "PreRelease"}),
	LazyValueNew = EnumItem:new({name = "LazyValueNew"}),
	LazyEventNew = EnumItem:new({name = "LazyEventNew"}),
	ConnectionAdded = EnumItem:new({name = "ConnectionAdded"}),
	ConnectionRemoved = EnumItem:new({name = "ConnectionRemoved"}),
	Emit = EnumItem:new({name = "Emit"}),
	
})

return class
