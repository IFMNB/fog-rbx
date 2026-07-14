const enum = require "@game/ReplicatedStorage/code/enum"
const struct = {__index = enum}
setmetatable(struct, struct)

struct.Bullet = enum.new()
struct.Fragile = enum.new()
struct.Poison = enum.new()
struct.Fire = enum.new()
struct.Melee = enum.new()
struct.Punchy = enum.new()

return table.freeze(struct)