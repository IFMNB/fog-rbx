--!strict
const Struct = require("@game/ReplicatedStorage/class/core/Struct")
const declare = require("@game/ReplicatedStorage/static/declare")

const class: result = Struct:new({
	type = "result",
	state = false,
	result = nil,

	unpack = function(self: result): ...unknown
		if type(self.result) == declare.table then
			return unpack(self.result :: { unknown })
		else
			return nil
		end
	end,
})

return class
