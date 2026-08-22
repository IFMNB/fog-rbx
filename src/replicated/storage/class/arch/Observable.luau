--!strict
const Package = require("@game/ReplicatedStorage/class/common/notification/Package")
const ConnectionVariant = require("@game/ReplicatedStorage/enums/descriptor/ConnectionVariant")
const Notification = require("@game/ReplicatedStorage/class/common/notification/Notification")
const runtimeobject = require("@game/ReplicatedStorage/runtimeobject")
const declare = require("@game/ReplicatedStorage/static/declare")
const namefield = require("@game/ReplicatedStorage/static/namefield")
const project = require("@game/ReplicatedStorage/static/project")

type pack = declare.observer_pack

const private = {}
const class: declare.observer = runtimeobject:new({
	type = namefield.observer,

	subscribe = function (self: declare.observer, on: declare.enumitem|declare.enumobject, mode: declare.enumitem_connection_variant, ...: pack): () -> ()
		return self:notice(Package:new <<declare.package<declare.enumitem_connection_variant, pack>>> {
			on = assert(self.is(on, namefield.enumitem) and on or self.is(on, namefield.enumobject) and (on :: declare.enumobject):get_enums_list(), "fail to create allocations"),
			pack = {
				Package:new <<(() -> ()) | thread | declare.observer | string>> {
					on = mode,
					pack = {...}
				}
			}
		})
	end,

	notice = function (self: declare.observer, notification: declare.package<{declare.enumitem}|declare.enumitem, declare.package<declare.enumitem_connection_variant, pack>>): () -> ()
		if notification.is(notification.on, namefield.enumitem) then
			notification.on = {notification.on :: declare.enumitem}
		end

		if project.debug then
			if self.is(notification.pack :: unknown?, namefield.package) then
				project.console_out_error("to the place in the notice() .an object has been passed to pack, but the package array is expected")
				return function () end
			end
		end

		for _, v in notification.on :: {declare.enumitem} do
			const target = private.notificatable[self][v]

			if target then
				table.move(notification.pack, 1, #notification.pack, #target + 1, target)
			else
				private.notificatable[self][v] = table.clone (notification.pack)
			end
		end

		return function (): ()
			for _, v in notification.on :: {declare.enumitem} do
				const retarget = private.notificatable[self][v]

				if retarget then
					for _, v in notification.pack do
						const pos = table.find(retarget, v)
						if pos then
							table.remove(retarget, pos)
						end
					end
				end
			end
		end
	end,

	notificate = function (self: declare.observer, notification: declare.enumitem|{declare.enumitem}|declare.notification<declare.enumitem|{declare.enumitem}> ): ()
		if self.is(notification, namefield.enumitem) then
			self:notificate(Notification:new {
				on = notification :: declare.enumitem
			})

			if project.debug and project.debug_show_notifications_path then
				project.console_out ("notification has been normalized from enumitem to notification object")
			end

			return
		elseif self.is(notification, namefield.notification) then
			const notice = notification :: declare.notification<declare.enumitem|{declare.enumitem}>
			if self.is(notice.on, namefield.enumitem) then
				if project.debug and project.debug_show_notifications_path then
					const item = notice.on :: declare.enumitem
					project.console_out (item.name, item.enum and item.enum.name or "*null*", " \n\n| notification has the correct format and will be processed now")
				end
			elseif type(notice.on) == declare.table then
				for _, v in notice.on :: {declare.enumitem} do
					self:notificate(Notification:new {
						on = v
					})
				end
			else
				project.console_out_error ("notification has an incorrect format, aborted")
				return
			end
		elseif type(notification) == declare.table then
			if project.debug and project.debug_show_notifications_path then
				project.console_out ("notification was received as an enumitem table and will now be normalized into a notification object")
			end

			
			for _, v in notification :: {declare.enumitem} do
				self:notificate(Notification:new {
					on = v
				})
			end
			
			return
		end
		
		const needle_notification = notification :: declare.notification<declare.enumitem<any>>
		const target = private.notificatable[self][needle_notification.on]
		
		if target then
			if project.debug and project.debug_show_notifications_path then
				project.console_out ("| notification has been sent, [type] ", self.type)
			end

			const seen: {[unknown]: unknown } = {}

			for i = #target, 1, -1 do
				const t = target[i]

				if seen[t.identity] then
					project.console_out "graph leak detected, skip"
					continue
				else
					seen[t.identity] = t
				end


				if t.on == ConnectionVariant.Never then
					table.remove(target, i)
					continue
				elseif t.on == ConnectionVariant.Once then
					table.remove(target, i)
				elseif t.on == ConnectionVariant.Hold then
					continue
				elseif t.on == ConnectionVariant.Next then
					t.on = ConnectionVariant.Ever
					continue
				elseif t.on == ConnectionVariant.Skip then
					t.on = ConnectionVariant.Once
					continue
				end
				
				for j = #t.pack, 1, -1 do
					const v = t.pack[j]
					const T: string = type(v)
					local removed : boolean


					if seen[tostring(v)] then
						project.console_out "graph leak detected, skip"
						continue
					else
						seen[tostring(v)] = v
					end

					if T == declare["function"] then
						if project.run(v, needle_notification.identity) == 4 then
							project.console_out "cannot run this item now, code 4"
							continue
						end
					elseif T == declare.thread then
						if project.run(v, needle_notification.identity) == 4 then
							project.console_out "cannot run this item now, code 4"
							continue
						end
					elseif T == declare.table then
						if self.is(v, namefield.observer) then
							const observer = v :: declare.observer<declare.enumitem<any>>

							if project.debug then
								const search_in = private.notificatable[observer][needle_notification.on]

								if search_in then
									const pos = table.find(search_in, self :: any)
									if pos then
										project.console_out_error "[!!] recursive graph notifications"
										table.remove(search_in, pos)

										continue
									end
								end
							end

							observer:notificate(needle_notification :: any)
							-- expected enumitem, but got enumitem & {read type: "notification"} & object (?)
							-- needle_notification.on.type == "enumitem" | "object" | string
						end
					elseif T == declare.string then
						if type(self[v]) == declare["function"] then
							if project.run(self[v], self) == 4 then
								project.console_out "cannot run this item now, code 4"
								continue
							end
						else
							removed = private.remove(t.pack, j, removed)
							project.console_out_error "string caller isn't correct, removed"
							continue
						end
					else
						removed = private.remove(t.pack, j, removed)
						
						project.console_out_error "unsupported value"
						continue
					end
				end
			end
		else
			if project.debug and project.debug_show_notifications_path then
				project.console_out("| notification did not arrive to any recipient because there was not a single subscription to it, [type]", self.type)
			end
		end
	end,
})

class:host(function(new: declare.observer)
	private.notificatable[new] = {}
end)

do
	private.meta = table.freeze {__mode = "ks"}

	private.notificatable = setmetatable({} :: {[declare.observer]: {
		[declare.enumitem<any>]: {
			declare.package<declare.enumitem_connection_variant, pack>}?
		}
	}, private.meta)

	private.remove = function <T> (t: {T}, v: number?, r: boolean) : boolean
		return not r and table.remove(t, v) and true or false
	end
end

return class