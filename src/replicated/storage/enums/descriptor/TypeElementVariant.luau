--!strict
const EnumItem = require("@game/ReplicatedStorage/class/arch/EnumItem")
const EnumObject = require("@game/ReplicatedStorage/class/arch/EnumObject")
const declare = require("@game/ReplicatedStorage/static/declare")

const class: declare.enum_type_element_variant = EnumObject:new({
	name = script.Name,
	Getter = EnumItem:new() :: declare.enumitem<any>,
	Setter = EnumItem:new() :: declare.enumitem<any>,
	Toggler = EnumItem:new() :: declare.enumitem<any>,
	Switcher = EnumItem:new() :: declare.enumitem<any>,

    LazyEvent = EnumItem:new() :: declare.enumitem<any>,
	LazyObject = EnumItem:new() :: declare.enumitem<any>,
	LazyValue = EnumItem:new() :: declare.enumitem<any>,
	NonElement = EnumItem:new() :: declare.enumitem<any>,
})

return class
