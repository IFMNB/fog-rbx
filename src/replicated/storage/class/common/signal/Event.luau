--!strict

const Observer = require("@game/ReplicatedStorage/class/arch/Observer")
const Connection = require("@game/ReplicatedStorage/class/common/signal/Connection")
const SecurityRNG = require("@game/ReplicatedStorage/class/service/SecurityRNG")
const ConnectionVariant = require("@game/ReplicatedStorage/enums/descriptor/ConnectionVariant")
const DefaultVariant = require("@game/ReplicatedStorage/enums/descriptor/DefaultVariant")
const SetupNotification = require("@game/ReplicatedStorage/enums/notification/SetupNotification")
const declare = require("@game/ReplicatedStorage/static/declare")
const ftype = require("@game/ReplicatedStorage/static/ftype")

const private = {}
const class: declare.event = Observer:new({
	type = "event",
	on = DefaultVariant.Unknown,

	connect = ftype:write(function(self: declare.event, on: declare.enumitem<any>?, f: declare.observer_pack): declare.connection
		const list = private.get_store(self)
		const con = Connection:new({ on = on or self.on})
		con:notificate(SetupNotification.Install, ConnectionVariant.Ever, f)
		con:subscribe(SetupNotification.Disconnected, ConnectionVariant.Once, function ()
			const pos = table.find(list, con)
			if pos then
				table.remove(list, pos)
			end
		end)

		table.insert(list, con)
		return con
	end, "connection", "event", ftype:opt("enumitem"), ftype:uor("observer", declare["function"], declare.thread)),

	once = ftype:write(function(self: declare.event, on: declare.enumitem<any>?, f: declare.observer_pack): declare.connection
		const list = private.get_store(self)
		const con = Connection:new({ on = on or self.on})
		con:notificate(SetupNotification.Install, ConnectionVariant.Once, f)
		con:subscribe(SetupNotification.Disconnected, ConnectionVariant.Once, function ()
			const pos = table.find(list, con)
			if pos then
				table.remove(list, pos)
			end
		end)

		table.insert(list, con)
		return con
	end, "connection", "event", ftype:opt("enumitem"), ftype:uor("observer", declare["function"], declare.thread)),

	wait = ftype:write(function(self: declare.event, on: declare.enumitem?): ...any
		self:once((on or self.on) :: declare.enumitem, coroutine.running())
		return coroutine.yield()
	end, ftype:var(declare.anyt), "event", ftype:opt("enumitem")),

	invoke = ftype:write(function(self: declare.event, call: declare.enumitem, ...: any): ()
		const list = private.get_store(self)

		for _, v in list do
			v:notificate(SetupNotification.Require, call, ...)
		end 
	end, declare["nil"], "event", "enumitem", ftype:var_opt(declare.anyt)),
})

class:host(function(new: declare.event)
	new:add_dependency(setmetatable({}, private.meta), private.key)
end)

do
	type store = {declare.connection}

	private.meta = table.freeze {__mode = "vs"}
	private.key =  SecurityRNG:get_hash_sha256("event_store_code")
	private.get_store = function (of: declare.event)
		return of:get_dependency(private.key) :: store
	end
end

return class
