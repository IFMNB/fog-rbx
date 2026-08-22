--!strict
const Channel = require("@game/ReplicatedStorage/class/network/Channel")
const ActionMapVariant = require("@game/ReplicatedStorage/enums/descriptor/ActionMapVariant")
const declare = require("@game/ReplicatedStorage/static/declare")
const project = require("@game/ReplicatedStorage/static/project")

const channel_input_forward = Channel:new() :: declare.channel<declare.enumitem_action_map_variant, (), (boolean, boolean)> -- TypeError: Code is too complex to typecheck! Consider simplifying the code around this area
channel_input_forward:set_variant(ActionMapVariant.MoveForward)
channel_input_forward.everyone = true
channel_input_forward.enabled = true
channel_input_forward.event:connect(ActionMapVariant.MoveForward, function (pressed, clamped)
    const last = channel_input_forward:request_from()
    if last then
        const player = last:get_player():get_instance()
        
        project.console_out("received input from", player and player.Name or last.uid)
    end
end)

return true