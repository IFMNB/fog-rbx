const enum = require("@game/ReplicatedStorage/code/enum")
const struct = { __index = enum }
setmetatable(struct, struct)

--[=[
    Канал для внешнего небезопасного, но быстрого общения с клиентами
    через `UnreliableRemoteEvent`
]=]
struct.Unsafe = enum.new("Unsafe")
--[=[
    Канал для внешнего безопасного, но медленного общения с клиентами
    через `RemoteEvent`
]=]
struct.Safe = enum.new("Safe")

--[=[
    Канал для внутреннего общения внутри сети, потому что работает на
    основе `BindableEvent`
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