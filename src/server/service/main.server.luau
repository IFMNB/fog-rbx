--!strict

const root = "@game/ServerScriptService/"
const Tasky = require("@game/ReplicatedStorage/class/Tasky")
const main = Tasky:new()


main:deploy(root .. "dependency/konsole_host")
main:deploy(root .. "game/user_data_service")
main:deploy(root .. "game/action_map")


if game.RunService:IsStudio() then
    --main:deploy(root .. "debug/unit")
    --main:deploy(root .. "debug/input")
    --main:deploy(root .. "debug/pickup")
end