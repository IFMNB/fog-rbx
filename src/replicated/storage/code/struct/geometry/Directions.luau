--!strict
const Record = require("@game/ReplicatedStorage/code/class/arch/Record")
const declare = require("@game/ReplicatedStorage/code/static/declare")
const namefield = require("@game/ReplicatedStorage/code/static/namefield")

const class : declare.directions = Record:new {
    type = namefield.directions,

    right = Vector3.zero,
    up = Vector3.zero,
    front = Vector3.zero,

    to_cframe = function (self: declare.directions) : CFrame
        return CFrame.fromMatrix(Vector3.zero, self.right, self.up, self.front)
    end,

    to_vector3 = function (self: declare.directions) : Vector3
        return Vector3.new(self.right.Magnitude, self.up.Magnitude, self.front.Magnitude)
    end,

    to_vector2 = function (self: declare.directions) : Vector2
        return Vector2.new(self.right.Magnitude, self.up.Magnitude)
    end,

    absolute = function (self: declare.directions) : declare.directions
        const clone = self:clone()
        clone:each<<Vector3>>("Vector3", function(value: Vector3): Vector3
            return value:Abs()
        end)

        return clone
    end,

    null = function (self: declare.directions) : declare.directions
        const clone = self:clone()
        clone:each<<Vector3>>("Vector3", function(value: Vector3): Vector3
            return Vector3.zero
        end)

        return clone
    end,

    substract = function (self: declare.directions, with: number) : declare.directions
        const clone = self:clone()
        clone:each<<Vector3>>("Vector3", function(value: Vector3): Vector3
            return Vector3.new(value.X - with, value.Y - with, value.Z - with)
        end)

        return clone
    end,

    append = function (self: declare.directions, with: number) : declare.directions
        const clone = self:clone()
        clone:each<<Vector3>>("Vector3", function(value: Vector3): Vector3
            return Vector3.new(value.X + with, value.Y + with, value.Z + with)
        end)

        return clone
    end,

    multiple = function (self: declare.directions, with: number) : declare.directions
        const clone = self:clone()
        clone:each<<Vector3>>("Vector3", function(value: Vector3): Vector3
            return value * with
        end)

        return clone
    end,

    divide = function (self: declare.directions, with: number) : declare.directions
        const clone = self:clone()
        clone:each<<Vector3>>("Vector3", function(value: Vector3): Vector3
            return value / with
        end)

        return clone
    end,

    invert = function (self: declare.directions) : declare.directions
        const clone = self:clone()
        clone:each<<Vector3>>("Vector3", function(value: Vector3): Vector3
            return -value
        end)

        return clone
    end,

    normalize = function (self: declare.directions) : declare.directions
        const clone = self:clone()
        clone:each<<Vector3>>("Vector3", function(value: Vector3): Vector3
            return value.Unit
        end)

        return clone
    end,

    infinity = function(self: declare.directions) : declare.directions
        const clone = self:clone()
        clone:each<<Vector3>>("Vector3", function(value: Vector3): Vector3
            return Vector3.new(math.huge, math.huge, math.huge)
        end)

        return clone
    end
}

return class