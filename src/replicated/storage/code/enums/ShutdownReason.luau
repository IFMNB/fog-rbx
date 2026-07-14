const enum = require("@game/ReplicatedStorage/code/enum")
const struct = {__index = enum}
setmetatable(struct, struct)

export type struct = typeof(struct)

local sync_id: number = 61554
local function get_id ()
    sync_id += 1
    return sync_id
end


--[=[
    Сервер был выключен в результате технических неполадок Roblox
]=]
struct.RobloxMaintenance = enum.new(get_id())

--[=[
    Сервер был выключен из-за приказа о выключении, направленного
    через дэшбоард сайт Roblox
]=]
struct.DeveloperShutdown = enum.new(get_id())

--[=[
    Сервер был выключен в ходе рассылки обновлений через
    дэшбоард сайт Roblox
]=]
struct.DeveloperUpdate = enum.new(get_id())

--[=[
    На сервере не осталось игроков
]=]
struct.ServerEmpty = enum.new(get_id())

--[=[
    Сервер, скорее всего, имел утечку памяти и был выключен в
    результате переполнения доступного ОЗУ
]=]
struct.OutOfMemory = enum.new(get_id())

--[=[
    Сервер был отключен в результате модерации Roblox
]=]
struct.Moderation = enum.new(get_id())

--[=[
    Сервер был выключен потому что был подан сигнал от разработчика
    прямо на этом сервере
]=]
struct.ConsoleRequest = enum.new(get_id())

--[=[
    Сервер был выключен потому что его синглтон был освобожден
    по неизвестной причине
]=]
struct.SingletoneDestroyed = enum.new(get_id())

--[=[
    Сервер выключен по внутриигровой причине, такой как уничтожение
    его экземпляра в ходе какого-либо режима игры
]=]
struct.GameReason = enum.new(get_id())

const map = {
    [Enum.CloseReason.Unknown] = struct.Unknown,
    [Enum.CloseReason.ServerEmpty] = struct.ServerEmpty,
    [Enum.CloseReason.RobloxMaintenance] = struct.RobloxMaintenance,
    [Enum.CloseReason.OutOfMemory] = struct.OutOfMemory,
    [Enum.CloseReason.Moderation] = struct.Moderation,
    [Enum.CloseReason.DeveloperUpdate] = struct.DeveloperUpdate,
    [Enum.CloseReason.DeveloperShutdown] = struct.DeveloperShutdown,
}

function struct.map (with: Enum.CloseReason)
    return map[with] or struct.Unknown
end



return table.freeze(struct)