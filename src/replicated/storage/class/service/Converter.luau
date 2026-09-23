--!strict

const Service = require("@game/ReplicatedStorage/class/core/Service")

const class: converter = Service:new({
	type = "converter",

	to_vector = function(self: converter, ...: Vector3): ...vector
		const result: { vector } = {}

		for _, v in { ... } do
			table.insert(result, vector.create(v.X, v.Y, v.Z))
		end

		return unpack(result)
	end,

	to_vector3 = function(self: converter, ...: vector): ...Vector3
		const result: { Vector3 } = {}

		for _, v in { ... } do
			table.insert(result, Vector3.new(v.x, v.y, v.z))
		end

		return unpack(result)
	end,
})

return class
