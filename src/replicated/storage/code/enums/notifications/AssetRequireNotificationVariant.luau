--!strict

const EnumObject = require("@game/ReplicatedStorage/code/class/arch/EnumObject")
const EnumItem = require("@game/ReplicatedStorage/code/class/arch/EnumItem")
const declare = require("@game/ReplicatedStorage/code/static/declare")

const class = EnumObject:new({
	name = "AssetRequireNotificationVariant",

	Failure = EnumItem:new({ name = "Fail" }),
	Loading = EnumItem:new({ name = "Loaded" }),
	Successful = EnumItem:new({ name = "Making" }),
})

return class
