--!strict

const NotificationVariant = require("@game/ReplicatedStorage/code/enums/notifications/NotificationVariant")
const MessageNotificationVariant =
	require("@game/ReplicatedStorage/code/enums/notifications/message/MessageNotificationVariant")
const project = require("@game/ReplicatedStorage/code/static/project")
const ConnectionMode = require("../../../enums/ConnectionMode")
const ConnectionState = require("../../../enums/ConnectionState")
const runtimeobject = require("../../../runtimeobject")
const declare = require("../../../static/declare")
const namefield = require("../../../static/namefield")
const Notification = require("../Notification")
const Connection = require("./Connection")

const private = {}
const class: declare.face = runtimeobject:new({
	type = namefield.face,

	connect = function(
		self: declare.face,
		f: ((...any) -> ()) | thread | declare.runtimeobject,
		call_on: declare.enumitem?
	): declare.connection
		const enumitem_callon = (self.is(call_on, "enumitem") and call_on or NotificationVariant.Any) :: declare.enumitem
		const connection = Connection:new({ call_on = enumitem_callon })
		const lambda = function(notification: declare.notification<declare.notification>)
			const packed_notification = notification:get_packed() :: declare.notification
			if self.is(packed_notification, namefield.notification) then
				connection:notificate(packed_notification)
			else
				project.console_out_error("face got a non-notification object, ignoring")
			end
		end

		connection:notificate(Notification:new({
			call_on = NotificationVariant.Setup,
			pack = { f },
		}))

		connection:toggle_notice(function(notification)
			self:toggle_notice(connection)
			self:toggle_notice(lambda)
		end, ConnectionState.Dead, ConnectionMode.Once)

		table.insert(private.face_created_connections[self], connection)
		self:toggle_notice(lambda, private.main_invoker, ConnectionMode.Connection)
		self:notificate(Notification:new({ pack = { connection }, call_on = NotificationVariant.ConnectionAdded }))

		return connection
	end,

	once = function(
		self: declare.face,
		f: ((...any) -> ()) | thread | declare.runtimeobject,
		call_on: declare.enumitem?
	): declare.connection
		const enumitem_callon = (self.is(call_on, "enumitem") and call_on or NotificationVariant.Any) :: declare.enumitem
		const connection = Connection:new({ call_on = enumitem_callon })
		const lambda = function(notification: declare.notification<declare.notification>)
			const packed_notification = notification:get_packed() :: declare.notification
			if self.is(packed_notification, namefield.notification) then
				connection:notificate(packed_notification)
				connection:disconnect()
			else
				project.console_out_error("face got a non-notification object, ignoring")
			end
		end

		connection:notificate(Notification:new({
			call_on = NotificationVariant.Setup,
			pack = { f },
		}))

		connection:toggle_notice(function(notification)
			self:toggle_notice(connection)
			self:toggle_notice(lambda)
		end, ConnectionState.Dead, ConnectionMode.Once)

		table.insert(private.face_created_connections[self], connection)
		self:toggle_notice(lambda, private.main_invoker, ConnectionMode.Connection)
		self:notificate(Notification:new({ pack = { connection }, call_on = NotificationVariant.ConnectionAdded }))

		return connection
	end,

	wait = function(self: declare.face, call_on: declare.enumitem?): ...any
		self:once(coroutine.running(), call_on)

		return coroutine.yield()
	end,

	link = function(self: declare.face, that: declare.connection): ()
		that:link(self)
		self:notificate(Notification:new({ call_on = NotificationVariant.ConnectionAdded }))
	end,

	unlink = function(self: declare.face, that: declare.connection): ()
		that:unlink(self)
		self:notificate(Notification:new({ call_on = NotificationVariant.ConnectionRemoved }))
	end,

	invoke = function(self: declare.face, notification: declare.notification?): ()
		self:notificate(Notification:new({
			call_on = private.main_invoker,
			pack = { notification or Notification:new({ call_on = NotificationVariant.Any }) },
		}))
	end,
})

class:toggle_host(function(new: declare.face)
	private.face_created_connections[new] = {}
end)

do
	private.main_invoker = MessageNotificationVariant.Invoke
	private.face_created_connections =
		setmetatable({} :: { [declare.face]: { declare.connection } }, table.freeze({ __mode = "ks" }))
end

return class
