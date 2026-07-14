const enum = require("@game/ReplicatedStorage/code/enum")
const struct = {__index = enum}
setmetatable(struct, struct)


--[=[
    Направление согласно `Enum.Axis`

    Конкретно это направление `Vector3.yAxis`
]=]
struct.Top = enum.new("Top")

--[=[
    Направление согласно `Enum.Axis`

    Конкретно это направление `-Vector3.yAxis`
]=]
struct.Bottom = enum.new("Bottom")

--[=[
    Направление согласно `Enum.Axis`

    Конкретно это направление `Vector3.xAxis`
]=]
struct.Right = enum.new("Right")

--[=[
    Направление согласно `Enum.Axis`

    Конкретно это направление `-Vector3.xAxis`
]=]
struct.Left = enum.new("Left")

--[=[
    Направление согласно `Enum.Axis`

    Конкретно это направление `-Vector3.zAxis`
]=]
struct.Front = enum.new("Front")

--[=[
    Направление согласно `Enum.Axis`

    Конкретно это направление `Vector3.zAxis`
]=]
struct.Back = enum.new("Back")

--[=[
    Является направлением __от__ центра мирового пространства
    к этому центру, то есть это результат вычисления направления
    куда нужно идти от центра мира, чтобы прийти сюда
]=]
struct.Center = enum.new("Center")

return table.freeze(struct)