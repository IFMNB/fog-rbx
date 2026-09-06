--!strict

const Observable = require("@game/ReplicatedStorage/class/arch/Observable")
const Maybe = require("@game/ReplicatedStorage/class/common/gc/Maybe")
const Notification = require("@game/ReplicatedStorage/class/common/notification/Notification")
const Event = require("@game/ReplicatedStorage/class/common/signal/Event")
const ConnectionVariant = require("@game/ReplicatedStorage/enums/descriptor/ConnectionVariant")
const OperationVariant = require("@game/ReplicatedStorage/enums/descriptor/OperationVariant")
const declare = require("@game/ReplicatedStorage/static/declare")
const project = require("@game/ReplicatedStorage/static/project")

const private = {}
const class: declare.value = Observable:new({
	type = "value",

	get_value = function(self: declare.value<any> ): any
		const value: any = private.values[self]
		if value ~= nil then
			self:notificate(Notification)
			return value
		else
			const default = private.defaults[self]
			if default then
				return default
			end
		end

		return nil
	end,

	set_value = function(self: declare.value, value: any, default: boolean?): ()
		const stored: any = private.values[self]

		if default then
			private.defaults[self] = value
		else
			private.values[self] = value
		end

		if stored == nil then
			self:notificate(Notification:new({ on = OperationVariant.New }))
		elseif stored ~= value then
			self:notificate(Notification:new({ on = OperationVariant.Change }))
		elseif value == nil then
			self:notificate(Notification:new({ on = OperationVariant.Remove }))
		else
			project.console_out_error("unexpected value behaviour")
		end
	end,

	on_operation_event = function (self: declare.value) : declare.event<declare.enumitem_operation_variant>
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
	end
})

do
	private.meta = table.freeze { __mode = "ks"}
	private.values = setmetatable({} :: { [declare.value]: any }, private.meta)
	private.defaults = setmetatable({} :: { [declare.value]: any }, private.meta)
	private.maybe = Maybe:new()
end

return class
