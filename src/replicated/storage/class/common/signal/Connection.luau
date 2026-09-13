--!strict
const EnumItem = require("@game/ReplicatedStorage/class/arch/EnumItem")
const Observer = require("@game/ReplicatedStorage/class/arch/Observer")
const Pointer = require("@game/ReplicatedStorage/class/common/variable/Pointer")
const SecurityRNG = require("@game/ReplicatedStorage/class/service/SecurityRNG")
const ConnectionVariant = require("@game/ReplicatedStorage/enums/descriptor/ConnectionVariant")
const DefaultVariant = require("@game/ReplicatedStorage/enums/descriptor/DefaultVariant")
const ObserverSettingVariant = require("@game/ReplicatedStorage/enums/descriptor/ObserverSettingVariant")
const SetupNotification = require("@game/ReplicatedStorage/enums/notification/SetupNotification")
const declare = require("@game/ReplicatedStorage/static/declare")
const project = require("@game/ReplicatedStorage/static/project")
const ftype = require("@game/ReplicatedStorage/static/ftype")

--[[

	setup

	connection = new connection
	pointer = connection:subscribe (SetupNotification.Install, mode, func|thread|observer)
	connection:notificate (SetupNotification.Installed)

	call

	connection:invoke(...) or connection:notificate(SetupNotification.Require, enumitem, ...)
]]

const private = {}
const class : declare.connection = Observer:new {
	type = "connection",
	on = DefaultVariant.Unknown,
	count = 1,

	get_mode = ftype:write(function (self: declare.connection) : declare.enumitem_connection_variant
		if self:is_connected() then
			const cvar = self:get_mode_of(self:get_dependency(private.key) :: declare.pointer)
			return cvar
		else
			return ConnectionVariant.Never
		end
	end, "enumitem", "connection"),

	set_mode = ftype:write(function (self: declare.connection, mode: declare.enumitem_connection_variant) : ()
		if not self:is_connected() then return end
		const pointer = self:get_dependency(private.key) :: declare.pointer

		if mode == ConnectionVariant.Ever then
			self:subscription(ObserverSettingVariant.ChangeModeToEver, pointer)
		elseif mode == ConnectionVariant.Once then
				self:subscription(ObserverSettingVariant.ChangeModeToOnce, pointer)
		elseif mode == ConnectionVariant.Skip then
			self:subscription(ObserverSettingVariant.ChangeModeToSkip, pointer)
		elseif mode == ConnectionVariant.Next then
			self:subscription(ObserverSettingVariant.ChangeModeToNext, pointer)
		else
			project.console_out_error "unsupported mode variant"
		end
	end, declare["nil"], "connection", "enumitem"),

	is_connected = ftype:write(function (self: declare.connection): boolean
		return self:get_dependency(private.key) ~= nil
	end, declare.boolean, "connection"),

	disconnect = ftype:write(function (self: declare.connection) : ()
		const func = self:get_dependency(private.key)
		if self.is(func, Pointer.type) then
			self:unsubscribe(func :: declare.pointer)
		end

		self:notificate(SetupNotification.Disconnected)
	end, declare["nil"], "connection"),

	invoke = ftype:write(function (self: declare.connection, ...) : ()
		for i = 1, self.count do
			self:notificate(private.special, ...)
		end
	end, declare["nil"], "connection", ftype:var(declare.anyt)),
}

class:host(function(new: declare.connection)
	local pointer : declare.pointer
	pointer = new:subscribe(SetupNotification.Install, ConnectionVariant.Ever, function (mode: declare.enumitem, func: declare.observer_pack<any>)
		if not project.assert(class.is(mode, EnumItem.type), "unexpected object", true) then return end
		if not project.assert(ConnectionVariant:is_my_enumitem(mode), "unexpected move variant", true) then return end
		
		new:add_dependency(new:subscribe(private.special, mode :: declare.enumitem_connection_variant, func), private.key)
		new:subscribe(SetupNotification.Require, ConnectionVariant.Ever, function (item, ...)
			if not project.assert(class.is(item, EnumItem.type), "unknown enumitem") then return end

			if item == new.on then
				new:invoke(...)
			end
		end)

		new:notificate(SetupNotification.Installed)
		new:unsubscribe(pointer)
	end)
end)

do
	private.special = EnumItem:new({name = "InternalConnectionCallItem"})
	private.key =  SecurityRNG:get_hash_sha256("connection_func_code")
end

return class