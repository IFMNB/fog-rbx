--!strict

const Observer = require("@game/ReplicatedStorage/class/core/Observer")
const OperationVariant = require("@game/ReplicatedStorage/enums/descriptor/OperationVariant")
const declare = require("@game/ReplicatedStorage/static/declare")
const ftype = require("@game/ReplicatedStorage/static/ftype")
const project = require("@game/ReplicatedStorage/static/project")

const private = {}
const class: value = Observer:new({
	type = "value",

	get_value = ftype:write(function(self: value ): any
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

	set_value = ftype:write(function(self: value, value: any, default: boolean?): ()
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
})

do
	private.meta = table.freeze { __mode = "ks"}
	private.values = setmetatable({} :: { [value]: any }, private.meta)
	private.defaults = setmetatable({} :: { [value]: any }, private.meta)
end

return class
