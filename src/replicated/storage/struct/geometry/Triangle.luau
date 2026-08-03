--!strict
const Record = require("@game/ReplicatedStorage/class/arch/Record")
const declare = require("@game/ReplicatedStorage/static/declare")
const namefield = require("@game/ReplicatedStorage/static/namefield")
const Vertex = require("@game/ReplicatedStorage/struct/geometry/Vertex")

const class: declare.triangle = Record:new({
	type = namefield.triangle,
	right = Vertex:new(),
	up = Vertex:new(),
	front = Vertex:new(),

	from_vector3 = function(self: declare.triangle, right: Vector3?, up: Vector3?, front: Vector3?): declare.triangle
		const center: Vector3 = ((right or Vector3.zero) + (up or Vector3.zero) + (front or Vector3.zero)) / 3
		return self:new({
			right = right and Vertex:from_local_point(center, right),
			up = up and Vertex:from_local_point(center, up),
			front = front and Vertex:from_local_point(center, front),
		})
	end,

	get_center = function(self: declare.triangle): Vector3
		return (self.right.position + self.up.position + self.front.position) / 3
	end,

	get_normal_interpolated = function(self: declare.triangle): Vector3
		return (self.right.normal + self.up.normal + self.front.normal).Unit
	end,

	get_normal_geometric = function(self: declare.triangle): Vector3
		return (self.up.position - self.right.position):Cross(self.front.position - self.right.position).Unit
	end,

	absolute = function(self: declare.triangle): declare.triangle
		const clone = self:clone()

		clone.right = clone.right:absolute()
		clone.up = clone.up:absolute()
		clone.front = clone.front:absolute()

		return clone
	end,

	null = function(self: declare.triangle): declare.triangle
		const clone = self:clone()

		clone.right = clone.right:null()
		clone.up = clone.up:null()
		clone.front = clone.front:null()

		return clone
	end,

	substract = function(self: declare.triangle, with: number): declare.triangle
		const clone = self:clone()

		clone.right = clone.right:substract(with)
		clone.up = clone.up:substract(with)
		clone.front = clone.front:substract(with)

		return clone
	end,

	append = function(self: declare.triangle, with: number): declare.triangle
		const clone = self:clone()

		clone.right = clone.right:append(with)
		clone.up = clone.up:append(with)
		clone.front = clone.front:append(with)

		return clone
	end,

	multiple = function(self: declare.triangle, with: number): declare.triangle
		const clone = self:clone()

		clone.right = clone.right:multiple(with)
		clone.up = clone.up:multiple(with)
		clone.front = clone.front:multiple(with)

		return clone
	end,

	divide = function(self: declare.triangle, with: number): declare.triangle
		const clone = self:clone()

		clone.right = clone.right:divide(with)
		clone.up = clone.up:divide(with)
		clone.front = clone.front:divide(with)

		return clone
	end,

	invert = function(self: declare.triangle): declare.triangle
		const clone = self:clone()

		clone.right = clone.right:invert()
		clone.up = clone.up:invert()
		clone.front = clone.front:invert()

		return clone
	end,

	normalize = function(self: declare.triangle): declare.triangle
		const clone = self:clone()

		clone.right = clone.right:normalize()
		clone.up = clone.up:normalize()
		clone.front = clone.front:normalize()

		return clone
	end,

	infinity = function(self: declare.triangle): declare.triangle
		const clone = self:clone()

		clone.right = clone.right:infinity()
		clone.up = clone.up:infinity()
		clone.front = clone.front:infinity()

		return clone
	end,
})

return class
