--!strict
const EnumItem = require("@game/ReplicatedStorage/class/arch/EnumItem")
const EnumObject = require("@game/ReplicatedStorage/class/arch/EnumObject")
const declare = require("@game/ReplicatedStorage/static/declare")

const class: declare.enum_remote_variant = EnumObject:new({
	name = script.Name,
	
    SendedEvent = EnumItem:new() :: declare.enumitem<any>,
    AwaitResponse = EnumItem:new() :: declare.enumitem<any>,
})

return class
