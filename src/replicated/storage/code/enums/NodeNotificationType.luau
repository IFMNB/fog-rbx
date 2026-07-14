-- NOTE
-- Нода сообщает об особых событиях через ивент notification_event.
-- События которые она сообщает обычно не требуют отдельных ивентов.

const enum = require("@game/ReplicatedStorage/code/enum")
const struct = {__index = enum}
setmetatable(struct, struct)

--[=[
    Значение этой ноды было изменено
]=]
struct.ValueChanged = enum.new("ValueChanged")

--[=[
    Для этой ноды было создано новое значение
]=]
struct.NewValue = enum.new("NewValue")

--[=[
    Для этой ноды было создано новое ленивое значение
]=]
struct.NewLazyValue = enum.new("NewLazyValue")

--[=[
    Экземпляр к которому нода была привязана оказался уничтожен
]=]
struct.InstanceDestroyed = enum.new "InstanceDestroyed"


return table.freeze(struct);