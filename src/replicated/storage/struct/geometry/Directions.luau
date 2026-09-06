--!strict
const Record = require("@game/ReplicatedStorage/class/arch/Record")
const declare = require("@game/ReplicatedStorage/static/declare")

const class : declare.directions = Record:new {
    type = "directions",

    right = vector.zero,
    up = vector.zero,
    front = vector.zero,

    to_cframe = function (self: declare.directions) : CFrame
        return CFrame.fromMatrix(Vector3.zero, Vector3.new(self.right.x, self.right.y, self.right.z), Vector3.new(self.up.x,self.up.y,self.up.z), Vector3.new(self.front.x, self.front.y, self.front.z))
    end,

    to_vector = function (self: declare.directions) : vector
        return vector.create(vector.magnitude(self.right), vector.magnitude(self.up), vector.magnitude(self.front))
    end,

    absolute = function (self: declare.directions) : declare.directions
        const clone = self:clone()
        clone:each<<vector>>(declare.vector, function(value: vector): vector
            return vector.abs(value)
        end)

        return clone
    end,

    null = function (self: declare.directions) : declare.directions
        const clone = self:clone()
        clone:each<<vector>>(declare.vector, function(value: vector): vector
            return vector.zero
        end)

        return clone
    end,

    substract = function (self: declare.directions, with: number) : declare.directions
        const clone = self:clone()
        clone:each<<vector>>(declare.vector, function(value: vector): vector
            return vector.create(value.x - with, value.y - with, value.z - with)
        end)

        return clone
    end,

    append = function (self: declare.directions, with: number) : declare.directions
        const clone = self:clone()
        clone:each<<vector>>(declare.vector, function(value: vector): vector
            return vector.create(value.x + with, value.y + with, value.z + with)
        end)

        return clone
    end,

    multiple = function (self: declare.directions, with: number) : declare.directions
        const clone = self:clone()
        clone:each<<vector>>(declare.vector, function(value: vector): vector
            return value * with
        end)

        return clone
    end,

    divide = function (self: declare.directions, with: number) : declare.directions
        const clone = self:clone()
        clone:each<<vector>>(declare.vector, function(value: vector): vector
            return value / with
        end)

        return clone
    end,

    invert = function (self: declare.directions) : declare.directions
        const clone = self:clone()
        clone:each<<vector>>(declare.vector, function(value: vector): vector
            return -value
        end)

        return clone
    end,

    normalize = function (self: declare.directions) : declare.directions
        const clone = self:clone()
        clone:each<<vector>>(declare.vector, function(value: vector): vector
            return vector.normalize(value)
        end)

        return clone
    end,

    infinity = function(self: declare.directions) : declare.directions
        const clone = self:clone()
        clone:each<<vector>>(declare.vector, function(value: vector): vector
            return vector.create(math.huge, math.huge, math.huge)
        end)

        return clone
    end
}

return class