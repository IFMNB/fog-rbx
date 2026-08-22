--!strict
const Observable = require("@game/ReplicatedStorage/class/arch/Observable")
const Notification = require("@game/ReplicatedStorage/class/common/notification/Notification")
const OperationVariant = require("@game/ReplicatedStorage/enums/descriptor/OperationVariant")
const declare = require("@game/ReplicatedStorage/static/declare")
const namefield = require("@game/ReplicatedStorage/static/namefield")
const project = require("@game/ReplicatedStorage/static/project")

const private = {}
const class: declare.reference = Observable:new({
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
				self:notificate(Notification:new({ on = OperationVariant.Remove }))
			end)
		end

		if stored == nil and to == nil then
			self:notificate(Notification:new({ on = OperationVariant.Null }))
		elseif stored == nil and to ~= nil then
			self:notificate(Notification:new({ on = OperationVariant.New }))
		elseif stored ~= to then
			self:notificate(Notification:new({ on = OperationVariant.Change }))
		else
			project.console_out("missmatch reference")
		end
	end,

	is_instance_exists = function(self: declare.reference): boolean
		return typeof(self:get_instance()) == "Instance"
	end,
})

do
	private.frozen = table.freeze({ __mode = "ks" })
	private.stored = setmetatable({} :: { [declare.reference]: Instance }, private.frozen)
	private.connections = setmetatable({} :: { [declare.reference]: RBXScriptConnection }, private.frozen)
end

return class
