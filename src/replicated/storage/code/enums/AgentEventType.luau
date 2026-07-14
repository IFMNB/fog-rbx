const enum = require("@game/ReplicatedStorage/code/enum")
const struct = {__index = enum}
setmetatable(struct, struct)

--[=[
    Агент получает одноразовый сигнал, который предлагает
    ему запустить выполнение той или иной задачи

    Это сигнал к действию
]=]
struct.Send = enum.new("Send")

--[=[
    Агент получает событие, которое обязывает его запустить
    выполнение того или иного действия
]=]
struct.Order = enum.new("Order")

return table.freeze(struct)