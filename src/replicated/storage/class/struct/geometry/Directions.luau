--!strict
--!native
--!optimize 2

const GeoVolume = require("@game/ReplicatedStorage/class/struct/geometry/GeoVolume")
const ctags = require("@game/ReplicatedStorage/static/ctags")
const ctype = require("@game/ReplicatedStorage/static/ctype")
const declare = require("@game/ReplicatedStorage/static/declare")
const ftype = require("@game/ReplicatedStorage/static/ftype")

const class : directions = GeoVolume:new {
    type = "directions",

    right = vector.zero,
    up = vector.zero,
    front = vector.zero,

    to_vector = ftype:write(function (self: directions) : vector
        return vector.create(vector.magnitude(self.right), vector.magnitude(self.up), vector.magnitude(self.front))
    end, declare.vector, "directions"),
}

ctype:read(class):write_tag(ctags.geometry, ctags.struct)

return class