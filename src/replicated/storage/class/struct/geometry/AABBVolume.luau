--!strict
const CubeVolume = require("@game/ReplicatedStorage/class/struct/geometry/CubeVolume")
const declare = require("@game/ReplicatedStorage/static/declare")
const project = require("@game/ReplicatedStorage/static/project")

const class: aabbvolume = CubeVolume:new({
	type = "aabbvolume",

	half = vector.zero,
	min = vector.zero,
	max = vector.zero,

	is_inside = function(self: aabbvolume, ...: geometry_supported): boolean
		for _, v in table.freeze { ... } :: { any } do
			if typeof(v) == declare.roblox.Instance then
				const rbx_instance = v :: Instance

				if rbx_instance:IsA("Model") or rbx_instance:IsA("BasePart") then
					if not self:is_inside(self:from(rbx_instance)) then
						return false
					end
				end
			elseif self:eq(v) then
				const aabbvolume = v :: aabbvolume

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
				const cubevolume = v :: cubevolume


			elseif self.is(v, "capsulevolume") then
				const capsulevolume = v :: capsulevolume


			elseif self.is(v, "trianglevolume") then
				const trianglevolume = v :: trianglevolume


			elseif self.is(v, "spherevolume") then
				const spherevolume = v :: spherevolume


			else
				project.console_out_error("")
				return false
			end
		end

		return true
	end,
    
	is_interacts = function(self: aabbvolume, ...: geometry_supported): boolean
        for _, v in table.freeze({ ... }) :: { any } do
			if not self:is_inside(v) and not self:is_intersection(v) then
                return false
			end
		end

        return true
    end,

	is_intersection = function(self: aabbvolume, ...: geometry_supported): boolean
	
	end,

	from = function(self: aabbvolume, ...: geometry_supported): aabbvolume
	
	end,

	middle = function(self: aabbvolume, ...: geometry_supported): aabbvolume
	
	end,

	cover = function(self: aabbvolume, ...: geometry_supported): aabbvolume
	
	end,
})

return class
