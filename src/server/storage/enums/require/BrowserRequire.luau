--!strict
const EnumItem = require("@game/ReplicatedStorage/class/arch/EnumItem")
const EnumObject = require("@game/ReplicatedStorage/class/arch/EnumObject")
const declare = require("@game/ReplicatedStorage/static/declare")
const dgame = require("@game/ServerStorage/static/dgame")

const class: dgame.enum_browser_require = EnumObject:new({
	name = script.Name,
	
	BrowserList = EnumItem:new() :: declare.enumitem<any>,
	BrowserInfo = EnumItem:new() :: declare.enumitem<any>,
})

return class
