const enum = require("@game/ReplicatedStorage/code/enum")
const struct = {__index = enum}
setmetatable(struct, struct)

struct.LazyKeys = enum.new()
struct.LazyValues = enum.new()
struct.LazyAll = enum.new()
struct.Strong = enum.new()

return table.freeze(struct)