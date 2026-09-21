--!strict
const Observer = require("@game/ReplicatedStorage/class/core/Observer")
const SecurityRNG = require("@game/ReplicatedStorage/class/service/SecurityRNG")
const declare = require("@game/ReplicatedStorage/static/declare")

const private = {}
const class : faction = (Observer :: observer<enumitem_faction_notification>):new {
    type = "faction",
    name = "default_faction_name",

    get_member = function (self: faction) : ...character
        return table.unpack(private.get(self))
    end,

    add_member = function (self: faction, ...: character) : ()
        const list = private.get(self)

        for _, v in {...} do
            if not table.find(list, v) then
                table.insert(list, v)
            end
        end
    end,

    rem_member = function (self: faction, ...: character) : ()
        const list = private.get(self)

        for _, v in {...} do
            table.remove(list, table.find(list, v) or 0)
        end
    end,

    is_member = function (self: faction, ...:character) : boolean
        const list = private.get(self)

        for _, v in list do
            if not table.find(list, v) then
                return false
            end
        end

        return true
    end
}


class:host(function(new: faction)
    new:set(private.key, setmetatable({}, declare.tables.__mode_vs))
end)

do
    private.key = SecurityRNG:get_hash_sha256("faction_key")
    private.get = function (self: faction)
        return self:get <<{character}>>(private.key)
    end
end

return class