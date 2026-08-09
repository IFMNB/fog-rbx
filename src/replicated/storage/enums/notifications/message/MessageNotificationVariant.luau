--!strict

const EnumObject = require("@game/ReplicatedStorage/class/arch/EnumObject")
const EnumItem = require("@game/ReplicatedStorage/class/arch/EnumItem")
const declare = require("@game/ReplicatedStorage/static/declare")

const class = EnumObject:new({
	name = script.Name,
	Invoke = EnumItem:new() :: declare.enumitem<any>,
	Await = EnumItem:new() :: declare.enumitem<any>,
})

return class
