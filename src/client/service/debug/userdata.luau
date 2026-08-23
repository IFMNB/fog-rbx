--!strict
const User = require("@game/ReplicatedStorage/class/local/User")
const Input = require("@game/ReplicatedStorage/class/network/Input")
const ActionMapVariant = require("@game/ReplicatedStorage/enums/descriptor/ActionMapVariant")
const ConnectionVariant = require("@game/ReplicatedStorage/enums/descriptor/ConnectionVariant")
const InputNotification = require("@game/ReplicatedStorage/enums/notification/InputNotification")
const UserDataRequire = require("@game/ReplicatedStorage/enums/require/UserDataRequire")
const project = require("@game/ReplicatedStorage/static/project")

const input_action_f = Input:new()
input_action_f:set_related(ActionMapVariant.DoAction)
input_action_f:set_code(Enum.KeyCode.F, true)
input_action_f.enabled = true
input_action_f:set_network(false)

input_action_f:subscribe(InputNotification.Pressed, ConnectionVariant.Ever, function ()
    const me = User.get_local_user()
    project.console_out("requesting data from server")
    const a = me:request_data(UserDataRequire.Profile)
    project.console_out(a.state, a.result, a:unpack())

end)

return true