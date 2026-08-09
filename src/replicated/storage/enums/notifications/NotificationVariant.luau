--!strict

const EnumObject = require("@game/ReplicatedStorage/class/arch/EnumObject")
const EnumItem = require("@game/ReplicatedStorage/class/arch/EnumItem")
const declare = require("@game/ReplicatedStorage/static/declare")

const class: declare.enum_notification_variant = EnumObject:new({
	name = script.Name,
	Signal = EnumItem:new() :: declare.enumitem<any>,
	Initialize = EnumItem:new() :: declare.enumitem<any>,
	Setup = EnumItem:new() :: declare.enumitem<any>,
	PreRelease = EnumItem:new() :: declare.enumitem<any>,
	ConnectionAdded = EnumItem:new() :: declare.enumitem<any>,
	ConnectionRemoved = EnumItem:new() :: declare.enumitem<any>,
	Stepped = EnumItem:new() :: declare.enumitem<any>,
	Emit = EnumItem:new() :: declare.enumitem<any>,
})

return class
