--!strict
const declare = require("@game/ReplicatedStorage/static/declare")
const runtimeobject = require("@game/ReplicatedStorage/runtimeobject")

const private = {}
const class: declare.maybe = runtimeobject:new({
	type = "maybe",

	extract = function(self: declare.maybe, it: unknown, make: () -> any): any
		const that = private.stored[self][it] or make()

		if private.stored[self][it] == nil then
			private.stored[self][it] = that
		end

		return that
	end,

	exist = function(self: declare.maybe, it: unknown): boolean
		return private.stored[self][it] ~= nil
	end,

	erase = function(self: declare.maybe, it: unknown): ()
		private.stored[self][it] = nil
	end,
})

class:host(function(new: declare.maybe)
	private.stored[new] = setmetatable({}, private.frozen)
end)

do
	private.frozen = table.freeze({ __mode = "ks" })
	private.stored = setmetatable(
		{} :: { [declare.maybe]: setmetatable<{ [unknown]: any }, typeof(private.frozen)> },
		private.frozen
	)
end

return class
