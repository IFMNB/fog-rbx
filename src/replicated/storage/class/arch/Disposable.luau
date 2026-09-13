--!strict
const Observer = require("@game/ReplicatedStorage/class/arch/Observer")
const DisposableNotification = require("@game/ReplicatedStorage/enums/notification/DisposableNotification")
const declare = require("@game/ReplicatedStorage/static/declare")
const ftype = require("@game/ReplicatedStorage/static/ftype")

const private = {}
const class: declare.disposable = (Observer :: declare.observer<declare.enumitem_disposable_notification>):new ({
	type = "disposable",

	free = ftype:write(function(self: declare.disposable): ()
		self:notificate(DisposableNotification.OnRelease )
		private.objects[self.identity] = nil
		self:notificate(DisposableNotification.Released )
	end, declare["nil"], "disposable"),

	queue_free = ftype:write(function(self: declare.disposable): ()
		task.defer(function ()
			self:free()
		end)
	end, declare["nil"], "disposable"),
})

class:host(function(new: declare.disposable)
	private.objects[new.identity] = new
end)

do
	private.objects = {} :: { [declare.object_identity]: declare.disposable }
end

return class
