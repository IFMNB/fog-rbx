const enum = require("../class/arch/enum")
const struct = { __index = enum }
setmetatable(struct, struct)

struct.Battle = enum.new()
struct.Victory = enum.new()
struct.Prepare = enum.new()
struct.Choice = enum.new()

return table.freeze(struct)
