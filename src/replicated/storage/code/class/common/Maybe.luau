--!strict
const ValueNotificationVariant = require("@game/ReplicatedStorage/code/enums/notifications/ValueNotificationVariant")
const runtimeobject = require("../../runtimeobject")
const declare = require("../../static/declare")
const namefield = require("../../static/namefield")
const Notification = require("../common/Notification")

const private = {}
const class : declare.maybe = runtimeobject:new {
    type = namefield.maybe,

    extract = function (self: declare.maybe, it: unknown, make: () -> any) : any
        const that = private.stored[self][it] or make()

        if private.stored[self][it] == nil then
    		private.stored[self][it] = that
    		self:notificate(Notification:new({ call_on = ValueNotificationVariant.LazyValueNew }))
        end

        self:notificate(Notification:new {call_on = ValueNotificationVariant.LazyValueGet})

        return that
    end,

    exist = function (self: declare.maybe, it: unknown) : boolean
        return private.stored[self][it] ~= nil
    end,

    erase = function (self: declare.maybe, it: unknown) : ()
        private.stored[self][it] = nil
        self:notificate(Notification:new {call_on = ValueNotificationVariant.LazyValueRemoved})
    end
}

class:toggle_host(function(new: declare.maybe)
    private.stored[new] = setmetatable({}, private.frozen)
end)

do
    private.frozen = table.freeze {__mode = "ks"}
    private.stored = setmetatable({} :: {[declare.maybe]: setmetatable<{[unknown]: any}, typeof(private.frozen)>}, private.frozen)
end

return class