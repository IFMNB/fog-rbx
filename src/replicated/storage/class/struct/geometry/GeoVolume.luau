--!strict
--!native
--!optimize 2

const Struct = require("@game/ReplicatedStorage/class/core/Struct")
const ctags = require("@game/ReplicatedStorage/static/ctags")
const ctype = require("@game/ReplicatedStorage/static/ctype")
const declare = require("@game/ReplicatedStorage/static/declare")
const ftype = require("@game/ReplicatedStorage/static/ftype")
const project = require("@game/ReplicatedStorage/static/project")

const class : geovolume = Struct:new {
    type = "geovolume",

    absolute = ftype:write(function (self: geovolume) : geovolume
        const clone = self:clone(self:each<<vector>>(declare.vector, function(value: vector): vector
            return vector.abs(value)
        end))

        return clone
    end, "geovolume", "geovolume"),

    null = ftype:write(function (self: geovolume) : geovolume
        const clone = self:clone(self:each<<vector>>(declare.vector, function(value: vector): vector
            return vector.zero
        end))

        return clone
    end, "geovolume", "geovolume"),

    substract = ftype:write(function (self: geovolume, with: number) : geovolume
        const clone = self:clone(self:each<<vector>>(declare.vector, function(value: vector): vector
            return vector.create(value.x - with, value.y - with, value.z - with)
        end))
        
        return clone
    end, "geovolume", "geovolume", declare.number),

    append = ftype:write(function (self: geovolume, with: number) : geovolume
        const clone = self:clone(self:each<<vector>>(declare.vector, function(value: vector): vector
            return vector.create(value.x + with, value.y + with, value.z + with)
        end))
        
        return clone
    end, "geovolume", "geovolume", declare.number),

    multiple = ftype:write(function (self: geovolume, with: number) : geovolume
        const clone = self:clone(self:each<<vector>>(declare.vector, function(value: vector): vector
            return value * with
        end))

        return clone
    end, "geovolume", "geovolume", declare.number),

    divide = ftype:write(function (self: geovolume, with: number) : geovolume
        const clone = self:clone(self:each<<vector>>(declare.vector, function(value: vector): vector
            return value / with
        end))
        
        return clone
    end, "geovolume", "geovolume", declare.number),

    invert = ftype:write(function (self: geovolume) : geovolume
        const clone = self:clone(self:each<<vector>>(declare.vector, function(value: vector): vector
            return -value
        end))
        
        return clone
    end, "geovolume", "geovolume"),

    normalize = ftype:write(function (self: geovolume) : geovolume
        const clone = self:clone(self:each<<vector>>(declare.vector, function(value: vector): vector
            return vector.normalize(value)
        end))
        
        return clone
    end, "geovolume", "geovolume"),

    infinity = ftype:write(function(self: geovolume) : geovolume
        const clone = self:clone(self:each<<vector>>(declare.vector, function(value: vector): vector
            return vector.create(math.huge, math.huge, math.huge)
        end))

        return clone
    end, "geovolume", "geovolume"),

    fuzzy_eq = ftype:write(function (self: geovolume, to: geovolume, epsilon: number?) : boolean
        const epsilon = epsilon or project.geometry.fuzzy_eq_diff

        const compare1 = self:each<<vector>>(declare.vector, function(value: vector): vector
            return value
        end)

        const compare2 = to:each<<vector>>(declare.vector, function(value: vector): vector
            return value
        end)

        for i, v in compare1 do
            const j = compare2[i]
            if j then
                const delta = (v - j)
                if vector.dot(delta, delta) > epsilon * epsilon then
                    return false
                end
            end
        end
        
        return true
    end, declare.boolean, "geovolume", "geovolume", ftype:opt(declare.number)),

    negation = ftype:write(function (self: geovolume) : geovolume
        const clone = self:clone(self:each<<vector>>(declare.vector, function(value: vector): vector
            return -vector.abs(value)
        end))

        return clone
    end, "geovolume", "geovolume"),

    lerp = ftype:write(function (self: geovolume, to: geovolume, alpha: number) : geovolume
        const result: {[unknown]: vector} = {}

        const compare1 = self:each<<vector>>(declare.vector, function(value: vector): vector
            return value
        end)

        const compare2 = to:each<<vector>>(declare.vector, function(value: vector): vector
            return value
        end)

        for i, v in compare1 do
            const j = compare2[i]
            if j then
                result[i] = vector.lerp(v, j, alpha)
            end
        end

        return self:clone(result)
    end, "geovolume", "geovolume", "geovolume", declare.number)
}

ctype:read(class):write_tag(ctags.geometry, ctags.struct)


return class