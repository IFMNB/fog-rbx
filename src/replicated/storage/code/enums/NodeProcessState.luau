const enum = require("@game/ReplicatedStorage/code/enum")
const struct = {__index = enum}
setmetatable(struct, struct)

struct.operational = enum.new()
struct.disabled = enum.new()

return table.freeze(struct);