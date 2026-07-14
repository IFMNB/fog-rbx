const enum = require("@game/ReplicatedStorage/code/enum")
const struct = {__index = enum}
setmetatable(struct, struct)

--[=[
    Ожидает объект, тип которого соответствует этому значению
]=]
struct.Mesh = enum.new("Mesh")

--[=[
    Ожидает объект, тип которого соответствует этому значению
]=]
struct.Animation = enum.new("Animation")

--[=[
    Ожидает объект, тип которого соответствует этому значению
]=]
struct.Module = enum.new("Module")

--[=[
    Ожидает объект, тип которого соответствует этому значению
]=]
struct.Image = enum.new("Image")

--[=[
    Ожидает объект, тип которого соответствует этому значению
]=]
struct.Sound = enum.new("Sound")

--[=[
    Ожидает объект, тип которого соответствует этому значению
]=]
struct.Model = enum.new("Model")

return table.freeze(struct)