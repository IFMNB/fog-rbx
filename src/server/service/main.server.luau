--!strict

const root = "@game/ServerScriptService/"
const Tasky = require("@game/ReplicatedStorage/class/Tasky")
const main = Tasky:new()


main:deploy(root .. "dependency/konsole_host")
main:deploy(root .. "game/user_data_service")

if game.RunService:IsStudio() then
    --main:deploy(root .. "debug/unit")
    --main:deploy(root .. "debug/input")
end