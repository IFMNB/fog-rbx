--!strict
const root = "@game/StarterPlayer/StarterPlayerScripts/"
const Tasky = require("@game/ReplicatedStorage/class/Tasky")
const main = Tasky:new()

main:deploy(root .. "dependency/lori")
main:deploy(root .. "dependency/konsole")

if game.RunService:IsStudio() then
	--main:deploy(root .. "debug/input")
    --main:deploy(root .. "debug/userdata")
end
