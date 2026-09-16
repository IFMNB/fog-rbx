--!strict
const Struct = require("@game/ReplicatedStorage/class/core/Struct")
const Vertex = require("@game/ReplicatedStorage/class/struct/geometry/Vertex")

const class: triangle = Struct:new({
	type = "triangle",
	right = Vertex:new(),
	up = Vertex:new(),
	front = Vertex:new(),

	from_vector = function(self: triangle, right: vector?, up: vector?, front: vector?): triangle
		const center: vector = ((right or vector.zero) + (up or vector.zero) + (front or vector.zero)) / 3
		return self:new({
			right = right and Vertex:from_local_point(center, right),
			up = up and Vertex:from_local_point(center, up),
			front = front and Vertex:from_local_point(center, front),
		})
	end,

	get_center = function(self: triangle): vector
		return (self.right.position + self.up.position + self.front.position) / 3
	end,

	get_normal_interpolated = function(self: triangle): vector
		return vector.normalize(self.right.normal + self.up.normal + self.front.normal)
	end,

	get_normal_geometric = function(self: triangle): vector
		return vector.cross((self.up.position - self.right.position), (self.front.position - self.right.position))
	end,

	absolute = function(self: triangle): triangle
		const clone = self:clone({
			right = self.right:absolute(),
			up = self.up:absolute(),
			front = self.front:absolute()
		})

		return clone
	end,

	null = function(self: triangle): triangle
		const clone = self:clone({
			right = self.right:null(),
			up = self.up:null(),
			front = self.front:null()
		})

		return clone
	end,

	substract = function(self: triangle, with: number): triangle
		const clone = self:clone({
			right = self.right:substract(with),
			up = self.up:substract(with),
			front = self.front:substract(with),
		})

		return clone
	end,

	append = function(self: triangle, with: number): triangle
		const clone = self:clone({
			right = self.right:append(with),
			up = self.up:append(with),
			front = self.front:append(with),
		})

		return clone
	end,

	multiple = function(self: triangle, with: number): triangle
		const clone = self:clone({
			right = self.right:multiple(with),
			up = self.up:multiple(with),
			front = self.front:multiple(with),
		})

		return clone
	end,

	divide = function(self: triangle, with: number): triangle
		const clone = self:clone({
			right = self.right:divide(with),
			up = self.up:divide(with),
			front = self.front:divide(with),
		})

		return clone
	end,

	negation = function(self: triangle): triangle
		const clone = self:clone({
			right = self.right:negation(),
			up = self.up:negation(),
			front = self.front:negation(),
		})

		return clone
	end,

	lerp = function(self: triangle, to: triangle, alpha: number): triangle
		const clone = self:clone({
			right = self.right:lerp(to.right, alpha),
			up = self.up:lerp(to.up, alpha),
			front = self.front:lerp(to.front, alpha),
		})

		return clone
	end,


	invert = function(self: triangle): triangle
		const clone = self:clone({
			right = self.right:invert(),
			up = self.up:invert(),
			front = self.front:invert(),
		})

		return clone
	end,

	normalize = function(self: triangle): triangle
		const clone = self:clone({
			right = self.right:normalize(),
			up = self.up:normalize(),
			front = self.front:normalize(),
		})

		return clone
	end,

	infinity = function(self: triangle): triangle
		const clone = self:clone({
			right = self.right:infinity(),
			up = self.up:infinity(),
			front = self.front:infinity(),
		})

		return clone
	end,
})

return class
