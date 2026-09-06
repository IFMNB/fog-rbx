--!strict

const StateMachine = require("@game/ReplicatedStorage/class/StateMachine")
const declare = require("@game/ReplicatedStorage/static/declare")
const Node = require("@game/ReplicatedStorage/class/actors/Node") :: declare.node<PVInstance>
const Maybe = require("@game/ReplicatedStorage/class/common/gc/Maybe")
const Inventory = require("@game/ReplicatedStorage/class/game/Inventory")
const UnitDescription = require("@game/ReplicatedStorage/class/game/units/UnitDescription")
const State = require("@game/ReplicatedStorage/enums/state/State")
const project = require("@game/ReplicatedStorage/static/project")
const BoundBox = require("@game/ReplicatedStorage/struct/geometry/BoundBox")

const private = {}
const class : declare.unit = Node:new {
    type = "unit",

    can_equip_items = false,
    speed = 0,
    health = 100,

    get_volume = function (self: declare.unit) : declare.boundbox
        return private.volume[self]
    end,

    get_description = function (self: declare.unit) : declare.unitdescription
        return private.dsc:extract(self, private.mkdsc)
    end,

    set_description = function (self: declare.unit, to: declare.unitdescription) : ()
        if private.dsc:exist(self) then
            private.dsc:erase(self)
        end

        if to then
            private.dsc:extract(self, function()
                return to
            end)
        end
    end,

    get_equipped = function (self: declare.unit) : {declare.item}
        return table.clone(private.equipped[self])
    end,

    set_equipped = function (self: declare.unit, that: declare.item|{declare.item}, to: boolean?) : ()
        const equipped = private.equipped[self]
        
        if self.is(that, "item") then
            table.insert(equipped, that :: declare.item)
        elseif type(that) == declare.table then
            table.move(that :: {declare.item}, 1, #that, #that + 1, equipped)
        else
            project.console_out_error "expected item|{item}, got *hidden*"
            return
        end
    end,

    is_equipped = function (self: declare.unit, that: declare.item|{declare.item}) : boolean
        const equipped = private.equipped[self]
        
        if self.is(that, "item") then
            return table.find(equipped, that :: declare.item) ~= nil
        elseif type(that) == declare.table then
            for _, v in that :: {declare.item} do
                if not table.find(equipped, v) then
                    return false
                end
            end

            return true
        else
            project.console_out_error "expected item|{item}, got *hidden*"
            return nil :: never
        end
    end,

    get_inventory = function (self: declare.unit) : declare.inventory
        return private.inv:extract(self, private.mkinv)
    end,

    set_inventory = function (self: declare.unit, to: declare.inventory?) : ()
        if private.inv:exist(self) then
            private.inv:erase(self)
        end

        if to then
            private.inv:extract(self, function()
                return to
            end)
        end
    end,

    get_state_machgine = function (self: declare.unit) : declare.statemachine
        return private.sfm:extract(self, private.mksfm)
    end
}

class:host(function(new: declare.unit)
    private.equipped[new] = {}
    private.volume = BoundBox:new()

end)

do
    private.meta = table.freeze {__mode = "ks"}
    private.equipped = setmetatable({} :: {[declare.unit]: {declare.item}}, private.meta)
    private.volume = setmetatable({} :: {[declare.unit]: declare.boundbox}, private.meta)
    private.dsc = Maybe:new()
    private.inv = Maybe:new()
    private.sfm = Maybe:new()
    private.mkdsc = function () return UnitDescription:new() end
    private.mkinv = function () return Inventory:new() end
    private.mksfm = function () return StateMachine:new() end
    table.freeze(private)
end


return class