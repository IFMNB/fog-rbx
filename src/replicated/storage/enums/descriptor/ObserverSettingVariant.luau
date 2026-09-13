--!strict
const EnumItem = require("@game/ReplicatedStorage/class/arch/EnumItem")
const EnumObject = require("@game/ReplicatedStorage/class/arch/EnumObject")
const declare = require("@game/ReplicatedStorage/static/declare")

const class: declare.enum_observer_setting_variant = EnumObject:new({
	name = script.Name,
    ChangeModeToOnce = EnumItem:new() :: declare.enumitem<any>,
    ChangeModeToEver = EnumItem:new() :: declare.enumitem<any>,
    ChangeModeToSkip = EnumItem:new() :: declare.enumitem<any>,
    ChangeModeToNext = EnumItem:new() :: declare.enumitem<any>,
})

return class
