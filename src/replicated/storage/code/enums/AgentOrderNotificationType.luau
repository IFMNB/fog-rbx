const enum = require("@game/ReplicatedStorage/code/enum")
const struct = {__index = enum}
setmetatable(struct, struct)

--[=[
    Обязывает Агента вызвать функцию с определенным названием
]=]
struct.Execute = enum.new("Execute")

return table.freeze(struct)