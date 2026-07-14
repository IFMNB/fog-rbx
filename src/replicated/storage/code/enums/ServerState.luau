const enum = require("@game/ReplicatedStorage/code/enum")
const struct = {__index = enum}
setmetatable(struct, struct)

--[=[
    Сервер подготавливается к выключению, после конца текущей сессии
    или активации сигнала выключения, сервер будет уничтожен
]=]
struct.PendingShutdown = enum.new("PendingShutdown")

--[=[
    Сервер на данный момент выключается
]=]
struct.Shutdown = enum.new("Shutdown")

--[=[
    Сервер был инициализирован сейчас, и на данный момент, проходит
    проверки и подгружает информацию
]=]
struct.InitiatedNow = enum.new("InitiatedNow")

--[=[
    Сервер в штатном состоянии
]=]
struct.Online = enum.new("Online")

--[=[
    По неизвестной причине сервер находится в критическом состоянии:
    не отвечает на запросы, или не может продолжать игру, или что-то
    иное, что не дает ему работать
]=]
struct.Critical = enum.new "Critical"

return table.freeze(struct)