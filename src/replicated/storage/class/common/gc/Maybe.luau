--!strict
const doperate = require("@game/ReplicatedStorage/static/doperate")
const runtimeobject = require("@game/ReplicatedStorage/runtimeobject")
const declare = require("@game/ReplicatedStorage/static/declare")
const ftype = require("@game/ReplicatedStorage/static/ftype")

const private = {}
const class: doperate.maybe = runtimeobject:new({
	type = "maybe",

	extract = ftype:write(function(self: doperate.maybe, it: unknown, make: () -> any): any
		const that = private.stored[self][it] or make()

		if private.stored[self][it] == nil then
			private.stored[self][it] = that
		end

		return that
	end, declare.anyt, "maybe", declare.anyt, declare["function"]),

	exist = ftype:write(function(self: doperate.maybe, it: unknown): boolean
		return private.stored[self][it] ~= nil
	end, declare.boolean, "maybe", declare.anyt),

	erase = ftype:write(function(self: doperate.maybe, it: unknown): ()
		private.stored[self][it] = nil
	end, declare["nil"], "maybe", declare.anyt),
})

class:host(function(new: doperate.maybe)
	private.stored[new] = setmetatable({}, private.frozen)
end)

do
	private.frozen = table.freeze({ __mode = "ks" })
	private.stored = setmetatable(
		{} :: { [doperate.maybe]: setmetatable<{ [unknown]: any }, typeof(private.frozen)> },
		private.frozen
	)
end

return class
