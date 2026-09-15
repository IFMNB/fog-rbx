--!strict

const EnumObject = require("@game/ReplicatedStorage/class/core/EnumObject")
const EnumItem = require("@game/ReplicatedStorage/class/core/EnumItem")

const class: enum_asset_type_variant = EnumObject:new({
	name = script.Name,
	Model = EnumItem:new() :: enumitem<any>,
	Sound = EnumItem:new() :: enumitem<any>,
	Image = EnumItem:new() :: enumitem<any>,
})

return class
