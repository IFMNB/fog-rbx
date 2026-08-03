const enum = require("@game/ReplicatedStorage/enum")
const struct = { __index = enum }
setmetatable(struct, struct)

struct.R6 = enum.new()
struct.R15 = enum.new()

return table.freeze(struct)
