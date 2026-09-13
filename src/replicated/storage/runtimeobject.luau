--!strict

const object = require("./object")
const declare = require("./static/declare")
const project = require "./static/project"
const ftype = require "./static/ftype"

const private = {}
const class: declare.runtimeobject = object:new({
	type = "runtimeobject",

	get_creation_time = ftype:write(function (self: declare.runtimeobject) : DateTime
		return private.time[self]
	end, declare.roblox.DateTime, "runtimeobject"),

	get_dependencies = ftype:write(function (self: declare.runtimeobject) : {[number|unknown]: unknown}
		return table.clone(private.stored[self])
	end, declare.table, "runtimeobject"),

	get_dependency = ftype:write(function (self: declare.runtimeobject, label: unknown) : unknown
		return private.stored[self][label]
	end, declare.anyt, "runtimeobject", declare.anyt),

	add_dependency = ftype:write(function (self: declare.runtimeobject, obj: unknown, label: unknown?) : ()
		const stored: any = private.stored[self]
		
		if label then
			if stored[label] == nil then
				stored[label] = obj
			else
				if project.debug then
					project.console_out "attempt to add existed dependency"
				end
			end
		else
			if not table.find(stored, obj) then
				table.insert(stored, obj)
			else
				if project.debug then
					project.console_out "attempt to add existed dependency"
				end
			end
		end
	end, declare["nil"], "runtimeobject", declare.anyt, ftype:opt(declare.anyt)),

	rem_dependency = ftype:write(function (self: declare.runtimeobject, obj: unknown, label: unknown?) : ()
		const stored: any = private.stored[self]

		if label == nil then
			const pos = table.find(stored, obj)
			if pos then
				table.remove(stored, pos)
			end
		else
			stored[label] = nil
		end
	end, declare["nil"], "runtimeobject", declare.anyt, ftype:opt(declare.anyt))
})

class:host(function(new: declare.runtimeobject)
	private.time[new] = DateTime.now()
	private.stored[new] = {}
end)

do
	private.meta = table.freeze {__mode = "ks"}
	private.stored = setmetatable({} :: {[declare.runtimeobject]: {[number|unknown]: unknown}}, private.meta)
	private.time = setmetatable({} :: {[declare.runtimeobject]: DateTime}, private.meta)
end

return class
