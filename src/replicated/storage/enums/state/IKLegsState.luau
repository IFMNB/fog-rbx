--!strict

const EnumObject = require("@game/ReplicatedStorage/class/core/EnumObject")
const EnumItem = require("@game/ReplicatedStorage/class/core/EnumItem")

const class: enum_iklegs_state = EnumObject:new({
	name = script.Name,

    Planted = EnumItem:new() :: enumitem<any>,
    Stepping = EnumItem:new() :: enumitem<any>,
    Settling = EnumItem:new() :: enumitem<any>
})

return class
