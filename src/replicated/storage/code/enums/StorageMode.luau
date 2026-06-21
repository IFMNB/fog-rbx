const enum = require("@game/ServerStorage/code/enum")
const struct = {}

struct.LazyKeys = enum.new()
struct.LazyValues = enum.new()
struct.LazyAll = enum.new()
struct.Strong = enum.new()

return table.freeze(struct)