--!strict

const Disposable = require("@game/ReplicatedStorage/Disposable")
const Processor = require("@game/ReplicatedStorage/class/processor/Processor")
const object = require("@game/ReplicatedStorage/object")
const namefield = require("@game/ReplicatedStorage/static/namefield")
const project = require("@game/ReplicatedStorage/static/project")

const private = {}
const class = { __index = Processor }
setmetatable(class, class)

export type class = object.class<typeof(class)>

class.type = namefield.physics
class.attention_transform = CFrame.identity
class.pursue_attention_pos = false
class.pursue_attention_rot = false
class.lock_rx = false
class.lock_ry = false
class.lock_rz = false
class.lock_rx_to = Vector3.zero
class.lock_ry_to = Vector3.zero
class.lock_rz_to = Vector3.zero
class.lock_px = false
class.lock_py = false
class.lock_pz = false
class.lock_px_to = 0
class.lock_py_to = 0
class.lock_pz_to = 0
class.classname = "PVInstance"
class.smooth = false
class.processed_pivot = CFrame.identity

function class.new()
	return Disposable.new(class, true)
end

--function class:ready (base: Processor.class)
--    const this = self :: class
--
--end

function class:process(base: Processor.class, delta_time: number)
	const this: class = self
	const pvinstance = this.get_instance() :: PVInstance
	const old_pivot: CFrame = pvinstance:GetPivot()
	const old_pos: Vector3 = old_pivot.Position
	const old_rot: CFrame = old_pivot.Rotation

	local new_pivot = private.process_transform(this, old_pos, old_rot)

	if this.smooth then
		new_pivot = old_pivot:Lerp(new_pivot, delta_time)
	end

	pvinstance:PivotTo(new_pivot)
	class.processed_pivot = new_pivot
end

function private.pursue_attention_pos(this: class, pos: Vector3, delta_time: number): Vector3
	return this.smooth and this.attention_transform.Position:Lerp(pos, delta_time) or pos
end

function private.pursue_attention_rot(this: class, rot: CFrame, delta_time: number): CFrame
	return this.smooth and this.attention_transform.Rotation:Lerp(rot, delta_time) or rot
end

@native
function private.process_transform(this: class, old_pos: Vector3, old_rot: CFrame): CFrame
	const pos_x: number = this.lock_px and this.lock_px_to or old_pos.X
	const pos_y: number = this.lock_py and this.lock_py_to or old_pos.Y
	const pos_z: number = this.lock_pz and this.lock_pz_to or old_pos.Z
	const rot_x: Vector3 = this.lock_rx and this.lock_rx_to or old_rot.XVector
	const rot_y: Vector3 = this.lock_ry and this.lock_ry_to or old_rot.YVector
	const rot_z: Vector3 = this.lock_rz and this.lock_rz_to or old_rot.ZVector
	return CFrame.fromMatrix(Vector3.new(pos_x, pos_y, pos_z), rot_x, rot_y, rot_z)
end

function class:lock_at_current_pos()
	const this = self :: class
	const pvinstance = this.get_instance() :: PVInstance
	const pivot = pvinstance:GetPivot()

	this.lock_pz_to = pivot.Position.Z
	this.lock_py_to = pivot.Position.Y
	this.lock_px_to = pivot.Position.X

	this.lock_py = true
	this.lock_pz = true
	this.lock_px = true
end

function class:swap_lock()
	const this = self :: class
	this:swap_lock_pos_xyz()
	this:swap_lock_rot()
end

function class:swap_lock_pos_xyz()
	const this = self :: class
	this.lock_px = not this.lock_px
	this.lock_py = not this.lock_py
	this.lock_pz = not this.lock_pz
end

function class:swap_lock_rot()
	const this = self :: class
	this.lock_rx = not this.lock_rx
	this.lock_ry = not this.lock_ry
	this.lock_rz = not this.lock_rz
end

function class:lock_at_current_rot()
	const this = self :: class
	const pvinstance = this.get_instance() :: PVInstance
	const pivot = pvinstance:GetPivot()

	this.lock_rz_to = pivot.Rotation.ZVector
	this.lock_ry_to = pivot.Rotation.YVector
	this.lock_rx_to = pivot.Rotation.XVector

	this:swap_lock_rot()
end

function class:lock_at_current_z_rot()
	const this = self :: class
	const pvinstance = this.get_instance() :: PVInstance
	const pivot = pvinstance:GetPivot()

	this.lock_rz_to = pivot.Rotation.ZVector
	this.lock_rz = true
end

function class:lock_at_current_y_rot()
	const this = self :: class
	const pvinstance = this.get_instance() :: PVInstance
	const pivot = pvinstance:GetPivot()

	this.lock_ry_to = pivot.Rotation.YVector
	this.lock_ry = true
end

function class:lock_at_current_x_rot()
	const this = self :: class
	const pvinstance = this.get_instance() :: PVInstance
	const pivot = pvinstance:GetPivot()

	this.lock_rx_to = pivot.Rotation.XVector
	this.lock_rx = true
end

function class:lock_at_current_x_pos()
	const this = self :: class
	const pvinstance = this.get_instance() :: PVInstance
	const pivot = pvinstance:GetPivot()

	this.lock_px_to = pivot.Position.X
	this.lock_px = true
end

function class:lock_at_current_y_pos()
	const this = self :: class
	const pvinstance = this.get_instance() :: PVInstance
	const pivot = pvinstance:GetPivot()

	this.lock_py_to = pivot.Position.Y
	this.lock_py = true
end

function class:lock_at_current_z_pos()
	const this = self :: class
	const pvinstance = this.get_instance() :: PVInstance
	const pivot = pvinstance:GetPivot()

	this.lock_pz_to = pivot.Position.Z
	this.lock_pz = true
end

table.freeze(class)
return class
