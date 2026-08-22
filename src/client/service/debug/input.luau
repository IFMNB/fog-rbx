--!strict
const Input = require("@game/ReplicatedStorage/class/network/Input")
const ActionMapVariant = require("@game/ReplicatedStorage/enums/descriptor/ActionMapVariant")
const ConnectionVariant = require("@game/ReplicatedStorage/enums/descriptor/ConnectionVariant")
const InputNotification = require("@game/ReplicatedStorage/enums/notification/InputNotification")
const project = require("@game/ReplicatedStorage/static/project")

const input_move_forward = Input:new()
input_move_forward:set_code(Enum.KeyCode.W, true)
input_move_forward:set_related(ActionMapVariant.MoveForward)
input_move_forward.network = true
input_move_forward.enabled = true

input_move_forward:subscribe(InputNotification.Pressed, ConnectionVariant.Ever, function ()
    project.console_out("input move forward pressed")
end)

return true