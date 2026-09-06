--!strict
const Observable = require("@game/ReplicatedStorage/class/arch/Observable")
const Notification = require("@game/ReplicatedStorage/class/common/notification/Notification")
const ConnectionVariant = require("@game/ReplicatedStorage/enums/descriptor/ConnectionVariant")
const ActionNotification = require("@game/ReplicatedStorage/enums/notification/ActionNotification")
const DisposableNotification = require("@game/ReplicatedStorage/enums/notification/DisposableNotification")
const declare = require("@game/ReplicatedStorage/static/declare")

const project = require("@game/ReplicatedStorage/static/project")

const private = {}
const class: declare.disposable = Observable:new({
	type = "disposable",

	free = function(self: declare.disposable): ()
		self:notificate(Notification:new({ on = DisposableNotification.OnRelease }))

		task.delay(0, function()
			private.objects[self.identity] = nil
			self:notificate(Notification:new({ on = DisposableNotification.Released }))
		end)
	end,

	queue_free = function(self: declare.disposable): ()
		const code = project.run(self.free, self)

		if code == 4 then
			self:subscribe(ActionNotification.Signal, ConnectionVariant.Once, "free")
		end
	end,
})

class:host(function(new: declare.disposable)
	private.objects[new.identity] = new
end)

do
	private.objects = {} :: { [declare.object_identity]: declare.disposable }
end

return class
