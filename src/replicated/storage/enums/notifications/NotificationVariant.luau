--!strict

const EnumObject = require("@game/ReplicatedStorage/class/arch/EnumObject")
const EnumItem = require("@game/ReplicatedStorage/class/arch/EnumItem")
const declare = require("@game/ReplicatedStorage/static/declare")

const class = EnumObject:new({
	name = "NotificationVariant",

	Signal = EnumItem:new({ name = "Signal" }),
	Initialize = EnumItem:new({ name = "Initialize" }),
	Setup = EnumItem:new({ name = "Setup" }),
	PreRelease = EnumItem:new({ name = "PreRelease" }),
	ConnectionAdded = EnumItem:new({ name = "ConnectionAdded" }),
	ConnectionRemoved = EnumItem:new({ name = "ConnectionRemoved" }),
	Stepped = EnumItem:new({ name = "Stepped" }),
	Emit = EnumItem:new({ name = "Emit" }),
})

return class
