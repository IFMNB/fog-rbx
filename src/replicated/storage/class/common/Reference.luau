--!strict
const Observable = require("@game/ReplicatedStorage/class/arch/Observable")
const Notification = require("@game/ReplicatedStorage/class/common/notification/Notification")
const ReferenceNotification = require("@game/ReplicatedStorage/enums/notification/ReferenceNotification")
const declare = require("@game/ReplicatedStorage/static/declare")

const project = require("@game/ReplicatedStorage/static/project")

const private = {}
const class: declare.reference = Observable:new({
	type = "reference",

	get_instance = function(self: declare.reference): any?
		return private.stored[self]
	end,

	set_instance = function(self: declare.reference, to: any): ()
		const stored = private.stored[self]
		const connection = private.connections[self]
		private.stored[self] = to

		if connection then
			connection:Disconnect()
			private.connections[self] = nil
		end

		if typeof(to) == "Instance" then
			const that = to :: Instance

			private.connections[self] = that.Destroying:Once(function()
				self:notificate(Notification:new({ on = ReferenceNotification.DestroyedInstance }))
			end)
		end

		if stored == nil and to == nil then
			self:notificate(Notification:new({ on = ReferenceNotification.NullifiedInstance }))
		elseif stored == nil and to ~= nil then
			self:notificate(Notification:new({ on = ReferenceNotification.NewInstance }))
		elseif stored ~= to then
			self:notificate(Notification:new({ on = ReferenceNotification.ChangedInstance }))
		else
			project.console_out("missmatch reference")
		end
	end,

	is_instance_exists = function(self: declare.reference): boolean
		return typeof(self:get_instance()) == "Instance"
	end,

	clear = function(self: declare.reference): ()
		const instance = self:get_instance()
		if instance and type(instance) == declare.roblox.Instance then
			const rbx_instance = instance :: Instance
			rbx_instance:Destroy()
		end

		self:set_instance(nil :: any)
	end,
})

do
	private.frozen = table.freeze({ __mode = "ks" })
	private.stored = setmetatable({} :: { [declare.reference]: Instance }, private.frozen)
	private.connections = setmetatable({} :: { [declare.reference]: RBXScriptConnection }, private.frozen)
end

return class
