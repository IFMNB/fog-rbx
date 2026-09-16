--!strict
const Struct = require("@game/ReplicatedStorage/class/core/Struct")
const declare = require("@game/ReplicatedStorage/static/declare")

const class : vertex = Struct:new {
    type = "vertex",
    normal = vector.zero,
    position = vector.zero,
    mtv_min = 0,

    from_global_point = function (self: vertex, position: vector?) : vertex
        const normal: vector = vector.normalize((vector.zero - (position or vector.zero)))
        const new = self:new({normal = normal, position = position})
        return new
    end,

    from_local_point = function (self: vertex, local_position: vector?, position: vector?) : vertex
        const normal: vector = vector.normalize(((position or vector.zero) - (local_position or vector.zero)))
        const new = self:new({normal = normal, position = position})
        return new
    end,

    absolute = function (self: vertex) : vertex
        const clone = self:clone( self:each<<vector>>(declare.vector, function(value: vector): vector
            return vector.abs(value)
        end))

        return clone
    end,

    fuzzy_eq = function (self: vertex, to: vertex, epsilon: number?) : boolean
        const each = {}

        self:each<<vector>>(declare.vector, function(value: vector): vector
            --TODO
            
            return value
        end)

        for _, v in each do
        
        end

        return clone
    end,

    negation = function (self: vertex) : vertex
        const clone = self:clone( self:each<<vector>>(declare.vector, function(value: vector): vector
            return -vector.abs(value)
        end))

        return clone
    end,

    lerp = function (self: vertex, to: vertex, alpha: number) : vertex
        const clone = self:clone( self:each<<vector>>(declare.vector, function(value: vector): vector
            return vector.lerp(value, to.position, alpha)
        end))

        return clone
    end,

    null = function (self: vertex) : vertex
        const clone = self:clone(self:each<<vector>>(declare.vector, function(value: vector): vector
            return vector.zero
        end))

        return clone
    end,

    substract = function (self: vertex, with: number) : vertex
        const clone = self:clone(self:each<<vector>>(declare.vector, function(value: vector): vector
            return vector.create(value.x - with, value.y - with, value.z - with)
        end))

        return clone
    end,

    append = function (self: vertex, with: number) : vertex
        const clone = self:clone(self:each<<vector>>(declare.vector, function(value: vector): vector
            return vector.create(value.x + with, value.y + with, value.z + with)
        end))
  
        return clone
    end,

    multiple = function (self: vertex, with: number) : vertex
        const clone = self:clone(self:each<<vector>>(declare.vector, function(value: vector): vector
            return value * with
        end))

        return clone
    end,

    divide = function (self: vertex, with: number) : vertex
        const clone = self:clone(self:each<<vector>>(declare.vector, function(value: vector): vector
            return value / with
        end))
  
        return clone
    end,

    invert = function (self: vertex) : vertex
        const clone = self:clone(self:each<<vector>>(declare.vector, function(value: vector): vector
            return -value
        end))

        return clone
    end,

    normalize = function (self: vertex) : vertex
        const clone = self:clone(self:each<<vector>>(declare.vector, function(value: vector): vector
            return vector.abs(value)
        end))

        return clone
    end,

    infinity = function(self: vertex) : vertex
        const clone = self:clone(self:each<<vector>>(declare.vector, function(value: vector): vector
            return vector.create(math.huge, math.huge, math.huge)
        end))

        return clone
    end
}

return class