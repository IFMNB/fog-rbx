const enum = require("@game/ReplicatedStorage/code/enum")
const struct = {__index = enum}
setmetatable(struct, struct)

struct.connected = enum.new()
struct.once = enum.new()
struct.disconnected = enum.new()
struct.initiated = enum.new()

return table.freeze(struct);