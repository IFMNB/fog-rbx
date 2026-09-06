--!strict
const EnumItem = require("@game/ReplicatedStorage/class/arch/EnumItem")
const EnumObject = require("@game/ReplicatedStorage/class/arch/EnumObject")
const declare = require("@game/ReplicatedStorage/static/declare")
const dgame = require("@game/ServerStorage/static/dgame")

const class: dgame.enum_unit_state = EnumObject:new({
	name = script.Name,

	Ragdolled = EnumItem:new() :: declare.enumitem<any>,
	Alive = EnumItem:new() :: declare.enumitem<any>,
	Dead = EnumItem:new() :: declare.enumitem<any>,
	Moving = EnumItem:new() :: declare.enumitem<any>,
	Jumped = EnumItem:new() :: declare.enumitem<any>,
	Flying = EnumItem:new() :: declare.enumitem<any>,
	Running = EnumItem:new() :: declare.enumitem<any>,
	Lying = EnumItem:new() :: declare.enumitem<any>,
	Crounching = EnumItem:new() :: declare.enumitem<any>,
	Idle = EnumItem:new() :: declare.enumitem<any>,
})

return class
