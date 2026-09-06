--!strict
const StateMachine = require("@game/ReplicatedStorage/class/StateMachine")
const Maybe = require("@game/ReplicatedStorage/class/common/gc/Maybe")
const PickUp = require("@game/ReplicatedStorage/class/game/PickUp")
const ItemNotification = require("@game/ReplicatedStorage/enums/notification/ItemNotification")
const declare = require("@game/ReplicatedStorage/static/declare")

const project = require("@game/ReplicatedStorage/static/project")

const private = {}
const class: declare.item = (PickUp :: declare.pickup<declare.enumitem_item_notification>):new({
	type = "item",
    owner = nil :: unknown,
	equipable = false,

    equip = function(self: declare.item) : ()
        if self.equipable and not self:is_equipped() then
            private.equipped[self] = true
            self:notificate(ItemNotification.Equipped)
        end
    end,

    unequip = function (self: declare.item) : ()
        if self.equipable and self:is_equipped() then
            private.equipped[self] = false
            self:notificate(ItemNotification.Unequipped)
        end
    end,

    is_equipped = function (self: declare.item) : boolean
        return private.equipped[self] or false
    end,
	
    show_item = function(self: declare.item, set: boolean?): ()
        project.console_out_error "TODO"
    end,

	get_main_grip = function(self: declare.item): declare.reference<PVInstance?>?
        return private.grip[self]
    end,

    set_main_grip = function (self: declare.item, to: declare.reference<PVInstance?>?) : ()
        private.grip[self] = to
    end,

	get_secondary_grip = function(self: declare.item): declare.reference<PVInstance?>?
        const limit = #private.grips[self]

        if limit > 0 then
            const rand = Random.new():NextInteger(1, limit)
            return private.grips[self][rand]
        end
        
        return nil
    end,

	insert_secondary_grip = function(self: declare.item, of: declare.reference<PVInstance?>): ()
        const grips = private.grips[self]
        const pos = table.find(grips, of)

        if not pos then
            table.insert(grips, of)
        end
    end,

	remove_secondary_grip = function(self: declare.item, of: declare.reference<PVInstance?>): ()
        const grips = private.grips[self]
        const pos = table.find(grips, of)

        if pos then
            table.remove(grips, pos)
        end
    end,

	get_state_machine = function(self: declare.item): declare.statemachine<declare.enumitem>
        return private.sfm:extract(self, function()
            return StateMachine:new() :: declare.statemachine<declare.enumitem>
        end)
    end,

    get_owner = function (self: declare.item) : declare.object|nil
        if not self.owner then return nil end

        const object = self.require <<declare.object?>>(self.owner)
        if object then
            if self.is(object, "unit") or self.is(object, "inventory") then
                return object :: declare.inventory|declare.unit
            else
                project.console_out_error "owner of the item is being used incorrectly because the resulting object is not an authorized object, and the result has been reset"
            end
        end

        return nil
    end
})

class:host(function(new: declare.item)
    private.grips[new] = {}
end)

do
    private.meta = table.freeze {__mode = "ks"}
    private.sfm = Maybe:new()
    private.grips = setmetatable({} :: {[declare.item]: {declare.reference<PVInstance?>}}, private.meta)
    private.grip = setmetatable({} :: {[declare.item]: declare.reference<PVInstance?>?}, private.meta)
    private.equipped = setmetatable({} :: {[declare.item]: boolean?}, private.meta)
end

return class
