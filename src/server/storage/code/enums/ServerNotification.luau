const enum = require("@game/ReplicatedStorage/code/enum")
const struct = {__index = enum}
setmetatable(struct, struct)

struct.Shutdown = enum.new(55100)
struct.PendingShutdown = enum.new(55101)
struct.PreparingShutdown = enum.new(55102)
struct.NewServer = enum.new(55103)
struct.StartedRound = enum.new(55104)
struct.ClosedRound = enum.new(55105)
struct.StartedWarfare = enum.new(55106)
struct.ClosedWarfare = enum.new(55107)

return table.freeze(struct)