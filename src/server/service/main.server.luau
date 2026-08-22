--!strict

const root = "@game/ServerScriptService/"
const tasky = require("@game/ReplicatedStorage/class/tasky")
const main = tasky:new()


main:deploy(root .. "dependency/konsole_host")


if game.RunService:IsStudio() then
    main:deploy(root .. "debug/unit")
    main:deploy(root .. "debug/input")
end
