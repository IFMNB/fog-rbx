--!strict
const Cryptography = require("@game/ReplicatedStorage/dependency/Cryptography")
const object = require("@game/ReplicatedStorage/object")
const declare = require("@game/ReplicatedStorage/static/declare")

const class: declare.enumitem = object:new({
	type = "enumitem",
	hashlink = "",
	name = "",
	enum = nil :: never,
})

class:host(function(new: declare.enumitem)
	(new :: any).hashlink = Cryptography.Hashing.Blake3.Digest(buffer.fromstring(new.name))
end)

return class
