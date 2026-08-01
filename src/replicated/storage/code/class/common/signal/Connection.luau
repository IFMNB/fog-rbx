--!strict

const ConnectionStateVariants = require("@game/ReplicatedStorage/code/enums/notifications/ConnectionStateVariants")
const NotificationVariant = require("@game/ReplicatedStorage/code/enums/notifications/NotificationVariant")
const ConnectionMode = require("../../../enums/ConnectionMode")
const ConnectionState = require("../../../enums/ConnectionState")
const runtimeobject = require("../../../runtimeobject")
const declare = require("../../../static/declare")
const namefield = require("../../../static/namefield")
const project = require("../../../static/project")
const EnumObject = require("../../arch/EnumObject")
const Notification = require("../Notification")

const private = {}
const class: declare.connection = runtimeobject:new({
	type = namefield.connection,
	state = EnumObject.Unknown,
	call_on = EnumObject.Unknown,

	disconnect = function(self: declare.connection): ()
		if self.state ~= ConnectionState.Dead then
			project.console_out("disconnecting connection")

			self.state = ConnectionState.Dead
			self:notificate(Notification:new({
				call_on = ConnectionState.Dead,
			}))
		end
	end,

	link = function(self: declare.connection, that: declare.face): ()
		const identity = self.identity
		local closure_up: declare.connection
		const lambda = function(notification: declare.notification, ...)
			const self_connection = that.require(identity) :: declare.connection?
			if self_connection then
				self_connection:notificate(notification)
			else
				closure_up:disconnect()
			end
		end

		closure_up = that:get_notification_event():connect(lambda, NotificationVariant.Emit)
		private.face_links[self][that] = closure_up
	end,

	unlink = function(self: declare.connection, that: declare.face): ()
		const connection = private.face_links[self][that] :: declare.connection?
		if connection then
			connection:disconnect()
			private.face_links[self][that] = nil
		end
	end,

	reload = function(self: declare.connection): ()
		self:notificate(Notification:new({ call_on = ConnectionStateVariants.ChangingCallOn }))
	end,
})

class:toggle_host(function(new: declare.connection)
	private.face_links[new] = setmetatable({}, private.frozen)

	new:toggle_notice(function(notification)
		const closeup_f = notification:get_packed()
		const is_runtimeobject = runtimeobject.is(closeup_f, runtimeobject.type)
		const main_f = private.get_main_f(new, closeup_f, is_runtimeobject)
		const regenerate = private.get_regenerator(new, main_f)

		new:toggle_notice(main_f, new.call_on, ConnectionMode.Connection)
		new:toggle_notice(regenerate, ConnectionStateVariants.ChangingCallOn, ConnectionMode.Connection)
		new:notificate(Notification:new({ call_on = NotificationVariant.Initialize }))
	end, NotificationVariant.Setup, ConnectionMode.Once)

	project.console_out("connection waiting for setup notification")
end)

do
	private.frozen = table.freeze({ __mode = "ks" })
	private.face_links = setmetatable(
		{} :: setmetatable<{ [declare.connection]: { [declare.face]: declare.connection? } }, typeof(private.frozen)>,
		private.frozen
	)

	function private.get_main_f(new: declare.connection, closeup_f: any, is_runtimeobject: boolean)
		const lambda = function(notification)
			const result = project.run(closeup_f, notification:get_packed())
			if result == 0 then
				if is_runtimeobject then
					const closeup_obj = closeup_f :: declare.runtimeobject

					project.console_out(string.format("%q %s", closeup_obj.type, "got a notification"))
					closeup_obj:notificate(notification)
				else
					project.console_out_error("unknown calltype in connection, disconnecting")
					new:disconnect()
				end
			elseif result == 4 then
				project.console_out("calltype is a Signal, waiting for it to be called")

				new:toggle_notice(function()
					if is_runtimeobject then
						(closeup_f :: declare.runtimeobject):notificate(notification)
					else
						project.exec(closeup_f, notification:get_packed())
					end
				end, NotificationVariant.Signal, ConnectionMode.Once)
			end
		end

		return lambda
	end

	function private.get_regenerator(new: declare.connection, main_f)
		return function()
			for i = 1, 2 do
				new:toggle_notice(main_f, new.call_on, ConnectionMode.Connection)
			end

			new:notificate(Notification:new({ call_on = ConnectionStateVariants.Normal }))
		end
	end
end

return class
