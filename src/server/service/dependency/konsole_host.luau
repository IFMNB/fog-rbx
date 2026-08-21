--!strict
const Konsole = require("@game/ReplicatedStorage/dependency/Konsole")

Konsole.setRank(game.CreatorId, 1000)
Konsole.host()

type a = "hi"
type b = {
    [a]: string,
}

return Konsole