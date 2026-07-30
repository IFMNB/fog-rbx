const Disposable = require("../../Disposable")
const AgentEventType = require("../../enums/AgentEventType")
const RunContextType = require("../../enums/RunContextType")
const object = require("../../object")
const namefield = require("../../static/namefield")
const project = require("../../static/project")
const Event = require("../event/Event")
const Face = require("../face/Face")
const Storage = require("../storage/Storage")
const Upload = require("../upload/Upload")
const Wrapper = require("../wrapper/Wrapper")

const private = {}
const class = {}
setmetatable(class, { __index = Wrapper })

export type class = object.class<typeof(class)>

class.type = namefield.agent
class.bind_type = RunContextType.Parallel

function class.new()
	return Disposable.new(class, true)
end

function class:get_notification_event(): Face.class<number, number, ...unknown>
	return private.notifications:fetch(self, Event.new):get_face()
end

function class:get_order_notification_event(): Face.class<number, string, ...unknown>
	return private.order_notifications:fetch(self, Event.new):get_face()
end

function class:get_send_notification_event(): Face.class<number, ...unknown>
	return private.send_notifications:fetch(self, Event.new):get_face()
end

function class:order(order_notification_type: number, requested: string, ...: unknown)
	if private.order_notifications:is_exists(self) then
		private.order_notifications:fetch(self, Event.new):emit(order_notification_type, requested, ...)
	end
end

function class:notificate(notification_event_type: number, notification_type: unknown, ...: unknown)
	if private.notifications:is_exists(self) then
		private.notifications:fetch(self, Event.new):emit(notification_event_type, notification_type, ...)
	end
end

function class:send(send_notification_type: number, ...: unknown)
	if private.send_notifications:is_exists(self) then
		private.send_notifications:fetch(self, Event.new):emit(send_notification_type, ...)
	end
end

function class:hold(that: Actor?)
	const this = self :: class

	if that and not that:IsA("Actor") then
		project.console_out_error("unexpected instance type, i want @Actor")
		return
	end

	const metadata = private.metadata:fetch(self)
	const send_binded = metadata.send_binded :: RBXScriptConnection?
	const order_binded = metadata.order_binded :: RBXScriptConnection?

	if send_binded then
		send_binded:Disconnect()
		metadata.send_binded = nil
	end

	if order_binded then
		order_binded:Disconnect()
		metadata.order_binded = nil
	end

	if that then
		const bind_func = (
			this.bind_type == RunContextType.Parallel and that.BindToMessageParallel or that.BindToMessage
		)
		metadata.send_binded = bind_func(that, AgentEventType.Send, function(...): ...any
			this:notificate(AgentEventType.Send, ...)
			this:send(...)
		end)
		metadata.order_binded = bind_func(that, AgentEventType.Order, function(...): ...any
			this:notificate(AgentEventType.Send, ...)
			this:order(...)
		end)
	end

	return Wrapper.hold(self, that)
end

function class:get_holder(): Actor?
	return Wrapper.get_holder(self)
end

function class:get_global_wrap(to: Actor)
	if not to:IsA("Actor") then
		project.console_out_error("unexpected instance type, i want @Actor")
	end

	return Wrapper.get_global_wrap(to)
end

private.metadata = Storage.new()
private.notifications = Upload.new()
private.order_notifications = Upload.new()
private.send_notifications = Upload.new()

return table.freeze(class)
