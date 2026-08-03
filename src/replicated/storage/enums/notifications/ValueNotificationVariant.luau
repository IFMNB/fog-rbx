--!strict

const EnumObject = require("@game/ReplicatedStorage/class/arch/EnumObject")
const EnumItem = require("@game/ReplicatedStorage/class/arch/EnumItem")
const declare = require("@game/ReplicatedStorage/static/declare")

const class = EnumObject:new({
	name = "ValueNotificationVariant",

	LazyValueNew = EnumItem:new({ name = "LazyValueNew" }),
	LazyValueGet = EnumItem:new({ name = "LazyValueGet" }),
	LazyValueRemoved = EnumItem:new({ name = "LazyValueRemoved" }),
	LazyValueChanged = EnumItem:new({ name = "LazyValueChanged" }),

	ValueNew = EnumItem:new({ name = "ValueNew" }),
	ValueGet = EnumItem:new({ name = "ValueGet" }),
	ValueRemoved = EnumItem:new({ name = "ValueRemoved" }),
	ValueChanged = EnumItem:new({ name = "ValueChanged" }),
})

return class
