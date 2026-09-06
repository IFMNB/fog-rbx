--!strict
const PickUp = require("@game/ReplicatedStorage/class/game/PickUp")
const ConnectionVariant = require("@game/ReplicatedStorage/enums/descriptor/ConnectionVariant")
const InventoryNotification = require("@game/ReplicatedStorage/enums/notification/InventoryNotification")
const declare = require("@game/ReplicatedStorage/static/declare")

const project = require("@game/ReplicatedStorage/static/project")

const private = {}
const class : declare.inventory = (PickUp :: declare.pickup<declare.enumitem_inventory_notification>):new {
    type = "inventory",
    owner = nil :: unknown,
    can_insert_items = true,
    can_remove_items = true,

    get_items_with_type = function <T> (self: declare.inventory, type: string) : {T}
        const result = {}

        for _, v in private.items[self] do
            if v:is(type) then
                table.insert(result, v)
            end
        end

        return result    
    end,
    
    get_items = function (self: declare.inventory<any>) : {declare.item}
        const result = {}
        
        for _, v in private.items[self] do
            table.insert(result, v)
        end

        return result
    end,
    
    insert_item = function (self: declare.inventory, that: declare.item) : ()
        const is_existed = self:is_in_inventory(that)
        if is_existed then return end

        private.items[self][that.identity] = that
    	self:notificate(InventoryNotification.ItemAdded)
    end, 

    remove_item = function (self: declare.inventory, that: declare.item) : ()
        const is_existed = self:is_in_inventory(that)

        private.items[self][that.identity] = nil

        if is_existed then
            self:notificate(InventoryNotification.ItemRemoved) 
        end
    end,

    is_in_inventory = function (self: declare.inventory, that: declare.item) : boolean
        return private.items[self][that.identity] ~= nil
    end,

    get_last_added = function (self: declare.inventory) : declare.item?
        return private.last[self]
    end,

    get_owner = function (self: declare.inventory) : declare.unit|nil
        if not self.owner then return nil end

        const object = self.require <<declare.object?>>(self.owner)
        if object then
            if self.is(object, "unit") then
                return object :: declare.unit
            else
                project.console_out_error "owner of the item is being used incorrectly because the resulting object is not an authorized object, and the result has been reset"
            end
        end

        return nil
    end
}

class:host(function(new: declare.inventory)
    new:subscribe(InventoryNotification.ItemAdded, ConnectionVariant.Ever, function ()
        
    end)
end)

do
    private.meta = table.freeze {__mode = "ks"}
    private.items = setmetatable({} :: {[declare.inventory]: {[unknown]: declare.item?}}, private.meta)
    private.last = setmetatable({} :: {[declare.inventory]: declare.item?}, private.meta)
end

return class