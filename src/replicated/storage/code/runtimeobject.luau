--!strict

const object = require("./object")
const declare = require("./static/declare")
const namefield = require("./static/namefield")
const project = require("./static/project")

const private = {}
const class: declare.runtimeobject = object:new({
	type = namefield.runtimeobject,
	created_at = DateTime.now(),

	get_notification_event = function (self: declare.runtimeobject): declare.face<declare.notification>
		const Face = (require "../code/class/common/signal/Face" :: declare.face)
		const notifications = private.notification_events[self] or {static = Face:new()}
		private.notification_events[self] = notifications

		return notifications.static
    end,

	toggle_notice = function (self: declare.runtimeobject, f: (notification: declare.notification) -> ()|thread|declare.runtimeobject, call_on: declare.enumitem|declare.runtimeobject?, mode: declare.enumitem?) : ()
		const notice_registry= private.direct_notificatios[self] or {}
		if notice_registry[f] then
			notice_registry[f] = nil
		else
			notice_registry[f] = table.freeze {
				mode = mode,
				call_on = call_on
			}
		end

		private.direct_notificatios[self] = notice_registry
	end,

	notificate = function (self: declare.runtimeobject, notification: declare.notification?) : ()
		private.notificate_notice(self, notification or (require "../code/class/common/Notification" :: declare.notification):new())
		
		const face = private.notification_events[self]
		if face then
			face.static:notificate(notification)
		end
    end,
})
 
class:toggle_host(function(new: declare.runtimeobject)
	new.created_at = DateTime.now()
end)

do
	type direct = {
		mode: declare.enumitem,
		call_on: declare.enumitem
	}
	type notifications = {
		static: declare.face<any>,
		[declare.enumitem]: declare.face<any>?
	}

    private.notification_events = setmetatable({} :: {[declare.runtimeobject]: notifications?}, {__mode='ks'})
	private.direct_notificatios = setmetatable({} :: {[declare.runtimeobject]: {[unknown]: direct?}?}, {__mode='ks'})

	function private.notificate_notice (self: declare.runtimeobject, notification: declare.notification, ...)
		const notice_registry = private.direct_notificatios[self]

		if notice_registry then
			for i, v in table.clone (notice_registry) do
				if v.call_on ~= nil and v.call_on ~= notification.call_on then
					continue
				end
				
				if v.mode == require("./enums/ConnectionMode").Once then
					notice_registry[i] = nil
				end

				const result = project.run(i, notification, ...)
				if result == 4 then
					error "todo signal"
				elseif result == 0 then
					if class.is(i, class.type) then
						(i :: declare.runtimeobject):notificate(notification, ...)
					else
						notice_registry[i] = nil
						project.console_out("unknown call with post 0")
					end
				end
			end
		end
	end
end

return class 