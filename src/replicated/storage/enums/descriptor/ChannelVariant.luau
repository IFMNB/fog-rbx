--!strict
const EnumItem = require("@game/ReplicatedStorage/class/arch/EnumItem")
const EnumObject = require("@game/ReplicatedStorage/class/arch/EnumObject")
const declare = require("@game/ReplicatedStorage/static/declare")

const class: declare.enum_channel_variant = EnumObject:new({
	name = script.Name,

	Abyss = EnumItem:new() :: declare.enumitem<any>,
	UserData = EnumItem:new() :: declare.enumitem<any>,
    ActionMap = EnumItem:new() :: declare.enumitem<any>,
    RemoteProcedure = EnumItem:new() :: declare.enumitem<any>,
})

return class
