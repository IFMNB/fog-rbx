const enum = require("@game/ReplicatedStorage/code/enum")
const struct = { __index = enum }
setmetatable(struct, struct)

struct.FromServer = enum.new "FromServer"
struct.FromMe = enum.new "FromMe"
struct.FromClient = enum.new "FromClient"

return table.freeze(struct)
