--!strict

const Observable = require("@game/ReplicatedStorage/class/arch/Observable")
const Notification = require("@game/ReplicatedStorage/class/common/notification/Notification")
const ControllerState = require("@game/ReplicatedStorage/enums/state/ControllerState")
const declare = require("@game/ReplicatedStorage/static/declare")
const namefield = require("@game/ReplicatedStorage/static/namefield")
const project = require("@game/ReplicatedStorage/static/project")

const class: declare.controller = Observable:new({
	type = namefield.controller,
	state = ControllerState.Pause,

	continue = function(self: declare.controller): ()
		if self.state == ControllerState.Continue then
			project.console_out("contoller already running")
			return
		end

		self.state = ControllerState.Continue
		self:notificate(Notification:new({ on = ControllerState.Continue }))
	end,

	pause = function(self: declare.controller): ()
		if self.state == ControllerState.Pause then
			project.console_out("contoller already paused")
			return
		end

		self.state = ControllerState.Pause
		self:notificate(Notification:new({ on = ControllerState.Pause }))
	end,

	reset = function(self: declare.controller): ()
		if self.state == ControllerState.Reset then
			project.console_out("contoller already dropped(reset)")
			return
		end

		self.state = ControllerState.Reset
		self.notificate(self, Notification:new({ on = ControllerState.Reset }))
	end,
})

return class
