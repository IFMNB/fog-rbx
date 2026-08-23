--!strict
const Observable = require("@game/ReplicatedStorage/class/arch/Observable")
const Notification = require("@game/ReplicatedStorage/class/common/notification/Notification")
const Package = require("@game/ReplicatedStorage/class/common/notification/Package")
const ConnectionVariant = require("@game/ReplicatedStorage/enums/descriptor/ConnectionVariant")
const DefaultVariant = require("@game/ReplicatedStorage/enums/descriptor/DefaultVariant")
const ActionNotification = require("@game/ReplicatedStorage/enums/notification/ActionNotification")
const SetupNotification = require("@game/ReplicatedStorage/enums/notification/SetupNotification")
const declare = require("@game/ReplicatedStorage/static/declare")
const namefield = require("@game/ReplicatedStorage/static/namefield")

const class : declare.connection = Observable:new {
	type = namefield.connection,
	state = ConnectionVariant.Never,
	on = DefaultVariant.Unknown,
	count = math.huge,

	disconnect = function (self: declare.connection)
		self.state = ConnectionVariant.Never
		self:notificate(Notification:new {on = self.state})
	end,

	invoke = function (self: declare.connection, ...)
		if self.state ~= ConnectionVariant.Never then
			self:notificate(Package:new {on = ActionNotification.Emit, pack = {...}})
		end
	end,

	link = function (self: declare.connection, that: declare.event)
		return that:link(self :: declare.connection<any,any>)
	end,

	unlink = function (self: declare.connection, that: declare.event)
		return that:unlink(self :: declare.connection<any,any>)
	end
}

class:host(function(new: declare.connection)
	new:subscribe(SetupNotification.Install, ConnectionVariant.Once, function (identity: declare.object_identity)
		const package = new.require <<declare.package<declare.enumitem_setup_notification, unknown>>>(identity, namefield.package)
		const closure = assert(package.pack[1], "unknown value") :: (...unknown) -> ()
		
		new:subscribe(ActionNotification.Emit, ConnectionVariant.Ever, function (identity: declare.object_identity)
			const package = new.require <<declare.package<declare.enumitem_action_notification, unknown>>>(identity, namefield.package)

			closure(unpack(package.pack))
			new.count -= 1

			if new.count <= 0 then
				new:disconnect()
			end
		end)

		new:notificate(Notification:new {on = SetupNotification.Installed})
		new:notificate(Notification:new {on = new.state})
	end)
end)

return class