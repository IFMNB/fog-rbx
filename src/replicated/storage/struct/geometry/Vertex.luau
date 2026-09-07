--!strict
const Record = require("@game/ReplicatedStorage/class/arch/Record")
const declare = require("@game/ReplicatedStorage/static/declare")
const dgeometry = require("@game/ReplicatedStorage/static/dgeometry")

const private = {}
const class : dgeometry.vertex = Record:new {
    type = "vertex",
    normal = vector.zero,
    position = vector.zero,
    mtv_min = 0,

    from_global_point = function (self: dgeometry.vertex, position: vector?) : dgeometry.vertex
        const normal: vector = vector.normalize((vector.zero - (position or vector.zero)))
        const new = self:new({normal = normal, position = position})
        return new
    end,

    from_local_point = function (self: dgeometry.vertex, local_position: vector?, position: vector?) : dgeometry.vertex
        const normal: vector = vector.normalize(((position or vector.zero) - (local_position or vector.zero)))
        const new = self:new({normal = normal, position = position})
        return new
    end,

    absolute = function (self: dgeometry.vertex) : dgeometry.vertex
        const clone = self:clone()
        clone:each<<vector>>(declare.vector, function(value: vector): vector
            return vector.abs(value)
        end)

        clone.normal = self.normal

        return clone
    end,

    null = function (self: dgeometry.vertex) : dgeometry.vertex
        const clone = self:clone()
        clone:each<<vector>>(declare.vector, function(value: vector): vector
            return vector.zero
        end)

        clone.normal = self.normal

        return clone
    end,

    substract = function (self: dgeometry.vertex, with: number) : dgeometry.vertex
        const clone = self:clone()
        clone:each<<vector>>(declare.vector, function(value: vector): vector
            return vector.create(value.x - with, value.y - with, value.z - with)
        end)

        clone.normal = self.normal

        return clone
    end,

    append = function (self: dgeometry.vertex, with: number) : dgeometry.vertex
        const clone = self:clone()
        clone:each<<vector>>(declare.vector, function(value: vector): vector
            return vector.create(value.x + with, value.y + with, value.z + with)
        end)

        clone.normal = self.normal

        return clone
    end,

    multiple = function (self: dgeometry.vertex, with: number) : dgeometry.vertex
        const clone = self:clone()
        clone:each<<vector>>(declare.vector, function(value: vector): vector
            return value * with
        end)

        clone.normal = self.normal

        return clone
    end,

    divide = function (self: dgeometry.vertex, with: number) : dgeometry.vertex
        const clone = self:clone()
        clone:each<<vector>>(declare.vector, function(value: vector): vector
            return value / with
        end)

        clone.normal = self.normal

        return clone
    end,

    invert = function (self: dgeometry.vertex) : dgeometry.vertex
        const clone = self:clone()
        clone:each<<vector>>(declare.vector, function(value: vector): vector
            return -value
        end)

        return clone
    end,

    normalize = function (self: dgeometry.vertex) : dgeometry.vertex
        const clone = self:clone()
        clone:each<<vector>>(declare.vector, function(value: vector): vector
            return vector.abs(value)
        end)

        return clone
    end,

    infinity = function(self: dgeometry.vertex) : dgeometry.vertex
        const clone = self:clone()
        clone:each<<vector>>(declare.vector, function(value: vector): vector
            return vector.create(math.huge, math.huge, math.huge)
        end)

        clone.normal = self.normal

        return clone
    end
}

do
    private.link = class
end

return class