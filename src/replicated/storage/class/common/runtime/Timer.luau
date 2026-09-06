--!strict
const Observable = require("@game/ReplicatedStorage/class/arch/Observable")
const Notification = require("@game/ReplicatedStorage/class/common/notification/Notification")
const Controller = require("@game/ReplicatedStorage/class/common/runtime/Controller")
const ConnectionVariant = require("@game/ReplicatedStorage/enums/descriptor/ConnectionVariant")
const ActionNotification = require("@game/ReplicatedStorage/enums/notification/ActionNotification")
const ControllerState = require("@game/ReplicatedStorage/enums/state/ControllerState")
const declare = require("@game/ReplicatedStorage/static/declare")

const private = {}
const class: declare.timer = Observable:new({
	type = "timer",
	seconds = 1,
	modifier = 1,
	iterate = 1,
	previous_stepped = DateTime.now(),

	schedule = function(self: declare.timer): ()
		task.delay(self.seconds, function()
			self:notificate(Notification:new({
				on = ActionNotification.Step,
			}))
		end)
	end,

	get_delta = function(self: declare.timer): number
		return DateTime.now().UnixTimestampMillis - self.previous_stepped.UnixTimestampMillis
	end,

	get_control = function(self: declare.timer): declare.controller
		return private.ctrls[self]
	end,
})

class:host(function(new: declare.timer)
	const date = DateTime.now()
	const control = Controller:new()
	const loop = private.get_loop(new)

	new.previous_stepped = date
	private.ctrls[new] = control

	control:subscribe(ControllerState.Continue, ConnectionVariant.Ever, function()
		if not private.tasks[new] then
			private.tasks[new] = task.spawn(loop)
		end
	end)

	control:subscribe(ControllerState.Pause, ConnectionVariant.Ever, function()
		if private.tasks[new] then
			if coroutine.status(private.tasks[new]) ~= "dead" then
				task.cancel(private.tasks[new])
			end

			private.tasks[new] = nil
		end
	end)

	control:subscribe(ControllerState.Reset, ConnectionVariant.Ever, function()
		private.holds[new.identity] = new.seconds
	end)
end)

do
	private.frozen = table.freeze({ __mode = "ks" })
	private.tasks = setmetatable({} :: { [declare.timer]: thread }, private.frozen)
	private.holds = setmetatable({} :: { [unknown]: number }, private.frozen)
	private.ctrls = setmetatable({} :: { [declare.timer]: declare.controller }, private.frozen)

	function private.get_loop(new: declare.timer)
		const modificator = new.modifier
		const iterate = new.iterate
		const identity = new.identity
		private.holds[identity] = private.holds[identity] or new.seconds

		return function()
			while private.holds[identity] > 0 do
				const that = class.require(identity)

				if that == nil then
					break
				end

				if class.is(that, "timer") then
					const me = that :: declare.timer

					for i = 1, iterate do
						me:notificate(Notification:new({ on = ActionNotification.Step }))
					end
				end

				private.holds[identity] -= 1
				task.wait(1 * modificator)
			end

			task.cancel(coroutine.running())
		end
	end
end

return class
