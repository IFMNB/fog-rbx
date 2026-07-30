--!strict

const ConnectionMode = require("../../../enums/ConnectionMode")
const ConnectionState = require("../../../enums/ConnectionState")
const NotificationType = require("../../../enums/NotificationType")
const runtimeobject = require("../../../runtimeobject")
const declare = require("../../../static/declare")
const namefield = require("../../../static/namefield")
const project = require("../../../static/project")
const EnumObject = require("../../arch/EnumObject")
const Notification = require("../Notification")

const class : declare.connection = runtimeobject:new({
	type = namefield.connection,
	state = EnumObject.Unknown,
	call_on = EnumObject.Unknown,

	disconnect = function (self: declare.connection) : ()
		if self.state ~= ConnectionState.Dead then
			self.state = ConnectionState.Dead
			self:notificate(Notification:new({
				call_on = ConnectionState.Dead
			}))
		end
	end
})

class:toggle_host(function(new: declare.connection)
	new:toggle_notice(function (notification: declare.notification<(notification: declare.notification) -> ()|thread|declare.runtimeobject>)
		const closeup_f = notification:get_packed()
		const is_runtimeobject = runtimeobject.is(closeup_f, runtimeobject.type)

		new:toggle_notice(function (notification)
			const result = project.run(closeup_f, notification:get_packed())
			if result == 0 then
				if is_runtimeobject then
					(closeup_f :: declare.runtimeobject):notificate(notification)
				else
					project.console_out "unknown calltype in connection, disconnecting"
					new:disconnect()
				end
			elseif result == 4 then -- TODO
				error "todo signal"
			end
		end, NotificationType.Emit, ConnectionMode.Connection)

		new:notificate(Notification:new({
			call_on = NotificationType.Initialize
		}))
	end, NotificationType.Setup, ConnectionMode.Once)
end)

return class