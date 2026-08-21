--!strict
const EnumItem = require("@game/ReplicatedStorage/class/arch/EnumItem")
const EnumObject = require("@game/ReplicatedStorage/class/arch/EnumObject")
const declare = require("@game/ReplicatedStorage/static/declare")

const class: declare.enum_connection_variant = EnumObject:new({
	name = script.Name,
	Ever = EnumItem:new() :: declare.enumitem<any>,
	Once = EnumItem:new() :: declare.enumitem<any>,
	Never = EnumItem:new() :: declare.enumitem<any>,
    Skip = EnumItem:new() :: declare.enumitem<any>,
	Hold = EnumItem:new() :: declare.enumitem<any>,
	Next = EnumItem:new() :: declare.enumitem<any>
})

return class
