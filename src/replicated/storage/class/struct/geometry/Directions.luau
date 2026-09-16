--!strict
const Struct = require("@game/ReplicatedStorage/class/core/Struct")
const declare = require("@game/ReplicatedStorage/static/declare")

const class : directions = Struct:new {
    type = "directions",

    right = vector.zero,
    up = vector.zero,
    front = vector.zero,

    to_cframe = function (self: directions) : CFrame
        return CFrame.fromMatrix(Vector3.zero, Vector3.new(self.right.x, self.right.y, self.right.z), Vector3.new(self.up.x,self.up.y,self.up.z), Vector3.new(self.front.x, self.front.y, self.front.z))
    end,

    to_vector = function (self: directions) : vector
        return vector.create(vector.magnitude(self.right), vector.magnitude(self.up), vector.magnitude(self.front))
    end,

    absolute = function (self: directions) : directions
        const clone = self:clone(self:each<<vector>>(declare.vector, function(value: vector): vector
            return vector.abs(value)
        end))

        return clone
    end,

    null = function (self: directions) : directions
        const clone = self:clone(self:each<<vector>>(declare.vector, function(value: vector): vector
            return vector.zero
        end))

        return clone
    end,

    substract = function (self: directions, with: number) : directions
        const clone = self:clone(self:each<<vector>>(declare.vector, function(value: vector): vector
            return vector.create(value.x - with, value.y - with, value.z - with)
        end))

        return clone
    end,

    append = function (self: directions, with: number) : directions
        const clone = self:clone(self:each<<vector>>(declare.vector, function(value: vector): vector
            return vector.create(value.x + with, value.y + with, value.z + with)
        end))
        
        return clone
    end,

    multiple = function (self: directions, with: number) : directions
        const clone = self:clone(self:each<<vector>>(declare.vector, function(value: vector): vector
            return value * with
        end))
        
        return clone
    end,

    divide = function (self: directions, with: number) : directions
        const clone = self:clone(self:each<<vector>>(declare.vector, function(value: vector): vector
            return value / with
        end))

        return clone
    end,

    negation = function (self: directions) : directions
        const clone = self:clone( self:each<<vector>>(declare.vector, function(value: vector): vector
            return -vector.abs(value)
        end))

        return clone
    end,

    lerp = function (self: directions, to: directions, alpha: number) : directions
        const clone = self:clone({
            right = vector.lerp(self.right, to.right, alpha),
            up = vector.lerp(self.up, to.up, alpha),
            front = vector.lerp(self.front, to.front, alpha),
        })

        return clone
    end,
    
    invert = function (self: directions) : directions
        const clone = self:clone(self:each<<vector>>(declare.vector, function(value: vector): vector
            return -value
        end))
        
        return clone
    end,

    normalize = function (self: directions) : directions
        const clone = self:clone(self:each<<vector>>(declare.vector, function(value: vector): vector
            return vector.normalize(value)
        end))
        
        return clone
    end,

    infinity = function(self: directions) : directions
        const clone = self:clone(self:each<<vector>>(declare.vector, function(value: vector): vector
            return vector.create(math.huge, math.huge, math.huge)
        end))
        
        return clone
    end
}

return class