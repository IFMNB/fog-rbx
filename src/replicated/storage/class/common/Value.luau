--!strict

const ValueNotificationVariant = require("@game/ReplicatedStorage/enums/notifications/ValueNotificationVariant")
const runtimeobject = require("../../runtimeobject")
const declare = require("../../static/declare")
const namefield = require("../../static/namefield")
const project = require("../../static/project")
const Notification = require("./Notification")

const private = {}
const class: declare.value = runtimeobject:new({
	type = namefield.value,

	get_value = function(self: declare.value): any
		const value: any = private.values[self]
		if value ~= nil then
			self:notificate(Notification:new({ call_on = ValueNotificationVariant.ValueGet, pack = { value } }))
			return value
		end

		return self:get_value_default()
	end,

	set_value = function(self: declare.value, value: any): ()
		const stored: any = private.values[self]
		private.values[self] = value

		if stored == nil then
			self:notificate(Notification:new({ call_on = ValueNotificationVariant.ValueNew }))
		elseif stored ~= value then
			self:notificate(Notification:new({ call_on = ValueNotificationVariant.ValueChanged }))
		elseif value == nil then
			self:notificate(Notification:new({ call_on = ValueNotificationVariant.ValueRemoved }))
		else
			project.console_out_error("unexpected value behaviour")
		end
	end,

	get_value_default = function(self: declare.value): any
		const value: any = private.defaults[self]
		self:notificate(Notification:new({ call_on = ValueNotificationVariant.LazyValueGet, pack = { value } }))
		return value
	end,

	set_value_default = function(self: declare.value, value: any): ()
		const stored: any = private.defaults[self]
		private.defaults[self] = value

		if stored == nil then
			self:notificate(Notification:new({ call_on = ValueNotificationVariant.LazyValueNew }))
		elseif stored ~= value then
			self:notificate(Notification:new({ call_on = ValueNotificationVariant.LazyValueChanged }))
		elseif value == nil then
			self:notificate(Notification:new({ call_on = ValueNotificationVariant.LazyValueRemoved }))
		else
			project.console_out_error("unexpected value behaviour")
		end
	end,
})

do
	private.values = setmetatable({} :: { [declare.value]: any }, { __mode = "ks" })
	private.defaults = setmetatable({} :: { [declare.value]: any }, { __mode = "ks" })
end

return class
