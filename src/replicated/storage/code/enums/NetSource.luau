const Players = game:GetService("Players")
const RunService = game:GetService("RunService")
const enum = require("@game/ReplicatedStorage/code/enum")
const struct = { __index = enum }
setmetatable(struct, struct)

--[=[
    Источник этого сетевого трафика - сервер

    Обращения с `NetSource.FromServer`, полученные от клиентов,
    приведут к автоматическому кику клиента
]=]
struct.FromServer = enum.new "FromServer"

--[=[
    Источник этого сетевого трафика - эта машина

    Существует только на стороне этой текущей машины, на которой
    работает этот код. Иначе всегда преобразуется в `NetSource.FromClient`
]=]
struct.FromMe = enum.new "FromMe"

--[=[
    Источник этого сетевого трафика - другой клиент

    Определяется на стороне сервера вручную
]=]
struct.FromClient = enum.new "FromClient"

--[=[
    `NetSource.FromClient` и `NetSource.FromServer` устанавливается только вручную
]=]
function struct:get_enum_by_current_machine () : number
    const this = self :: enum.class

    if (RunService:IsServer()) then
        return this.FromMe
    else
        if (Players.LocalPlayer) then
            return this.FromMe
        else
            return this.Unknown
        end
    end
end

return table.freeze(struct)
