--!strict
const EnumItem = require("@game/ReplicatedStorage/class/arch/EnumItem")
const EnumObject = require("@game/ReplicatedStorage/class/arch/EnumObject")
const declare = require("@game/ReplicatedStorage/static/declare")

const class: declare.enum_channel_notification = EnumObject:new({
	name = script.Name,
	
    AsyncChanged = EnumItem:new() :: declare.enumitem<any>,
    AsyncRemoved = EnumItem:new() :: declare.enumitem<any>,
    AwaitChanged = EnumItem:new() :: declare.enumitem<any>,
    AwaitRemoved = EnumItem:new() :: declare.enumitem<any>,
    PeerAdded = EnumItem:new() :: declare.enumitem<any>,
    PeerRemoved = EnumItem:new() :: declare.enumitem<any>,
    VariantChanged = EnumItem:new() :: declare.enumitem<any>,
})

return class
