const enum = require("@game/ReplicatedStorage/code/enum")
const struct = {__index = enum}
setmetatable(struct, struct)



return table.freeze(struct)