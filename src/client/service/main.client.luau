--!strict
const root = "@game/StarterPlayer/StarterPlayerScripts/"
const tasky = require("@game/ReplicatedStorage/class/tasky"):new()

tasky:deploy(root .. "dependency/lori")
tasky:deploy(root .. "dependency/konsole")
