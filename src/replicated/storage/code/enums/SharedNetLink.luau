const enum = require("@game/ReplicatedStorage/code/enum")
const struct = { __index = enum }
setmetatable(struct, struct)

struct.Konsole = enum.new "Konsole"
struct.Cmdr = enum.new "Cmdr"

struct.ActMap = enum.new "ActMap"

return table.freeze(struct)
