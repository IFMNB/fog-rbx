--!strict

const object = require("./object")
const declare = require("./static/declare")

const private = {}
const class: declare.runtimeobject = object:new({
	type = "runtimeobject",

	get_creation_time = function (self: declare.runtimeobject) : DateTime
		return DateTime.now()
	end,

	get_dependencies = function (self: declare.runtimeobject) : {unknown}
		return table.clone(private.stored[self])
	end,

	add_dependency = function (self: declare.runtimeobject, obj: unknown) : ()
		table.insert(private.stored[self], obj)
	end,

	rem_dependency = function (self: declare.runtimeobject, obj: unknown) : ()
		const stored = private.stored[self]
		const pos = table.find(stored, obj)
		if pos then
			table.remove(stored, pos)
		end
	end
})

class:host(function(new: declare.runtimeobject)
	private.time[new] = DateTime.now()
	private.stored[new] = {}
end)

do
	private.meta = table.freeze {__mode = "ks"}
	private.stored = setmetatable({} :: {[declare.runtimeobject]: {unknown}}, private.meta)
	private.time = setmetatable({} :: {[declare.runtimeobject]: DateTime}, private.meta)
end

return class
