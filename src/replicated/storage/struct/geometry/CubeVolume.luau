--!strict

const Record = require("@game/ReplicatedStorage/class/arch/Record")
const DirectionVariant = require("@game/ReplicatedStorage/enums/descriptor/DirectionVariant")
const declare = require("@game/ReplicatedStorage/static/declare")
const project = require("@game/ReplicatedStorage/static/project")

const Quad = require("@game/ReplicatedStorage/struct/geometry/Quad")
const Triangle = require("@game/ReplicatedStorage/struct/geometry/Triangle")
const Vertex = require("@game/ReplicatedStorage/struct/geometry/Vertex")

const class : declare.cubevolume = Record:new {
    type = "cubevolume",

    up = vector.zero,
    bottom = vector.zero,
    left = vector.zero,
    right = vector.zero,
    front = vector.zero,
    back = vector.zero,

    get_corners = function (self: declare.cubevolume) : {declare.vertex} 
        const center: vector = self:get_center()

        return {
            Vertex:from_local_point(center, self.up),
            Vertex:from_local_point(center, self.bottom),
            Vertex:from_local_point(center, self.left),
            Vertex:from_local_point(center, self.right),
            Vertex:from_local_point(center, self.front),
            Vertex:from_local_point(center, self.back),
        }
    end,

    get_direction = function (self: declare.cubevolume, direction: declare.enumitem) : vector
        DirectionVariant:assert_is_my_enumitem(direction)

        if direction == DirectionVariant.Right then
            return self.right
        elseif direction == DirectionVariant.Left then
            return self.left
        elseif direction == DirectionVariant.Up then
            return self.up
        elseif direction == DirectionVariant.Bottom then
            return self.bottom
        elseif direction == DirectionVariant.Front then
            return self.front
        elseif direction == DirectionVariant.Back then
            return self.back
        end

        return project.console_out_error("unsupported DirectionVariant item")
    end,

    get_axises = function (self: declare.cubevolume) : {vector}
        return {
            self:get_direction(DirectionVariant.Right),
            self:get_direction(DirectionVariant.Up),
            self:get_direction(DirectionVariant.Front)
        }
    end,

    get_sat_axises = function (self: declare.cubevolume) : {vector}
        const axises = self:get_axises()
        const center = self:get_center()

        for i = 1, #axises do
            axises[i] = vector.normalize(axises[i] - center)
        end

        return axises
    end,

    get_quad = function (self: declare.cubevolume, direction: declare.enumitem) : declare.quad 
        DirectionVariant:assert_is_my_enumitem(direction)

        if direction == DirectionVariant.Right then
            return Quad:new {
                right = Triangle:from_vector(
                    self.right + self.up + self.front,
                    self.right + self.up + self.back,
                    self.right + self.bottom + self.front
                ),
                left = Triangle:from_vector(
                    self.right + self.up + self.back,
                    self.right + self.bottom + self.back,
                    self.right + self.bottom + self.front
                )
            }

        elseif direction == DirectionVariant.Left then
            return Quad:new {
                right = Triangle:from_vector(
                    self.left + self.up + self.front,
                    self.left + self.bottom + self.front,
                    self.left + self.up + self.back
                ),
                left = Triangle:from_vector(
                    self.left + self.up + self.back,
                    self.left + self.bottom + self.front,
                    self.left + self.bottom + self.back
                )
            }

        elseif direction == DirectionVariant.Up then
            return Quad:new {
                right = Triangle:from_vector(
                    self.up + self.right + self.front,
                    self.up + self.front + self.left,
                    self.up + self.right + self.back
                ),
                left = Triangle:from_vector(
                    self.up + self.right + self.back,
                    self.up + self.front + self.left,
                    self.up + self.left + self.back
                )
            }

        elseif direction == DirectionVariant.Bottom then
            return Quad:new {
                right = Triangle:from_vector(
                    self.bottom + self.right + self.front,
                    self.bottom + self.right + self.back,
                    self.bottom + self.left + self.front
                ),
                left = Triangle:from_vector(
                    self.bottom + self.right + self.back,
                    self.bottom + self.left + self.back,
                    self.bottom + self.left + self.front
                )
            }

        elseif direction == DirectionVariant.Front then
            return Quad:new {
                right = Triangle:from_vector(
                    self.front + self.right + self.up,
                    self.front + self.left + self.up,
                    self.front + self.right + self.bottom
                ),
                left = Triangle:from_vector(
                    self.front + self.left + self.up,
                    self.front + self.left + self.bottom,
                    self.front + self.right + self.bottom
                )
            }

        elseif direction == DirectionVariant.Back then
            return Quad:new {
                right = Triangle:from_vector(
                    self.back + self.right + self.up,
                    self.back + self.right + self.bottom,
                    self.back + self.left + self.up
                ),
                left = Triangle:from_vector(
                    self.back + self.left + self.up,
                    self.back + self.right + self.bottom,
                    self.back + self.left + self.bottom
                )
            }
        end

        return project.console_out_error("unsupported DirectionVariant item")
    end,

    to_vector = function (self: declare.cubevolume) : vector
        return vector.create(vector.magnitude(self.right), vector.magnitude(self.up), vector.magnitude(self.front))
    end,
    
    to_cframe = function (self: declare.cubevolume) : CFrame
        const center = self:get_center()

        return CFrame.fromMatrix(Vector3.new(center.x, center.y, center.z),
            Vector3.new(self.right.x, self.right.y, self.right.z),
            Vector3.new(self.up.x, self.up.y, self.up.z), 
            Vector3.new(self.front.x, self.front.y, self.front.z))
    end,

    get_center = function (self: declare.cubevolume) : vector
        return (self.up + self.bottom + self.left + self.right + self.front + self.back) / 6
    end,

    absolute = function (self: declare.cubevolume) : declare.cubevolume
        const clone = self:clone()
        clone:each<<vector>>(declare.vector, function(value: vector): vector
            return vector.abs(value)
        end)

        return clone
    end,

    null = function (self: declare.cubevolume) : declare.cubevolume
        const clone = self:clone()
        clone:each<<vector>>(declare.vector, function(value: vector): vector
            return vector.zero
        end)

        return clone
    end,

    substract = function (self: declare.cubevolume, with: number) : declare.cubevolume
        const clone = self:clone()
        clone:each<<vector>>(declare.vector, function(value: vector): vector
            return vector.create(value.x - with, value.y - with, value.z - with)
        end)

        return clone
    end,

    append = function (self: declare.cubevolume, with: number) : declare.cubevolume
        const clone = self:clone()
        clone:each<<vector>>(declare.vector, function(value: vector): vector
            return vector.create(value.x + with, value.y + with, value.z + with)
        end)

        return clone
    end,

    multiple = function (self: declare.cubevolume, with: number) : declare.cubevolume
        const clone = self:clone()
        clone:each<<vector>>(declare.vector, function(value: vector): vector
            return value * with
        end)

        return clone
    end,

    divide = function (self: declare.cubevolume, with: number) : declare.cubevolume
        const clone = self:clone()
        clone:each<<vector>>(declare.vector, function(value: vector): vector
            return value / with
        end)

        return clone
    end,

    invert = function (self: declare.cubevolume) : declare.cubevolume
        const clone = self:clone()
        clone:each<<vector>>(declare.vector, function(value: vector): vector
            return -value
        end)

        return clone
    end,

    normalize = function (self: declare.cubevolume) : declare.cubevolume
        const clone = self:clone()
        clone:each<<vector>>(declare.vector, function(value: vector): vector
            return vector.normalize(value)
        end)

        return clone
    end,

    infinity = function(self: declare.cubevolume) : declare.cubevolume
        const clone = self:clone()
        clone:each<<vector>>(declare.vector, function(value: vector): vector
            return vector.create(math.huge, math.huge, math.huge)
        end)

        return clone
    end
}

return class