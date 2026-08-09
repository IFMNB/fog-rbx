--!strict

const EnumObject = require("@game/ReplicatedStorage/class/arch/EnumObject")
const EnumItem = require("@game/ReplicatedStorage/class/arch/EnumItem")
const declare = require("@game/ReplicatedStorage/static/declare")

const class : declare.enum_connection_state_variant = EnumObject:new({
	name = script.Name,
	Normal = EnumItem:new() :: declare.enumitem<any>,
	ChangingCallOn = EnumItem:new() :: declare.enumitem<any>,
})

return class
