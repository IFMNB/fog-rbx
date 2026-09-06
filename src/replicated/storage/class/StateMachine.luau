--!strict
const Observable = require("@game/ReplicatedStorage/class/arch/Observable")
const OperationVariant = require("@game/ReplicatedStorage/enums/descriptor/OperationVariant")
const declare = require("@game/ReplicatedStorage/static/declare")

const private = {}
const class: declare.statemachine = Observable:new({
	type = "statemachine",
	can_only_allowed = false,

	get_last_state = function(self: declare.statemachine): declare.enumitem?
		return private.last[self]
	end,

	get_state = function(self: declare.statemachine, of: declare.enumitem): boolean
		return private.states[self][of] or false
	end,

	set_state = function(self: declare.statemachine, of: declare.enumitem, to: boolean?): ()
		const is_active = private.states[self][of]
		private.states[self][of] = to ~= nil and to or not is_active

		if is_active and not to then
			self:notificate(OperationVariant.Remove)
		elseif is_active == false and to ~= is_active then
			self:notificate(OperationVariant.Change)
		elseif not is_active and to then
			self:notificate(OperationVariant.New)
		end
	end,

	allow_state = function(self: declare.statemachine, of: declare.enumitem, to: boolean?): ()
		private.allowed[self][of] = to
	end,
})

class:host(function(new: declare.statemachine)
	private.states[new] = {}
	private.allowed[new] = {}
end)

do
	type hashlink = string

	private.meta = table.freeze({ __mode = "ks" })
	private.states = setmetatable({} :: { [declare.statemachine]: { [declare.enumitem]: boolean? } }, private.meta)
	private.last = setmetatable({} :: { [declare.statemachine]: declare.enumitem? }, private.meta)
	private.allowed = setmetatable({} :: { [declare.statemachine]: { [declare.enumitem]: boolean? } }, private.meta)
end

return class
