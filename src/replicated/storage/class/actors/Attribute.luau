--!strict
const Disposable = require("@game/ReplicatedStorage/class/arch/Disposable")
const Reference = require("@game/ReplicatedStorage/class/common/Reference")
const Value = require("@game/ReplicatedStorage/class/common/Value")
const ConnectionVariant = require("@game/ReplicatedStorage/enums/descriptor/ConnectionVariant")
const OperationVariant = require("@game/ReplicatedStorage/enums/descriptor/OperationVariant")
const DisposableNotification = require("@game/ReplicatedStorage/enums/notification/DisposableNotification")
const declare = require("@game/ReplicatedStorage/static/declare")
const namefield = require("@game/ReplicatedStorage/static/namefield")
const project = require("@game/ReplicatedStorage/static/project")

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

class:host(function(new: declare.attribute)
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
			end
		end
	end

	const resource: (...any) -> () = refer:subscribe(OperationVariant, ConnectionVariant.Ever, update_value_attribute)
	new:subscribe(DisposableNotification.OnRelease, ConnectionVariant.Once, resource)
end)

do
	private.frozen = table.freeze({ __mode = "ks" })
	private.params = setmetatable({} :: { [declare.attribute]: declare.value }, private.frozen)
	private.references = setmetatable({} :: { [declare.attribute]: declare.reference }, private.frozen)
end

return class
