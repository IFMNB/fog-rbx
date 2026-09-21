--!strict
--!native
--!optimize 2

const Directions = require("@game/ReplicatedStorage/class/struct/geometry/Directions")
const GeoVolume = require("@game/ReplicatedStorage/class/struct/geometry/GeoVolume")
const ctags = require("@game/ReplicatedStorage/static/ctags")
const ctype = require("@game/ReplicatedStorage/static/ctype")
const declare = require("@game/ReplicatedStorage/static/declare")
const ftype = require("@game/ReplicatedStorage/static/ftype")

const class : basis = (GeoVolume :: geovolume<basis>):new {
    type = "basis",
    rotation = Directions:new(),
    position = vector.zero,
    
    orthonormalize = ftype:write(function (self: basis) : basis
        const right = self.rotation.right
        const up = self.rotation.up

        const orthonormal_right = vector.normalize(right)
        const orthonormal_up = vector.normalize(up - orthonormal_right * vector.dot(up, orthonormal_right))
        const orthonormal_front = vector.normalize(vector.cross(orthonormal_right, orthonormal_up))

        const clone = self:clone({
            rotation = Directions:new({
                right = orthonormal_right,
                up = orthonormal_up,
                front = orthonormal_front
            })
        })

        return clone
    end, "basis", "basis"),

    euler_angles = ftype:write(function (self: basis) : ...number
        const right = self.rotation.right
        const up = self.rotation.up
        const front = self.rotation.front
        const pitch = math.asin(-right.z)
        const cos_pitch = math.cos(pitch)

        if math.abs(cos_pitch) > 1e-6 then
            const roll = math.atan2(up.z, front.z)
            const yaw = math.atan2(right.y, right.x)

            return roll, pitch, yaw
        end

        const roll = 0
        const yaw = math.atan2(-up.x, up.y)

        return roll, pitch, yaw
    end, ftype:var(declare.number), "basis"),

    components = ftype:write(function (self: basis) : ...number
        const right = self.rotation.right
        const up = self.rotation.up
        const front = self.rotation.front
        const pos = self.position

        return
            pos.x, pos.y, pos.z,
            right.x,  up.x,  front.x,
            right.y,  up.y,  front.y,
            right.z,  up.z,  front.z
    end, ftype:var(declare.number), "basis")
}

ctype:read(class):write_tag(ctags.geometry, ctags.struct)

return class