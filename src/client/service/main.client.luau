--!strict
const root = "@game/StarterPlayer/StarterPlayerScripts/"
const Tasky = require("@game/ReplicatedStorage/class/Tasky")
const main = Tasky:new()

main.time_to_response = 20
main.time_to_hold = 2

main:deploy(root .. "dependency/lori")
main:deploy(root .. "dependency/konsole")
main:deploy(root .. "game/action_map")

if game.RunService:IsStudio() then
	--main:deploy(root .. "debug/input")
    --main:deploy(root .. "debug/userdata")
end
