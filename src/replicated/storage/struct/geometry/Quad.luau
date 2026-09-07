--!strict
const Record = require("@game/ReplicatedStorage/class/arch/Record")
const dgeometry = require("@game/ReplicatedStorage/static/dgeometry")

const Triangle = require("@game/ReplicatedStorage/struct/geometry/Triangle")

const class: dgeometry.quad = Record:new({
	type = "quad",

	left = Triangle:new(),
	right = Triangle:new(),

	get_center = function(self: dgeometry.quad): vector
		return (self.left:get_center() + self.right:get_center()) / 2
	end,

	get_normal_interpolated = function(self: dgeometry.quad): vector
		return vector.normalize((self.left:get_normal_interpolated() + self.right:get_normal_interpolated()))
	end,

	get_normal_geometric = function(self: dgeometry.quad): vector
		return vector.normalize((self.left:get_normal_geometric() + self.right:get_normal_geometric()))
	end,

	absolute = function(self: dgeometry.quad): dgeometry.quad
		const clone = self:clone()

		clone.right = clone.right:absolute()
		clone.left = clone.left:absolute()

		return clone
	end,

	null = function(self: dgeometry.quad): dgeometry.quad
		const clone = self:clone()

		clone.right = clone.right:null()
		clone.left = clone.left:null()

		return clone
	end,

	substract = function(self: dgeometry.quad, with: number): dgeometry.quad
		const clone = self:clone()

		clone.right = clone.right:substract(with)
		clone.left = clone.left:substract(with)

		return clone
	end,

	append = function(self: dgeometry.quad, with: number): dgeometry.quad
		const clone = self:clone()

		clone.right = clone.right:append(with)
		clone.left = clone.left:append(with)

		return clone
	end,

	multiple = function(self: dgeometry.quad, with: number): dgeometry.quad
		const clone = self:clone()

		clone.right = clone.right:multiple(with)
		clone.left = clone.left:multiple(with)

		return clone
	end,

	divide = function(self: dgeometry.quad, with: number): dgeometry.quad
		const clone = self:clone()

		clone.right = clone.right:divide(with)
		clone.left = clone.left:divide(with)

		return clone
	end,

	invert = function(self: dgeometry.quad): dgeometry.quad
		const clone = self:clone()

		clone.right = clone.right:invert()
		clone.left = clone.left:invert()

		return clone
	end,

	normalize = function(self: dgeometry.quad): dgeometry.quad
		const clone = self:clone()

		clone.right = clone.right:normalize()
		clone.left = clone.left:normalize()

		return clone
	end,

	infinity = function(self: dgeometry.quad): dgeometry.quad
		const clone = self:clone()

		clone.right = clone.right:infinity()
		clone.left = clone.left:infinity()

		return clone
	end,
})

return class
