--!strict
const EnumItem = require("@game/ReplicatedStorage/class/arch/EnumItem")
const EnumObject = require("@game/ReplicatedStorage/class/arch/EnumObject")
const declare = require("@game/ReplicatedStorage/static/declare")

const class: declare.enum_user_data_require = EnumObject:new({
	name = script.Name,

	Loadout = EnumItem:new() :: declare.enumitem<any>,
	Specialization = EnumItem:new() :: declare.enumitem<any>,
    Profile = EnumItem:new() :: declare.enumitem<any>, 
    Perk = EnumItem:new() :: declare.enumitem<any>,
    Weaponry = EnumItem:new() :: declare.enumitem<any>,
})

return class
