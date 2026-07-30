--!strict

const ConnectionMode = require("../../../enums/ConnectionMode")
const ConnectionState = require("../../../enums/ConnectionState")
const NotificationType = require("../../../enums/NotificationType")
const runtimeobject = require("../../../runtimeobject")
const declare = require("../../../static/declare")
const namefield = require("../../../static/namefield")
const Notification = require("../Notification")
const Connection = require("./Connection")

const class: declare.face = runtimeobject:new({
	type = namefield.face,

	connect = function(
		self: declare.face,
		f: ((...any) -> ()) | thread | declare.runtimeobject,
		call_on: declare.enumitem?
	): declare.connection
		const connection = Connection:new({
			call_on = (self.is(call_on, "enumitem") and call_on or nil) :: declare.enumitem,
		})

		connection:notificate(Notification:new({
			call_on = NotificationType.Setup,
			pack = { f },
		}))

		connection:toggle_notice(function(notification)
			self:toggle_notice(connection)
		end, ConnectionState.Dead, ConnectionMode.Once)

		self:toggle_notice(connection, NotificationType.Emit, ConnectionMode.Connection)
		self:notificate(Notification:new({ pack = { connection }, call_on = NotificationType.ConnectionAdded }))

		return connection
	end,

	once = function(
		self: declare.face,
		f: ((...any) -> ()) | thread | declare.runtimeobject,
		call_on: declare.enumitem?
	): declare.connection
		const connection = Connection:new({
			call_on = (self.is(call_on, "enumitem") and call_on or nil) :: declare.enumitem,
		})

		connection:notificate(Notification:new({
			call_on = NotificationType.Setup,
			pack = { f },
		}))

		connection:toggle_notice(function(notification)
			self:toggle_notice(connection)
		end, ConnectionState.Dead, ConnectionMode.Once)

		self:toggle_notice(connection, NotificationType.Emit, ConnectionMode.Once)
		self:notificate(Notification:new({ pack = { connection }, call_on = NotificationType.ConnectionAdded }))

		return connection
	end,

	wait = function(self: declare.face, call_on: declare.enumitem?): ...any
		self:once(coroutine.running(), call_on)
		return coroutine.yield()
	end,
})

return class
