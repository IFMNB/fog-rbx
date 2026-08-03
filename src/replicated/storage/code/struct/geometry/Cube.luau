--!strict

const Record = require("@game/ReplicatedStorage/code/class/arch/Record")
const DirectionVariant = require("@game/ReplicatedStorage/code/enums/geometry/DirectionVariant")
const declare = require("@game/ReplicatedStorage/code/static/declare")
const namefield = require("@game/ReplicatedStorage/code/static/namefield")
const project = require("@game/ReplicatedStorage/code/static/project")
const Quad = require("@game/ReplicatedStorage/code/struct/geometry/Quad")
const Triangle = require("@game/ReplicatedStorage/code/struct/geometry/Triangle")
const Vertex = require("@game/ReplicatedStorage/code/struct/geometry/Vertex")

const class : declare.cube = Record:new {
    type = namefield.cube,

    top = Vector3.zero,
    bottom = Vector3.zero,
    left = Vector3.zero,
    right = Vector3.zero,
    front = Vector3.zero,
    back = Vector3.zero,

    get_corners = function (self: declare.cube) : {declare.vertex} 
        const center: Vector3 = self:get_center()
        return {
            Vertex:from_local_point(center, self.top),
            Vertex:from_local_point(center, self.bottom),
            Vertex:from_local_point(center, self.left),
            Vertex:from_local_point(center, self.right),
            Vertex:from_local_point(center, self.front),
            Vertex:from_local_point(center, self.back),
        }
    end,

    get_direction = function (self: declare.cube ,direction: declare.enumitem) : Vector3
        assert(DirectionVariant:is_my_enumitem(direction), "unknown enumitem")

        		const right: Vector3 = this.right - this.center
		const up: Vector3 = this.top - this.center
		const front: Vector3 = this.front - this.center

        --TODO

		const a = {
			this.center + right + up + front,
			this.center + right + up - front,
			this.center + right - up + front,
			this.center + right - up - front,
			this.center - right + up + front,
			this.center - right + up - front,
			this.center - right - up + front,
			this.center - right - up - front,
		}

        if direction == DirectionVariant.pX then
            return self.right
        elseif direction == DirectionVariant.mX then
            return self.left
        elseif direction == DirectionVariant.pY then
            return self.top
        elseif direction == DirectionVariant.mY then
            return self.bottom
        elseif direction == DirectionVariant.pZ then
            return self.front
        elseif direction == DirectionVariant.mZ then
            return self.back
        else
            return error "unknown enumitem"
        end
    end,

    get_quad = function (self: declare.cube ,direction: declare.enumitem) : declare.quad 
        assert(DirectionVariant:is_my_enumitem(direction), "unknown enumitem")

        if direction == DirectionVariant.pX then
            return Quad:new {
                right = Triangle:from_vector3((self.right + self.back + self.bottom) / 3),
                left = Triangle:from_vector3()
            }
        elseif direction == DirectionVariant.mX then
            return Quad:new {
                right = Triangle:from_vector3(),
                left = Triangle:from_vector3()
            }
        elseif direction == DirectionVariant.pY then
            return Quad:new {
                right = Triangle:from_vector3(),
                left = Triangle:from_vector3()
            }
        elseif direction == DirectionVariant.mY then
            return Quad:new {
                right = Triangle:from_vector3(),
                left = Triangle:from_vector3()
            }
        elseif direction == DirectionVariant.pZ then
            return Quad:new {
                right = Triangle:from_vector3(),
                left = Triangle:from_vector3()
            }
        elseif direction == DirectionVariant.mZ then
            return Quad:new {
                right = Triangle:from_vector3(),
                left = Triangle:from_vector3()
            }
        else
            return error "unknown enumitem"
        end
    end,

    to_vector3 = function (self: declare.cube) : Vector3
        return Vector3.new(self.right.Magnitude, self.top.Magnitude, self.front.Magnitude)
    end,

    to_vector2 = function (self: declare.cube) : Vector2
        return Vector2.new(self.right.Magnitude, self.top.Magnitude)
    end,

    to_cframe = function (self: declare.cube) : CFrame
        return CFrame.fromMatrix(self:get_center(), self.right, self.top, self.front)
    end,

    get_center = function (self: declare.cube) : Vector3
        return (self.top + self.bottom + self.left + self.right + self.front + self.back) / 6
    end,

    absolute = function (self: declare.cube) : declare.cube
        const clone = self:clone()
        clone:each<<Vector3>>("Vector3", function(value: Vector3): Vector3
            return value:Abs()
        end)

        return clone
    end,

    null = function (self: declare.cube) : declare.cube
        const clone = self:clone()
        clone:each<<Vector3>>("Vector3", function(value: Vector3): Vector3
            return Vector3.zero
        end)

        return clone
    end,

    substract = function (self: declare.cube, with: number) : declare.cube
        const clone = self:clone()
        clone:each<<Vector3>>("Vector3", function(value: Vector3): Vector3
            return Vector3.new(value.X - with, value.Y - with, value.Z - with)
        end)

        return clone
    end,

    append = function (self: declare.cube, with: number) : declare.cube
        const clone = self:clone()
        clone:each<<Vector3>>("Vector3", function(value: Vector3): Vector3
            return Vector3.new(value.X + with, value.Y + with, value.Z + with)
        end)

        return clone
    end,

    multiple = function (self: declare.cube, with: number) : declare.cube
        const clone = self:clone()
        clone:each<<Vector3>>("Vector3", function(value: Vector3): Vector3
            return value * with
        end)

        return clone
    end,

    divide = function (self: declare.cube, with: number) : declare.cube
        const clone = self:clone()
        clone:each<<Vector3>>("Vector3", function(value: Vector3): Vector3
            return value / with
        end)

        return clone
    end,

    invert = function (self: declare.cube) : declare.cube
        const clone = self:clone()
        clone:each<<Vector3>>("Vector3", function(value: Vector3): Vector3
            return -value
        end)

        return clone
    end,

    normalize = function (self: declare.cube) : declare.cube
        const clone = self:clone()
        clone:each<<Vector3>>("Vector3", function(value: Vector3): Vector3
            return value.Unit
        end)

        return clone
    end,

    infinity = function(self: declare.cube) : declare.cube
        const clone = self:clone()
        clone:each<<Vector3>>("Vector3", function(value: Vector3): Vector3
            return Vector3.new(math.huge, math.huge, math.huge)
        end)

        return clone
    end
}

return class