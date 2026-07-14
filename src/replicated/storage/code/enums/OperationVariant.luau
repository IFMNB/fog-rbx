const enum = require("@game/ReplicatedStorage/code/enum")
const struct = {__index = enum}
setmetatable(struct, struct)

--[=[
    Система обязана выполнить операцию вычитания с указанным аргументом
]=]
struct.Substract = enum.new("Substract")

--[=[
    Система обязана выполнить операцию прибавления с указанным аргументом
]=]
struct.Add = enum.new("Add")

--[=[
    Система обязана выполнить операцию умножения с указанным аргументом
]=]
struct.Multiple = enum.new("Multiple")

--[=[
    Система обязана выполнить операцию деления с указанным аргументом
]=]
struct.Divide = enum.new("Divide")

return table.freeze(struct)