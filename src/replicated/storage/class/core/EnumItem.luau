--!strict
const Cryptography = require("@game/ReplicatedStorage/dependency/Cryptography")
const object = require("@game/ReplicatedStorage/object")
const project = require("@game/ReplicatedStorage/static/project")

const class: enumitem = object:new({
	type = "enumitem",
	hashlink = "",
	name = "",
	enum = nil :: never,
})

class:host(function(new: enumitem)
	(new :: any).hashlink = Cryptography.Hashing.Blake3.Digest(buffer.fromstring(new.name))

	if project.enums.enumitem_freeze then
		table.freeze(new)
	end
end)

return class
