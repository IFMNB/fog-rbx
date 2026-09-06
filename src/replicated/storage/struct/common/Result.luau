--!strict
const Record = require("@game/ReplicatedStorage/class/arch/Record")
const declare = require("@game/ReplicatedStorage/static/declare")

const class: declare.result = Record:new({
	type = "result",
	state = false,
	result = nil,

	unpack = function(self: declare.result): ...unknown
		if type(self.result) == declare.table then
			return unpack(self.result :: { unknown })
		else
			return nil
		end
	end,
})

return class
