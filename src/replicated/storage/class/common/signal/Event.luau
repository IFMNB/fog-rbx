--!strict

const Observable = require("@game/ReplicatedStorage/class/arch/Observable")
const Notification = require("@game/ReplicatedStorage/class/common/notification/Notification")
const Package = require("@game/ReplicatedStorage/class/common/notification/Package")
const Connection = require("@game/ReplicatedStorage/class/common/signal/Connection")
const ConnectionVariant = require("@game/ReplicatedStorage/enums/descriptor/ConnectionVariant")
const DefaultVariant = require("@game/ReplicatedStorage/enums/descriptor/DefaultVariant")
const ActionNotification = require("@game/ReplicatedStorage/enums/notification/ActionNotification")
const SetupNotification = require("@game/ReplicatedStorage/enums/notification/SetupNotification")
const declare = require("@game/ReplicatedStorage/static/declare")

const private = {}
const class: declare.event = Observable:new({
	type = "event",
	on = DefaultVariant.Unknown,

	connect = function(self: declare.event, on: declare.enumitem<any>?, f: declare.observer_pack): declare.connection
		const new = Connection:new({ on = on or self.on, state = ConnectionVariant.Ever })
		new:notificate(Package:new({ on = SetupNotification.Install, pack = { f } }))
		self:link(new :: declare.connection<any, any>)
		return new
	end,

	once = function(self: declare.event, on: declare.enumitem<any>?, f: declare.observer_pack): declare.connection
		const new = Connection:new({ on = on or self.on, state = ConnectionVariant.Once })
		new:notificate(Package:new({ on = SetupNotification.Install, pack = { f } }))
		self:link(new :: declare.connection<any, any>)
		return new
	end,

	wait = function(self: declare.event, on: declare.enumitem?): ...any
		self:once((on or self.on) :: declare.enumitem, coroutine.running())

		return coroutine.yield()
	end,

	link = function(self: declare.event, that: declare.connection): ()
		const connections = private.connections[self][that.on or self.on] or {}
		table.insert(connections, that)
		self:notificate(Package:new({ on = ActionNotification.Observable, pack = { that } }))
		private.connections[self][that.on] = connections
	end,

	unlink = function(self: declare.event, that: declare.connection): ()
		const connections = private.connections[self][that.on or self.on] or {}
		const pos = table.find(connections, that)

		if pos then
			table.remove(connections, pos)
			self:notificate(Package:new({ on = ActionNotification.Unobservable, pack = { that } }))
		end

		private.connections[self][that.on] = connections
	end,

	invoke = function(
		self: declare.event,
		call: declare.enumitem<any> | { declare.enumitem<any> } | declare.notification<declare.enumitem<any> | { declare.enumitem<any> }>,
		...
	): ()
		local iterate: { declare.enumitem<any> } = {}

		if self.is(call, "enumitem") then
			table.insert(iterate, call :: declare.enumitem<any>)
		elseif self.is(call, "notification") then
			self:invoke((call :: declare.notification<declare.enumitem<any> | { declare.enumitem<any> }>).on, ...)
			return
		elseif type(call) == declare.table then
			const list = call :: { declare.enumitem<any> }
			iterate = list
		end

		for _, v in iterate do
			const connections = private.connections[self][v]
			if connections then
				for i = #connections, 1, -1 do
					const b = connections[i] :: declare.connection<declare.enumitem, ...unknown>

					if b.state == ConnectionVariant.Never then
						continue
					elseif b.state == ConnectionVariant.Once then
						table.remove(connections, i)
					elseif b.state == ConnectionVariant.Hold then
						continue
					elseif b.state == ConnectionVariant.Next then
						b.state = ConnectionVariant.Ever
						continue
					elseif b.state == ConnectionVariant.Skip then
						b.state = ConnectionVariant.Once
						continue
					end

					b:invoke(...)
				end
			end
		end

		self:notificate(Notification:new({
			on = ActionNotification.Emit,
		}))
	end,
})

class:host(function(new: declare.event)
	private.connections[new] = setmetatable({}, private.meta)
end)

do
	type meta = { __mode: "ks" }
	private.meta = table.freeze({ __mode = "ks" }) :: meta

	private.connections = setmetatable(
		{} :: { [declare.event]: setmetatable<{
			[declare.enumitem]: { declare.connection },
		}, meta> },
		private.meta :: meta
	)
end

return class
