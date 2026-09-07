--!strict
const Record = require("@game/ReplicatedStorage/class/arch/Record")
const declare = require("@game/ReplicatedStorage/static/declare")
const dgeometry = require("@game/ReplicatedStorage/static/dgeometry")

const class : dgeometry.directions = Record:new {
    type = "directions",

    right = vector.zero,
    up = vector.zero,
    front = vector.zero,

    to_cframe = function (self: dgeometry.directions) : CFrame
        return CFrame.fromMatrix(Vector3.zero, Vector3.new(self.right.x, self.right.y, self.right.z), Vector3.new(self.up.x,self.up.y,self.up.z), Vector3.new(self.front.x, self.front.y, self.front.z))
    end,

    to_vector = function (self: dgeometry.directions) : vector
        return vector.create(vector.magnitude(self.right), vector.magnitude(self.up), vector.magnitude(self.front))
    end,

    absolute = function (self: dgeometry.directions) : dgeometry.directions
        const clone = self:clone()
        clone:each<<vector>>(declare.vector, function(value: vector): vector
            return vector.abs(value)
        end)

        return clone
    end,

    null = function (self: dgeometry.directions) : dgeometry.directions
        const clone = self:clone()
        clone:each<<vector>>(declare.vector, function(value: vector): vector
            return vector.zero
        end)

        return clone
    end,

    substract = function (self: dgeometry.directions, with: number) : dgeometry.directions
        const clone = self:clone()
        clone:each<<vector>>(declare.vector, function(value: vector): vector
            return vector.create(value.x - with, value.y - with, value.z - with)
        end)

        return clone
    end,

    append = function (self: dgeometry.directions, with: number) : dgeometry.directions
        const clone = self:clone()
        clone:each<<vector>>(declare.vector, function(value: vector): vector
            return vector.create(value.x + with, value.y + with, value.z + with)
        end)

        return clone
    end,

    multiple = function (self: dgeometry.directions, with: number) : dgeometry.directions
        const clone = self:clone()
        clone:each<<vector>>(declare.vector, function(value: vector): vector
            return value * with
        end)

        return clone
    end,

    divide = function (self: dgeometry.directions, with: number) : dgeometry.directions
        const clone = self:clone()
        clone:each<<vector>>(declare.vector, function(value: vector): vector
            return value / with
        end)

        return clone
    end,

    invert = function (self: dgeometry.directions) : dgeometry.directions
        const clone = self:clone()
        clone:each<<vector>>(declare.vector, function(value: vector): vector
            return -value
        end)

        return clone
    end,

    normalize = function (self: dgeometry.directions) : dgeometry.directions
        const clone = self:clone()
        clone:each<<vector>>(declare.vector, function(value: vector): vector
            return vector.normalize(value)
        end)

        return clone
    end,

    infinity = function(self: dgeometry.directions) : dgeometry.directions
        const clone = self:clone()
        clone:each<<vector>>(declare.vector, function(value: vector): vector
            return vector.create(math.huge, math.huge, math.huge)
        end)

        return clone
    end
}

return class