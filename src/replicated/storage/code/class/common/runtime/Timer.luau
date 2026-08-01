--!strict
const Notification = require("@game/ReplicatedStorage/code/class/common/Notification")
const NotificationType = require("@game/ReplicatedStorage/code/enums/notifications/NotificationVariant")
const runtimeobject = require("@game/ReplicatedStorage/code/runtimeobject")
const declare = require("@game/ReplicatedStorage/code/static/declare")
const namefield = require("@game/ReplicatedStorage/code/static/namefield")
const project = require("@game/ReplicatedStorage/code/static/project")

const private = {}
const class : declare.timer = runtimeobject:new {
	type = namefield.timer,
	seconds = 1,
	modifier = 1,
	iterate = 1,

	wait = function (self: declare.timer) : ()
		self:get_notification_event():wait(NotificationType.Stepped)
	end,

	bind = function (self: declare.timer, f: (()->())|thread) : declare.connection
		return self:get_notification_event():once(f :: ((...any)->()|thread), NotificationType.Stepped)
	end,

	continue = function (self: declare.timer) : ()
		const tasked = private.get_task(self)
		const status = coroutine.status(tasked)

		if status == "suspended" then
			task.spawn(tasked)
		elseif status == "dead" then
			project.console_out_error "timer cannot reach his task"
		end
	end,

	pause = function (self: declare.timer) : ()
		task.cancel(private.get_task(self))
		private.tasks[self] = nil
	end,

	reset = function (self: declare.timer) : ()
		private.holds[self] = self.seconds
	end,

	schedule = function (self: declare.timer) : ()
		task.delay(self.seconds, function ()
			self:notificate(Notification:new {
				call_on = NotificationType.Stepped
			})
		end)
	end
}

class:toggle_host(function(new: declare.timer)
	new:reset()
	new:pause()
end)

do
	private.frozen = table.freeze {__mode = "ks"}
	private.tasks = setmetatable({} :: {[declare.timer]: thread}, private.frozen)
	private.holds = setmetatable({} :: {[declare.timer]: number}, private.frozen)

	function private.get_task (to: declare.timer)
		const tasked = private.tasks[to] or coroutine.create(function ()
			const notification = Notification:new {
				call_on = NotificationType.Stepped
			}
			
			while private.holds[to] > 0 do
				private.holds[to] -= 1

				for i = 1, to.iterate do
					to:notificate(notification)
				end

				task.wait(1 * to.modifier)
			end

			private.tasks[to] = nil
		end)

		private.tasks[to] = tasked
		
		return tasked
	end
end

return class