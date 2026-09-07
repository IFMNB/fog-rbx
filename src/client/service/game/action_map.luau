--!strict
const Service = require("@game/ReplicatedStorage/class/arch/Service")
const Input = require("@game/ReplicatedStorage/class/network/Input")
const ActionMapVariant = require("@game/ReplicatedStorage/enums/descriptor/ActionMapVariant")
const ChannelVariant = require("@game/ReplicatedStorage/enums/descriptor/ChannelVariant")
const SubActionVariant = require("@game/ReplicatedStorage/enums/descriptor/SubActionVariant")
const declare = require("@game/ReplicatedStorage/static/declare")
const dgame = require("@game/ReplicatedStorage/static/dgame")

type expected = dgame.enumitem_subaction_variant|declare.enumitem_action_map_variant

const private = {}
const class = Service:new {
    get_input = function (of: expected)
        return private.inputs[of]
    end,

    reset_input = function (of: expected?)
        if of then
            const input = private.inputs[of]

            for _, v in input:get_code() do
                input:set_code(v, false)
            end

            input:set_code(private.default_lowend_inputs[of], true)
        else
            for i, v in private.inputs do
                for _, e in v:get_code() do
                    v:set_code(e, false)
                end

                v:set_code(private.default_lowend_inputs[i], true)
            end
        end
    end
}

do
    type input = declare.input
    type inputs <T = unknown> = {[expected]: T}

    private.inputs = {} :: inputs<input>

    for _, v in ActionMapVariant:get_enums_list() do
        private.inputs[v :: declare.enumitem<any>] = Input:new()
    end
	for _, v in SubActionVariant:get_enums_list() do
		private.inputs[v :: declare.enumitem<any>] = Input:new()
	end
    for _, v in private.inputs do
        v:set_related(ChannelVariant.Inputs)
    end

    private.default_lowend_inputs = {
        [ActionMapVariant.MoveForward] = Enum.KeyCode.W,
        [ActionMapVariant.MoveBackward] = Enum.KeyCode.S,
        [ActionMapVariant.MoveLeft] = Enum.KeyCode.A,
        [ActionMapVariant.MoveRight] = Enum.KeyCode.D,
        [ActionMapVariant.MoveLying] = Enum.KeyCode.Z,
        [ActionMapVariant.MoveSlow] = Enum.KeyCode.LeftAlt,
        [ActionMapVariant.MoveJump] = Enum.KeyCode.Space,
        [ActionMapVariant.MoveRun] = Enum.KeyCode.LeftShift,
        [ActionMapVariant.MoveCrounch] = Enum.KeyCode.LeftControl,

        [SubActionVariant.DoAction] = Enum.KeyCode.F,
        [SubActionVariant.DoPrimary] = Enum.KeyCode.MouseLeftButton,
        [SubActionVariant.DoSecondary] = Enum.KeyCode.MouseRightButton,
        [SubActionVariant.DoSpecial] = Enum.KeyCode.MouseMiddleButton,

        [SubActionVariant.PeekLeft] = Enum.KeyCode.E,
        [SubActionVariant.PeekRight] = Enum.KeyCode.Q
    } :: inputs<Enum.KeyCode>

    for i, v in private.inputs do
        v:set_code(private.default_lowend_inputs[i], true)
        v:set_network(true)
    end
end

return class