--!strict
const Service = require("@game/ReplicatedStorage/class/arch/Service")
const Channel = require("@game/ReplicatedStorage/class/network/Channel")
const ActionMapVariant = require("@game/ReplicatedStorage/enums/descriptor/ActionMapVariant")
const ChannelVariant = require("@game/ReplicatedStorage/enums/descriptor/ChannelVariant")
const SubActionVariant = require("@game/ReplicatedStorage/enums/descriptor/SubActionVariant")
const declare = require("@game/ReplicatedStorage/static/declare")
const dgame = require("@game/ReplicatedStorage/static/dgame")

type expected = dgame.enumitem_subaction_variant|declare.enumitem_action_map_variant

const private = {}
const class = Service:new({
    get_input = function (of: expected): declare.channel<expected>
        return private.inputs[of]
    end
})

do
	type input = declare.channel<expected>
	type inputs<T = unknown> = { [expected]: T }

    private.inputs = {} :: inputs<input>

    for _, v in ActionMapVariant:get_enums_list() do
        private.inputs[v :: declare.enumitem<any>] = Channel:new() :: input
    end
	for _, v in SubActionVariant:get_enums_list() do
		private.inputs[v :: declare.enumitem<any>] = Channel:new() :: input
	end
    for i, v in private.inputs do
        v:set_variant(ChannelVariant.Inputs)
        v.everyone = true
        v.enabled = true
    end
end

return class