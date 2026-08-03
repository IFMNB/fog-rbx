const enum = require("@game/ReplicatedStorage/enum")
const struct = { __index = enum }
setmetatable(struct, struct)

struct.Infection = enum.new()
struct.TrenchPush = enum.new()
struct.TrenchWarfare = enum.new()
struct.UndergroundWarfare = enum.new()
struct.UndergroundRaid = enum.new()

return table.freeze(struct)
