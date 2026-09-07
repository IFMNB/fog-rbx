--!strict
const declare = require("@game/ReplicatedStorage/static/declare")
const dgeometry = require("@game/ReplicatedStorage/static/dgeometry")
const project = require("@game/ReplicatedStorage/static/project")
const CubeVolume = require("@game/ReplicatedStorage/struct/geometry/CubeVolume")

const class: dgeometry.aabbvolume = CubeVolume:new({
	type = "aabbvolume",

	half = vector.zero,
	min = vector.zero,
	max = vector.zero,

	is_inside = function(self: dgeometry.aabbvolume, ...: dgeometry.geometry_supported): boolean
		for _, v in table.freeze { ... } :: { any } do
			if typeof(v) == dgeometry.roblox.Instance then
				const rbx_instance = v :: Instance

				if rbx_instance:IsA("Model") or rbx_instance:IsA("BasePart") then
					if not self:is_inside(self:from(rbx_instance)) then
						return false
					end
				end
			elseif self:equals(v) then
				const aabbvolume = v :: dgeometry.aabbvolume

				if not (
						self.min.x <= aabbvolume.min.x
						and self.max.x >= aabbvolume.max.x
						and self.min.y <= aabbvolume.min.y
						and self.max.y >= aabbvolume.max.y
						and self.min.z <= aabbvolume.min.z
						and self.max.z >= aabbvolume.max.z
					)
				then
					return false
				end
			elseif self.is(v, "cubevolume") then
				const cubevolume = v :: dgeometry.cubevolume


			elseif self.is(v, "capsulevolume") then
				const capsulevolume = v :: dgeometry.capsulevolume


			elseif self.is(v, "trianglevolume") then
				const trianglevolume = v :: dgeometry.trianglevolume


			elseif self.is(v, "spherevolume") then
				const spherevolume = v :: dgeometry.spherevolume


			else
				project.console_out_error(
					"cannot check is aabbvolume inside received object, because received object type is unexpected"
				)
				return false
			end
		end

		return true
	end,
    
	is_interacts = function(self: dgeometry.aabbvolume, ...: dgeometry.geometry_supported): boolean
        for _, v in table.freeze({ ... }) :: { any } do
			if not self:is_inside(v) and not self:is_intersection(v) then
                return false
			end
		end

        return true
    end,

	is_intersection = function(self: dgeometry.aabbvolume, ...: dgeometry.geometry_supported): boolean end,

	from = function(self: dgeometry.aabbvolume, ...: dgeometry.geometry_supported): dgeometry.aabbvolume end,

	middle = function(self: dgeometry.aabbvolume, ...: dgeometry.geometry_supported): dgeometry.aabbvolume end,

	cover = function(self: dgeometry.aabbvolume, ...: dgeometry.geometry_supported): dgeometry.aabbvolume end,
})

return class
