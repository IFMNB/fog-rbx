--!strict
const StateMachine = require("@game/ReplicatedStorage/class/common/StateMachine")
const Maybe = require("@game/ReplicatedStorage/class/common/gc/Maybe")
const Timer = require("@game/ReplicatedStorage/class/common/runtime/Timer")
const Faction = require("@game/ReplicatedStorage/class/game/control/Faction")
const SecurityRNG = require("@game/ReplicatedStorage/class/service/SecurityRNG")

const private = {}
const class : round = Timer:new {
    type = "round",

    get_faction = function (self: round) : ...faction
        return unpack(private.get_factions(self))
    end,

    add_faction = function (self: round, ...: faction) : ()
        const list = private.get_factions(self)

        for _, v in {...} do
            if not table.find(list, v) then
                table.insert(list, v)
            end
        end
    end,

    rem_faction = function (self: round, ...: faction) : ()
        const list = private.get_factions(self)

        for _, v in {...} do
            table.remove(list, table.find(list, v) or 0)
        end
    end,

    has_faction = function (self: round, ...: faction) : boolean
        const list = private.get_factions(self)

        for _, v in {...} do
            if not table.find(list, v) then
                return false
            end
        end

        return true
    end,

    find_member = function (self: round, ...: character) : {[character]: {faction}?}
        const list = private.get_factions(self)
        const result: {[character]: {faction}?} = {}

        for _, character in {...} do
            for _, faction in list do
                if faction:is_member(character) then
                    if not result[character] then
                        result[character] = {faction}
                    else
                        table.insert(result[character] :: {faction}, faction)
                    end
                end
            end
        end

        return result
    end,

    get_members = function (self: round): faction
        return private.members:enactment(self, Faction)
    end,

    get_states = function (self: round) : statemachine
        return private.machines:enactment(self, StateMachine)
    end
}

class:host(function(new: round)
    new:set(private.factions_key, {})
end)

do
    private.factions_key = SecurityRNG:get_hash_sha256("round_factions_key")
    private.members = Maybe:new() :: maybe<faction, round>
    private.machines = Maybe:new() :: maybe<statemachine, round>

    private.get_factions = function (self: round)
        return self:get <<{faction}>>(private.factions_key)
    end
end

return class