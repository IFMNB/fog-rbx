--!strict

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
			self.state = ConnectionState.Dead
			self:notificate(Notification:new({
				call_on = ConnectionState.Dead,
			}))
		end
	end,

	link = function(self: declare.connection, that: declare.face): ()
		const identity = self.identity
		local closure_up : declare.connection
		const lambda = function (notification: declare.notification, ...)
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
	end
})

class:toggle_host(function(new: declare.connection)
	private.face_links[new] = setmetatable({}, private.frozen)

	new:toggle_notice(
		function(
			notification: declare.notification<(notification: declare.notification) -> () | thread | declare.runtimeobject>
		)
			const closeup_f = notification:get_packed()
			const is_runtimeobject = runtimeobject.is(closeup_f, runtimeobject.type)

			new:toggle_notice(function(notification)
				const result = project.run(closeup_f, notification:get_packed())
				if result == 0 then
					if is_runtimeobject then
						(closeup_f :: declare.runtimeobject):notificate(notification)
					else
						project.console_out("unknown calltype in connection, disconnecting")
						new:disconnect()
					end
				elseif result == 4 then 
					new:toggle_notice(function ()
						if is_runtimeobject then
							(closeup_f :: declare.runtimeobject):notificate(notification)
						else
							project.exec(closeup_f, notification:get_packed())
						end
					end, NotificationVariant.Signal, ConnectionMode.Once)
				end
			end, NotificationVariant.Emit, ConnectionMode.Connection)

			new:notificate(Notification:new({
				call_on = NotificationVariant.Initialize,
			}))
		end,
		NotificationVariant.Setup,
		ConnectionMode.Once
	)
end)

do
	private.frozen = table.freeze({ __mode = "ks" })
	private.face_links = setmetatable(
		{} :: setmetatable<{ [declare.connection]: { [declare.face]: declare.connection? } }, typeof(private.frozen)>,
		private.frozen
	)
end

return class
