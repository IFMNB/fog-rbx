--!strict

const EnumObject = require("@game/ReplicatedStorage/class/arch/EnumObject")
const EnumItem = require("@game/ReplicatedStorage/class/arch/EnumItem")
const declare = require("@game/ReplicatedStorage/static/declare")

const class : declare.enum_asset_require_notification_variant = EnumObject:new({
	name = script.Name,
	Failure = EnumItem:new() :: declare.enumitem<any>,
	Loading = EnumItem:new() :: declare.enumitem<any>,
	Successful = EnumItem:new() :: declare.enumitem<any>,
})

return class
