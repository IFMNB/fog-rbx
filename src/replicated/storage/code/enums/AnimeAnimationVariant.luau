const enum = require("@game/ReplicatedStorage/code/enum")
const struct = { __index = enum }
setmetatable(struct, struct)

struct.Walk = enum.new("Walk")
struct.Run = enum.new("Run")
struct.Idle = enum.new("Idle")
struct.Jump = enum.new("Jump")
struct.Fall = enum.new("Fall")
struct.Fly = enum.new("Fly")
struct.Crouch = enum.new("Crouch")
struct.Prone = enum.new("Prone")

return table.freeze(struct)