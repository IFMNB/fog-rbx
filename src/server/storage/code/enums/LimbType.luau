const enum = require("../class/arch/enum")
const struct = { __index = enum }
setmetatable(struct, struct)

struct.Torso = enum.new()
struct.Head = enum.new()
struct.RightArm = enum.new()
struct.LeftArm = enum.new()
struct.RightLeg = enum.new()
struct.LeftLeg = enum.new()

const map = table.freeze({
	[Enum.Limb.Head] = struct.Head,
	[Enum.Limb.Torso] = struct.Torso,
	[Enum.Limb.RightArm] = struct.RightArm,
	[Enum.Limb.LeftArm] = struct.LeftArm,
	[Enum.Limb.RightLeg] = struct.RightLeg,
	[Enum.Limb.LeftLeg] = struct.LeftLeg,
	[Enum.BodyPart.Head] = struct.Head,
	[Enum.BodyPart.Torso] = struct.Torso,
	[Enum.BodyPart.RightArm] = struct.RightArm,
	[Enum.BodyPart.LeftArm] = struct.LeftArm,
	[Enum.BodyPart.RightLeg] = struct.RightLeg,
	[Enum.BodyPart.LeftLeg] = struct.LeftLeg,
	[Enum.BodyPartR15.Head] = struct.Head,
	[Enum.BodyPartR15.LowerTorso] = struct.Torso,
	[Enum.BodyPartR15.UpperTorso] = struct.Torso,
	[Enum.BodyPartR15.LeftLowerArm] = struct.LeftArm,
	[Enum.BodyPartR15.LeftUpperArm] = struct.LeftArm,
	[Enum.BodyPartR15.LeftHand] = struct.LeftArm,
	[Enum.BodyPartR15.RightLowerArm] = struct.RightArm,
	[Enum.BodyPartR15.RightUpperArm] = struct.RightArm,
	[Enum.BodyPartR15.RightHand] = struct.RightArm,
	[Enum.BodyPartR15.LeftLowerLeg] = struct.LeftLeg,
	[Enum.BodyPartR15.LeftUpperLeg] = struct.LeftLeg,
	[Enum.BodyPartR15.LeftFoot] = struct.LeftLeg,
	[Enum.BodyPartR15.RightLowerLeg] = struct.RightLeg,
	[Enum.BodyPartR15.RightUpperLeg] = struct.RightLeg,
	[Enum.BodyPartR15.RightFoot] = struct.RightLeg,
})

function struct.map(limb: Enum.Limb | Enum.BodyPartR15 | Enum.BodyPart): number
	return map[limb] or struct.Unknown
end

return table.freeze(struct)
