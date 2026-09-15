--!strict

const Observer = require("@game/ReplicatedStorage/class/core/Observer")
const ControllerState = require("@game/ReplicatedStorage/enums/state/ControllerState")
const declare = require("@game/ReplicatedStorage/static/declare")
const ftype = require("@game/ReplicatedStorage/static/ftype")
const project = require("@game/ReplicatedStorage/static/project")

const class: controller = Observer:new({
	type = "controller",
	state = ControllerState.Pause,

	continue = ftype:write(function(self: controller): ()
		if self.state == ControllerState.Continue then
			project.console_out("contoller already running")
			return
		end

		self.state = ControllerState.Continue
		self:notificate(ControllerState.Continue )
	end, declare["nil"], "controller"),

	pause = ftype:write(function(self: controller): ()
		if self.state == ControllerState.Pause then
			project.console_out("contoller already paused")
			return
		end

		self.state = ControllerState.Pause
		self:notificate(ControllerState.Pause )
	end, declare["nil"], "controller"),

	reset = ftype:write(function(self: controller): ()
		if self.state == ControllerState.Reset then
			project.console_out("contoller already dropped(reset)")
			return
		end

		self.state = ControllerState.Reset
		self:notificate(ControllerState.Reset )
	end, declare["nil"], "controller"),
})

return class
