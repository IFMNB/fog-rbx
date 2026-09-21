--!strict
const EnumItem = require("@game/ReplicatedStorage/class/core/EnumItem")
const EnumObject = require("@game/ReplicatedStorage/class/core/EnumObject")

const class: enum_ability_notification = EnumObject:new({
	name = script.Name,

    CastAbility = EnumItem:new() :: enumitem<any>,
    WaitingDataAbility = EnumItem:new() :: enumitem<any>,
    ActiveAbility = EnumItem:new() :: enumitem<any>,
    CancelAbility = EnumItem:new() :: enumitem<any>,
    EndingAbility = EnumItem:new() :: enumitem<any>,
    CooldownAbility = EnumItem:new() :: enumitem<any>,
})

return class
