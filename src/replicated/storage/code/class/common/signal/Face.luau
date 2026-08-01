--!strict

const NotificationVariant = require("@game/ReplicatedStorage/code/enums/notifications/NotificationVariant")
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
		const connection = Connection:new({
			call_on = (self.is(call_on, "enumitem") and call_on or nil) :: declare.enumitem,
		})

		connection:notificate(Notification:new({
			call_on = NotificationVariant.Setup,
			pack = { f },
		}))

		connection:toggle_notice(function(notification)
			self:toggle_notice(connection)
		end, ConnectionState.Dead, ConnectionMode.Once)

		self:toggle_notice(connection, NotificationVariant.Emit, ConnectionMode.Connection)
		self:notificate(Notification:new({ pack = { connection }, call_on = NotificationVariant.ConnectionAdded }))

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
			call_on = NotificationVariant.Setup,
			pack = { f },
		}))

		connection:toggle_notice(function(notification)
			self:toggle_notice(connection)
			self:notificate(Notification:new({ pack = { connection }, call_on = NotificationVariant.ConnectionRemoved }))

            const pos = table.find(private.face_created_connections[self], connection)
            if pos then
                table.remove(private.face_created_connections[self], pos)
            end
		end, ConnectionState.Dead, ConnectionMode.Once)

        table.insert(private.face_created_connections[self], connection)
		self:toggle_notice(connection, NotificationVariant.Emit, ConnectionMode.Once)
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
})

class:toggle_host(function(new: declare.face)
    private.face_created_connections[new] = {}
end)

do
    private.face_created_connections = setmetatable({} :: {[declare.face]: {declare.connection}}, table.freeze {__mode = "ks"})
end

return class
