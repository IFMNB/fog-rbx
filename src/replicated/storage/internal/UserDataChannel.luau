--!strict
const Channel = require("@game/ReplicatedStorage/class/network/Channel")
const InternalChannelVariant = require("@game/ReplicatedStorage/enums/descriptor/InternalChannelVariant")

const sample = Channel:new()

sample:set_transport(InternalChannelVariant.UserData)
sample.everyone = true
sample.enabled = true

return sample