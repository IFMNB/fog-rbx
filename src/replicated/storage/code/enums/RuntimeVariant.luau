const enum = require("@game/ReplicatedStorage/code/enum")
const struct = {__index = enum}
setmetatable(struct, struct)

--[=[
    Будут использовано текущее состояние runtime систем 
]=]
struct.Inherit = enum.new ""

--[=[
    Принудительно будет обрабатываться только в синхронном контексте
]=]
struct.Synchro = enum.new "PrimarySynchro"

--[=[
    Принудительно будет обрабатываться только в параллельном контексте
]=]
struct.Parallel = enum.new "Parallel"
--[=[
    Не будет обрабатываться ни в каких случаях
]=]
struct.Disabled = enum.new "Disabled"

return table.freeze(struct);