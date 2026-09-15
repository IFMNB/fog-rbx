--!strict
const object = require("@game/ReplicatedStorage/object")
const declare = require("@game/ReplicatedStorage/static/declare")
const ftype = require("@game/ReplicatedStorage/static/ftype")

const private = {}
const class = object:new ({
	type = "disposable",

	free = ftype:write(function(self: disposable, deffered: boolean?): ()
		
	end, declare["nil"], "disposable", ftype:opt(declare.boolean)),
})

class:host(function(new: disposable)
	private.objects[new:iden()] = new
end)

do
	private.objects = {} :: { [unknown]: disposable }
end

return class
