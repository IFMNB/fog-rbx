const enum = require("@game/ReplicatedStorage/code/enum")
const struct = { __index = enum }
setmetatable(struct, struct)

--[=[
    Для общения с клиентами через UnreliableRemoteEvent
]=]
struct.Unsafe = enum.new("Unsafe")
--[=[
    Для общения с клиентами через RemoteEvent
]=]
struct.Safe = enum.new("Safe")

--[=[
    Для внутреннего общения
]=]
struct.Internal = enum.new "Internal"

function struct.get_variant (of: number) : string?
    if (of == struct.Unsafe) then
        return "UnreliableRemoteEvent"
    elseif (of == struct.Safe) then
        return "RemoteEvent"
    else
        return nil
    end
end

return table.freeze(struct)