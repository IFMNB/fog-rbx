--!strict
const EnumItem = require("@game/ReplicatedStorage/class/arch/EnumItem")
const EnumObject = require("@game/ReplicatedStorage/class/arch/EnumObject")
const declare = require("@game/ReplicatedStorage/static/declare")

const class: declare.enum_browser_require = EnumObject:new({
	name = script.Name,
	ListOfServers = EnumItem:new() :: declare.enumitem<any>,
	ServerInfo = EnumItem:new() :: declare.enumitem<any>,
})

return class
