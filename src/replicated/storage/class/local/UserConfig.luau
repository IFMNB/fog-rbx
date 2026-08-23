--!strict
const Observable = require("@game/ReplicatedStorage/class/arch/Observable")
const DefaultVariant = require("@game/ReplicatedStorage/enums/descriptor/DefaultVariant")
const OperationVariant = require("@game/ReplicatedStorage/enums/descriptor/OperationVariant")
const declare = require("@game/ReplicatedStorage/static/declare")

const private = {}
const class : declare.userconfig = Observable:new {
    type = "userconfig",

    get_map = function (self: declare.userconfig) : {[declare.enumitem_action_map_variant]:  {Enum.KeyCode}}
        const result = {}

        for i, v in private.configs[self] do
            result[i] = table.clone(v)
        end

        return result
    end,

    get_last_changed = function (self: declare.userconfig) : (declare.enumitem_operation_variant, declare.enumitem_action_map_variant|declare.enumitem_default_variant, Enum.KeyCode)
        const last = private.last_changed[self]
        if last then
            return last.operation, last.item, last.of
        else
            return OperationVariant.Change, DefaultVariant.Unknown, Enum.KeyCode.None
        end
    end,

    insert_item = function (self: declare.userconfig, item: declare.enumitem_action_map_variant, to: Enum.KeyCode) : ()
	    const page = private.configs[self][item] or {}
        table.insert(page, to)
        private.configs[self][item] = page
        
        self:notificate(OperationVariant.Change)
	    self:notificate(OperationVariant.New)
    end,

    remove_item = function (self: declare.userconfig, item: declare.enumitem_action_map_variant, to: Enum.KeyCode) : ()
	    const page = private.configs[self][item]
        if page then
            const pos = table.find(page, to)
            if pos then
                table.remove(page, pos)

    			self:notificate(OperationVariant.Change)
                self:notificate(OperationVariant.Remove)
            end
        end


    end,

    is_exists = function (self: declare.userconfig, item: declare.enumitem_action_map_variant, to: Enum.KeyCode) : boolean
        const page = private.configs[self][item]
        if page then
            return table.find(page, to) ~= nil
        end

        return false
    end,
}

class:host(function(new: declare.userconfig)
    private.configs[new] = setmetatable({}, private.meta)
end)

do
    type last = {
        item: declare.enumitem_action_map_variant,
        of: Enum.KeyCode,
        operation: declare.enumitem_operation_variant
    }

    private.meta = table.freeze {__mode = "ks"}
    private.last_changed = setmetatable({} :: {[declare.userconfig]: last?}, private.meta)
    private.configs = setmetatable({} :: {[declare.userconfig]: {[declare.enumitem_action_map_variant]: {Enum.KeyCode}?}}, private.meta)
end

return class