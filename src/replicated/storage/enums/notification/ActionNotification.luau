--!strict
const EnumItem = require("@game/ReplicatedStorage/class/arch/EnumItem")
const EnumObject = require("@game/ReplicatedStorage/class/arch/EnumObject")
const declare = require("@game/ReplicatedStorage/static/declare")

const class: declare.enum_action_notification = EnumObject:new({
	name = script.Name,
	Step = EnumItem:new() :: declare.enumitem<any>,
	Signal = EnumItem:new() :: declare.enumitem<any>,
	Emit = EnumItem:new() :: declare.enumitem<any>,
    Unobservable = EnumItem:new() :: declare.enumitem<any>,
	Observable = EnumItem:new() :: declare.enumitem<any>,
})

return class
