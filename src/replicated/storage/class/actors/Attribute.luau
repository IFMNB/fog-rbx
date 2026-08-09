--!strict

const ConnectionMode = require("../../enums/ConnectionMode")
const InstanceNotificationVariant = require("@game/ReplicatedStorage/enums/notifications/InstanceNotificationVariant")
const NotificationType = require("@game/ReplicatedStorage/enums/notifications/NotificationVariant")
const ValueNotificationVariant = require("@game/ReplicatedStorage/enums/notifications/ValueNotificationVariant")
const OperationalVariant = require("@game/ReplicatedStorage/enums/required/OperationalVariant")
const declare = require("../../static/declare")
const namefield = require("../../static/namefield")
const project = require("../../static/project")
const Disposable = require("../arch/Disposable")
const Reference = require("../common/Reference")
const Value = require("../common/Value")

const private = {}
const class: declare.attribute = Disposable:new({
	type = namefield.attribute,
	name = namefield.attribute,

	get_reference = function(self: declare.attribute): declare.reference<any>
		return private.references[self]
	end,

	get_params = function(self: declare.attribute): declare.value
		return private.params[self]
	end,

	get_current_value = function(self: declare.attribute): any?
		const instance = self:get_reference():get_instance()

		if instance then
			const value = instance:GetAttribute(self.name)
			if typeof(value) == self:get_params():get_value() then
				return value
			else
				return nil
			end
		else
			return nil
		end
	end,
})

class:toggle_host(function(new: declare.attribute)
	const param: declare.value<any> = Value:new()
	const refer: declare.reference<any> = Reference:new()

	private.references[new] = refer
	private.params[new] = param

	const update_value_attribute = function()
		const that = refer:get_instance() :: Instance

		if that then
			-- IDC

			local ok, err = pcall(function()
				that:SetAttribute(new.name, param:get_value())
			end)

			if not ok then
				project.console_out_error("attribute unexpected valuetype", err)
				if new:get_state(OperationalVariant.Working) then
					new:toggle_state(OperationalVariant.Working)
				end

				if not new:get_state(OperationalVariant.Paused) then
					new:toggle_state(OperationalVariant.Paused)
				end
			else
				if not new:get_state(OperationalVariant.Working) then
					new:toggle_state(OperationalVariant.Working)
				end

				if new:get_state(OperationalVariant.Paused) then
					new:toggle_state(OperationalVariant.Paused)
				end
			end
		end
	end

	const toggle_listeners = function()
		refer:toggle_notice(update_value_attribute, InstanceNotificationVariant.Newwie, ConnectionMode.Ever)
		refer:toggle_notice(update_value_attribute, InstanceNotificationVariant.Changed, ConnectionMode.Ever)
		param:toggle_notice(update_value_attribute, ValueNotificationVariant.ValueChanged, ConnectionMode.Ever)
		param:toggle_notice(update_value_attribute, ValueNotificationVariant.ValueNew, ConnectionMode.Ever)
		param:toggle_notice(update_value_attribute, ValueNotificationVariant.ValueRemoved, ConnectionMode.Ever)
	end

	toggle_listeners()
	new:toggle_notice(function()
		toggle_listeners()
		refer:set_instance(nil)
		param:set_value(nil)
	end, NotificationType.PreRelease, ConnectionMode.Once)
end)

do
	private.frozen = table.freeze({ __mode = "ks" })
	private.params = setmetatable({} :: { [declare.attribute]: declare.value }, private.frozen)
	private.references = setmetatable({} :: { [declare.attribute]: declare.reference }, private.frozen)
end

return class
