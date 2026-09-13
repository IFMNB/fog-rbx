--!strict

const Observer = require("@game/ReplicatedStorage/class/arch/Observer")
const Maybe = require("@game/ReplicatedStorage/class/common/gc/Maybe")
const Event = require("@game/ReplicatedStorage/class/common/signal/Event")
const ConnectionVariant = require("@game/ReplicatedStorage/enums/descriptor/ConnectionVariant")
const OperationVariant = require("@game/ReplicatedStorage/enums/descriptor/OperationVariant")
const declare = require("@game/ReplicatedStorage/static/declare")
const ftype = require("@game/ReplicatedStorage/static/ftype")
const project = require("@game/ReplicatedStorage/static/project")

const private = {}
const class: declare.value = Observer:new({
	type = "value",

	get_value = ftype:write(function(self: declare.value<any> ): any
		const value: any = private.values[self]
		if value ~= nil then
			return value
		else
			const default = private.defaults[self]
			if default then
				return default
			end
		end

		return nil
	end, declare.anyt, "value"),

	set_value = ftype:write(function(self: declare.value, value: any, default: boolean?): ()
		const stored: any = private.values[self]

		if default then
			private.defaults[self] = value
		else
			private.values[self] = value
		end

		if stored == nil then
			self:notificate(OperationVariant.New )
		elseif stored ~= value then
			self:notificate(OperationVariant.Change )
		elseif value == nil then
			self:notificate(OperationVariant.Remove )
		else
			project.console_out_error("unexpected value behaviour")
		end
	end, declare["nil"], "value", declare.anyt, ftype:opt(declare.boolean)),

	on_operation_event = ftype:write(function (self: declare.value) : declare.event<declare.enumitem_operation_variant>
		return private.maybe:extract(self, function()
			const new = Event:new({
				on = OperationVariant.New
			}) :: declare.event<declare.enumitem_operation_variant>

			self:subscribe(OperationVariant, ConnectionVariant.Ever, function (identity)
				const notice = new.require <<declare.notification<declare.enumitem_operation_variant>>>(identity, "notification")
				new:invoke(notice.on)
			end)

			return new
		end)
	end, "event", "value")
})

do
	private.meta = table.freeze { __mode = "ks"}
	private.values = setmetatable({} :: { [declare.value]: any }, private.meta)
	private.defaults = setmetatable({} :: { [declare.value]: any }, private.meta)
	private.maybe = Maybe:new()
end

return class
