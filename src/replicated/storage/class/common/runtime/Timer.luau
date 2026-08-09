--!strict
const Notification = require("@game/ReplicatedStorage/class/common/Notification")
const Controller = require("@game/ReplicatedStorage/class/common/runtime/Controller")
const ConnectionMode = require("@game/ReplicatedStorage/enums/ConnectionMode")
const ControllerNotificationVariant =
	require("@game/ReplicatedStorage/enums/notifications/ControllerNotificationVariant")
const NotificationType = require("@game/ReplicatedStorage/enums/notifications/NotificationVariant")
const runtimeobject = require("@game/ReplicatedStorage/runtimeobject")
const declare = require("@game/ReplicatedStorage/static/declare")
const namefield = require("@game/ReplicatedStorage/static/namefield")

const private = {}
const class: declare.timer = runtimeobject:new({
	type = namefield.timer,
	seconds = 1,
	modifier = 1,
	iterate = 1,
	previous_stepped = DateTime.now(),

	wait = function(self: declare.timer): ()
		self:get_notification_event():wait(NotificationType.Stepped)
	end,

	bind = function(self: declare.timer, f: (() -> ()) | thread): declare.connection
		return self:get_notification_event():connect(f :: (...any) -> () | thread, NotificationType.Stepped)
	end,

	schedule = function(self: declare.timer): ()
		task.delay(self.seconds, function()
			self:notificate(Notification:new({
				call_on = NotificationType.Stepped,
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

class:toggle_host(function(new: declare.timer)
	const date = DateTime.now()
	const control = Controller:new()
	const loop = private.get_loop(new)

	new.previous_stepped = date
	private.ctrls[new] = control

	control:toggle_notice(function()
		if not private.tasks[new] then
			private.tasks[new] = task.spawn(loop)
		end
	end, ControllerNotificationVariant.Continue, ConnectionMode.Ever)

	control:toggle_notice(function()
		if private.tasks[new] then
			if coroutine.status(private.tasks[new]) ~= "dead" then
				task.cancel(private.tasks[new])
			end

			private.tasks[new] = nil
		end
	end, ControllerNotificationVariant.Pause, ConnectionMode.Ever)

	control:toggle_notice(function()
		private.holds[new.identity] = new.seconds
	end, ControllerNotificationVariant.Reset, ConnectionMode.Ever)
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
						me:notificate(Notification:new({ call_on = NotificationType.Stepped }))
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
