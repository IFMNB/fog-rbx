--!strict
const Package = require("@game/ReplicatedStorage/class/common/notification/Package")
const ConnectionVariant = require("@game/ReplicatedStorage/enums/descriptor/ConnectionVariant")
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

	notificate = function (self: declare.observer, notification: declare.notification<declare.enumitem> ): ()
		const target = private.notificatable[self][notification.on]
		
		if target then
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
					project.console_out_error "package with never enumitem, removed"
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
						if project.run(v, notification.identity) == 4 then
							project.console_out "cannot run this item now, code 4"
							continue
						end
					elseif T == declare.thread then
						if project.run(v, notification.identity) == 4 then
							project.console_out "cannot run this item now, code 4"
							continue
						end
					elseif T == declare.table then
						if self.is(v, namefield.observer) then
							const observer = v :: declare.observer

							if project.debug then
								const search_in = private.notificatable[observer][notification.on]

								if search_in then
									const pos = table.find(search_in, self :: any)
									if pos then
										project.console_out_error "[!!] recursive graph notifications"
										table.remove(search_in, pos)

										continue
									end
								end
							end

							observer:notificate(notification)
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