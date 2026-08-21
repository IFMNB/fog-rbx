--!strict

const root = "@game/ServerScriptService/"
const tasky = require("@game/ReplicatedStorage/class/tasky"):new()


tasky:deploy(root .. "dependency/konsole_host")


if game.RunService:IsStudio() then
    tasky:deploy(root .. "debug/unit")
end
