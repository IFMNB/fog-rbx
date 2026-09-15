--!strict
const object = require("@game/ReplicatedStorage/object")
const declare = require("@game/ReplicatedStorage/static/declare")
const ftype = require("@game/ReplicatedStorage/static/ftype")

const private = {}
const class = object:new ({
	type = "disposable",

	free = ftype:write(function(self: disposable, deffered: boolean?): ()
		if deffered then
			task.defer(private.free, self)
		else
			private.free(self)	
		end
	end, declare["nil"], "disposable", ftype:opt(declare.boolean)),

	released = ftype:write(function (self: disposable) : boolean
		return private.objects[self:iden()] == nil
	end, declare.boolean, "disposable"),

	watch = ftype:write(function(self: disposable, ...: (self: disposable) -> ())
		const list = {...}
		const dest = private.watch[self]
		table.move(list, 1, #list, #dest + 1, dest)
	end, declare["nil"], "disposable", declare["function"])
})

class:host(function(new: disposable)
	private.objects[new:iden()] = new
	private.watch[new] = {}
end)

do
	private.meta = table.freeze { __mode = "ks"}
	private.objects = {} :: { [unknown]: disposable }
	private.watch = setmetatable({} :: {[disposable]: {(disposable) -> ()}}, private.meta)
	private.free = function (that: disposable)
		private.objects[that:iden()] = nil

		for _, v in table.clone(private.watch[that]) do
			pcall(v, that)
		end

		table.clear(private.watch[that])
		private.watch[that] = nil
	end
end

return class
