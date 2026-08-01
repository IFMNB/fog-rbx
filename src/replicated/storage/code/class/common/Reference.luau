--!strict
const Notification = require("@game/ReplicatedStorage/code/class/common/Notification")
const InstanceNotificationVariant = require("@game/ReplicatedStorage/code/enums/notifications/InstanceNotificationVariant")
const runtimeobject = require("@game/ReplicatedStorage/code/runtimeobject")
const declare = require("@game/ReplicatedStorage/code/static/declare")
const namefield = require("@game/ReplicatedStorage/code/static/namefield")
const project = require("@game/ReplicatedStorage/code/static/project")

const private = {}
const class: declare.reference = runtimeobject:new({
	type = namefield.reference,

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
				self:notificate(Notification:new({ call_on = InstanceNotificationVariant.InstanceDestroyed }))
			end)
		end

		if stored == nil and to == nil then
			self:notificate(Notification:new({ call_on = InstanceNotificationVariant.InstanceNullified }))
		elseif stored == nil and to ~= nil then
			self:notificate(Notification:new({ call_on = InstanceNotificationVariant.InstanceNew }))
		elseif stored ~= to then
			self:notificate(Notification:new({ call_on = InstanceNotificationVariant.InstanceChanged }))
		else
			project.console_out("missmatch reference")
		end
	end,
})

do
	private.frozen = table.freeze({ __mode = "ks" })
	private.stored = setmetatable({} :: { [declare.reference]: Instance }, private.frozen)
	private.connections = setmetatable({} :: { [declare.reference]: RBXScriptConnection }, private.frozen)
end

return class
