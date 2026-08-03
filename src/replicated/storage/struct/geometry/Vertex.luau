--!strict
const Record = require("@game/ReplicatedStorage/class/arch/Record")
const declare = require("@game/ReplicatedStorage/static/declare")
const namefield = require("@game/ReplicatedStorage/static/namefield")

const private = {}
const class : declare.vertex = Record:new {
    type = namefield.vertex,
    normal = Vector3.zero,
    position = Vector3.zero,
    mtv_min = 0,

    from_global_point = function (self: declare.vertex, position: Vector3?) : declare.vertex
        const normal: Vector3 = (Vector3.zero - (position or Vector3.zero)).Unit
        const new = self:new({normal = normal, position = position})
        return new
    end,

    from_local_point = function (self: declare.vertex, local_position: Vector3?, position: Vector3?) : declare.vertex
        const normal: Vector3 = ((position or Vector3.zero) - (local_position or Vector3.zero)).Unit
        const new = self:new({normal = normal, position = position})
        return new
    end,

    absolute = function (self: declare.vertex) : declare.vertex
        const clone = self:clone()
        clone:each<<Vector3>>("Vector3", function(value: Vector3): Vector3
            return value:Abs()
        end)

        clone.normal = self.normal

        return clone
    end,

    null = function (self: declare.vertex) : declare.vertex
        const clone = self:clone()
        clone:each<<Vector3>>("Vector3", function(value: Vector3): Vector3
            return Vector3.zero
        end)

        clone.normal = self.normal

        return clone
    end,

    substract = function (self: declare.vertex, with: number) : declare.vertex
        const clone = self:clone()
        clone:each<<Vector3>>("Vector3", function(value: Vector3): Vector3
            return Vector3.new(value.X - with, value.Y - with, value.Z - with)
        end)

        clone.normal = self.normal

        return clone
    end,

    append = function (self: declare.vertex, with: number) : declare.vertex
        const clone = self:clone()
        clone:each<<Vector3>>("Vector3", function(value: Vector3): Vector3
            return Vector3.new(value.X + with, value.Y + with, value.Z + with)
        end)

        clone.normal = self.normal

        return clone
    end,

    multiple = function (self: declare.vertex, with: number) : declare.vertex
        const clone = self:clone()
        clone:each<<Vector3>>("Vector3", function(value: Vector3): Vector3
            return value * with
        end)

        clone.normal = self.normal

        return clone
    end,

    divide = function (self: declare.vertex, with: number) : declare.vertex
        const clone = self:clone()
        clone:each<<Vector3>>("Vector3", function(value: Vector3): Vector3
            return value / with
        end)

        clone.normal = self.normal

        return clone
    end,

    invert = function (self: declare.vertex) : declare.vertex
        const clone = self:clone()
        clone:each<<Vector3>>("Vector3", function(value: Vector3): Vector3
            return -value
        end)

        return clone
    end,

    normalize = function (self: declare.vertex) : declare.vertex
        const clone = self:clone()
        clone:each<<Vector3>>("Vector3", function(value: Vector3): Vector3
            return value.Unit
        end)

        return clone
    end,

    infinity = function(self: declare.vertex) : declare.vertex
        const clone = self:clone()
        clone:each<<Vector3>>("Vector3", function(value: Vector3): Vector3
            return Vector3.new(math.huge, math.huge, math.huge)
        end)

        clone.normal = self.normal

        return clone
    end
}

do
    private.link = class
end

return class