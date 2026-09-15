--!strict
const Observer = require("@game/ReplicatedStorage/class/core/Observer")
const Controller = require("@game/ReplicatedStorage/class/common/runtime/Controller")
const ConnectionVariant = require("@game/ReplicatedStorage/enums/descriptor/ConnectionVariant")
const ActionNotification = require("@game/ReplicatedStorage/enums/notification/ActionNotification")
const ControllerState = require("@game/ReplicatedStorage/enums/state/ControllerState")
const declare = require("@game/ReplicatedStorage/static/declare")
const ftype = require("@game/ReplicatedStorage/static/ftype")

--TODO

const private = {}
const class: timer = Observer:new({
	type = "timer",
	seconds = 1,
	modifier = 1,
	iterate = 1,
	previous_stepped = DateTime.now(),

	schedule = ftype:write(function(self: timer): ()
		task.delay(self.seconds, function()
			self:notificate(ActionNotification.Step)
		end)
	end, declare["nil"], "timer"),

	get_delta = ftype:write(function(self: timer): number
		return DateTime.now().UnixTimestampMillis - self.previous_stepped.UnixTimestampMillis
	end, declare.number, "timer"),

	get_control = ftype:write(function(self: timer): controller

	end, "controller", "timer"),
})

class:host(function(new: timer)

end)

do

end

return class
