--!strict
const Maybe = require("@game/ReplicatedStorage/class/common/Maybe")
const Reference = require("@game/ReplicatedStorage/class/common/Reference")
const Package = require("@game/ReplicatedStorage/class/common/notification/Package")
const Event = require("@game/ReplicatedStorage/class/common/signal/Event")
const ConnectionVariant = require("@game/ReplicatedStorage/enums/descriptor/ConnectionVariant")
const ActionNotification = require("@game/ReplicatedStorage/enums/notification/ActionNotification")
const ReferenceNotification = require("@game/ReplicatedStorage/enums/notification/ReferenceNotification")
const declare = require("@game/ReplicatedStorage/static/declare")
const namefield = require("@game/ReplicatedStorage/static/namefield")

const private = {}
const class : declare.signal = Reference:new <<declare.reference<RBXScriptSignal>>> {
    type = namefield.signal,

    get_signal_event = function (self: declare.signal) : declare.event<declare.enumitem_action_notification, ...unknown>
        return private.maybe:extract(self, function()
            return Event:new()
        end)
    end
}

class:host(function(new: declare.signal)
    new:subscribe(ReferenceNotification.ChangedInstance, ConnectionVariant.Ever, function ()
        const con = private.con[new]
        if con then
            con:Disconnect()
        end

        private.con[new] = new:get_instance():Connect(function(...: unknown)
            if private.maybe:exist(new) then
                new:get_signal_event():invoke(Package:new <<declare.enumitem_action_notification>> {
                    on = ActionNotification.Emit,
                    pack = {
                        ...
                    } 
                })
            end
        end)
    end)
    new:subscribe(ReferenceNotification.NullifiedInstance, ConnectionVariant.Ever, function ()
        const con = private.con[new]
        if con then
            private.con[new] = nil
            con:Disconnect()
        end
    end)
end)

do
    private.maybe = Maybe:new()
    private.con = setmetatable({} :: {[declare.signal]: RBXScriptConnection?}, table.freeze {__mode = "ks"})
end

return class