--!strict

const Notification = require("@game/ReplicatedStorage/code/class/common/Notification")
const ControllerNotificationVariant = require("@game/ReplicatedStorage/code/enums/notifications/ControllerNotificationVariant")
const runtimeobject = require("@game/ReplicatedStorage/code/runtimeobject")
const declare = require("@game/ReplicatedStorage/code/static/declare")
const namefield = require("@game/ReplicatedStorage/code/static/namefield")

const class : declare.controller = runtimeobject:new {
    type = namefield.controller,
    state = ControllerNotificationVariant.Continue,

    continue = function (self: declare.controller) : ()
        if self.state == ControllerNotificationVariant.Continue then
            return
        end
        
        self.state = ControllerNotificationVariant.Continue 
	    self:notificate(Notification:new({ call_on = ControllerNotificationVariant.Continue }))
    end,

    pause = function (self: declare.controller) : ()
        if self.state == ControllerNotificationVariant.Pause then
            return
        end

    	self.state = ControllerNotificationVariant.Pause
	    self:notificate(Notification:new({ call_on = ControllerNotificationVariant.Pause }))
    end,

    reset = function (self: declare.controller) : ()
        if self.state == ControllerNotificationVariant.Reset then
            return
        end
        
        self.state = ControllerNotificationVariant.Reset
        self:notificate(Notification:new {call_on = ControllerNotificationVariant.Reset})
        self:pause()
    end
}

return class