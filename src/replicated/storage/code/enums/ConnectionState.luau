const enum = require("@game/ReplicatedStorage/code/enum")
const struct = {__index = enum}
setmetatable(struct, struct)

--[=[
    Соединение является живым
]=]
struct.Alive = enum.new("Alive")

--[=[
    Соединение было разорвано и может быть освобождено в любом случае
]=]
struct.Dead = enum.new("Dead")

return table.freeze(struct);