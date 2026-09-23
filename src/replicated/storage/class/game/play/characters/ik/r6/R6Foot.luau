--!strict
const Reference = require("@game/ReplicatedStorage/class/common/Reference")
const StateMachine = require("@game/ReplicatedStorage/class/common/StateMachine")
const Maybe = require("@game/ReplicatedStorage/class/common/gc/Maybe")
const Disposable = require("@game/ReplicatedStorage/class/core/Disposable")
const Converter = require("@game/ReplicatedStorage/class/service/Converter")
const SecurityRNG = require("@game/ReplicatedStorage/class/service/SecurityRNG")
const LegInfo = require("@game/ReplicatedStorage/class/struct/game/LegInfo")
const Basis = require("@game/ReplicatedStorage/class/struct/geometry/Basis")
const ConnectionVariant = require("@game/ReplicatedStorage/enums/descriptor/ConnectionVariant")
const ReferenceNotification = require("@game/ReplicatedStorage/enums/notification/ReferenceNotification")
const project = require("@game/ReplicatedStorage/static/project")

const private = {}
const class : r6foot = Disposable:new {
    type = "r6foot",

    current = false,
    enabled = false,
    fallback = false,
    from = vector.zero,
    up_direction = vector.zero,
    lateral_position = vector.zero,
    hit_position = vector.zero,
    hit_normal = vector.zero,
    accumulated_distance = 0,
    target = Basis,
    fallback_basis = Basis,
    current_leg_basis = Basis,

    is_visible = function (self: r6foot) : boolean
        return private.get_visible(self)
    end,

    is_settle_finished = function (self: r6foot) : boolean
        const fake_leg = self:get_fake_leg():get_instance()
        const current_up = Converter:to_vector(fake_leg.CFrame.UpVector)
        const target_up = self.target.rotation.up
        const up_dot = math.clamp(vector.dot(current_up, target_up), -1, 1)

        return math.acos(up_dot) <= self:get_info().foot_settle_angle
    end,

    is_step_finished = function (self: r6foot) : boolean
        const fake_leg = self:get_fake_leg():get_instance()
        const position_delta = self.target.position - Converter:to_vector(fake_leg.Position)
        if vector.magnitude(position_delta) > 0.05 then return false end

        const current_up = Converter:to_vector(fake_leg.CFrame.UpVector)
        const target_up = self.target.rotation.up

        return math.acos(math.clamp(vector.dot(current_up, target_up), -1, 1)) <= math.rad(5)
    end,

    get_target_contact = function (self: r6foot) : vector
        return self.target.position - self.target.rotation.up * (self:get_info().leg_size.y * 0.5)
    end,

    set_visible = function (self: r6foot, to: boolean)  : ()
        self:set(private.visible_key, to)

        if private.maybe_fake_leg:exist(self) then
            const fake_leg_reference = self:get_fake_leg()
            const instance_of_fake_leg = fake_leg_reference:get_instance()

            if project.game.server then
                instance_of_fake_leg.Transparency = .5
            else
                instance_of_fake_leg.LocalTransparencyModifier = .5
            end
        end
    end,

    get_states = function (self: r6foot) : statemachine
        return private.states:enactment(self, StateMachine)
    end,

    is_initiated = function (self: r6foot) : boolean
        return private.maybe_fake_leg:exist(self)
    end,

    get_plant_target = function (self: r6foot) : basis
        const fake_leg = self:get_fake_leg():get_instance()
        const half_height = self:get_info().leg_size.y * 0.5
        const contact = self.hit_position
        const out_point = self.lateral_position
        local up = Converter:to_vector(fake_leg.CFrame.UpVector)

        for _ = 1, 2 do
            const center = contact + up * half_height
            const direction = out_point - center
            const length = vector.magnitude(direction)

            if length <= 1e-5 then
                return self.current_leg_basis
            end

            up = direction / length
        end

        local forward = out_point - self.from

        forward = forward - up * vector.dot(forward, up)

        if vector.magnitude(forward) <= 1e-5 then
            return self.current_leg_basis
        end

        forward = vector.normalize(forward)

        const right = vector.normalize(vector.cross(forward, up))
        const front = vector.normalize(vector.cross(up, right))
        const center = contact + up * half_height
        const out = Basis:from_matrix(center, right, up, front)

        return out
    end,

    get_knee_pos = function (self: r6foot, with_move_direction: vector, with_face_direction: vector) : vector
        const leg = self.hit_position - self.lateral_position
        const distance = vector.magnitude(leg)

        if distance <= 1e-5 then
            return self.lateral_position
        end

        const leg_dir = vector.normalize(leg)
        const move_flat = vector.create(with_move_direction.x, 0, with_move_direction.z)
        const facing_flat = vector.create(with_face_direction.x, 0, with_face_direction.z)

        const has_move = vector.magnitude(move_flat) > 1e-5

        const desired = if has_move
            then vector.normalize(move_flat)
            else if vector.magnitude(facing_flat) > 1e-5 then vector.normalize(facing_flat) else vector.zero

        const pole = desired - leg_dir * vector.dot(desired, leg_dir)
        const pole_dir = if vector.magnitude(pole) > 1e-5 then vector.normalize(pole) else vector.zero
        const blended_up = vector.lerp(self.up_direction, self.hit_normal, 0.2)
        const bend_up = if vector.magnitude(blended_up) > 1e-5 then vector.normalize(blended_up) else vector.normalize(self.up_direction)
        
        const midpoint = self.lateral_position + leg * 0.5
        const half = distance * 0.5
        const pole_length = if has_move then half else distance * 0.1

        return midpoint + pole_dir * pole_length + bend_up * half
    end,

    get_foot_facing = function (self: r6foot, with_move_direction: vector, with_main_look_direction: vector?) : vector
        if vector.magnitude(with_move_direction) <= 1e-5 then
            return with_main_look_direction or with_move_direction
        end

        const move = vector.normalize(with_move_direction)
        const facing = vector.normalize(with_main_look_direction or with_move_direction)

        if vector.dot(move, facing) < self:get_info().leg_rotation_inverse_coefficient then
            return facing
        end

        return move
    end,

    get_leg_basis = function (self: r6foot, coordinate: basis, knee: vector, with_main_look_direction: vector) : basis
        const knee_local = coordinate:point_to_local(knee)
    	const foot_local = coordinate:point_to_local(self.hit_position)
        const direction = knee_local - foot_local
        const length = vector.magnitude(direction)

        if length <= 1e-5 then
            return self.current_leg_basis
        end

        const up_direction = direction / length
        const facing_local = coordinate:direction_to_local(with_main_look_direction)
        const info = self:get_info()

        const torso_fwd_local = vector.create(0, 0, -1)
        const blended_fwd = vector.normalize(vector.lerp(facing_local, torso_fwd_local, info.step_use_torso_alpha))
        local forward = blended_fwd - up_direction * vector.dot(blended_fwd, up_direction)

        if vector.magnitude(forward) <= 1e-5 then
            const fallback = vector.create(1, 0, 0)

            forward = fallback - up_direction * vector.dot(fallback, up_direction)

            if vector.magnitude(forward) <= 1e-5 then
                return self.current_leg_basis
            end
        end

        forward = vector.normalize(forward)

        const right = vector.normalize(vector.cross(forward, up_direction))
        const front = vector.normalize(vector.cross(up_direction, right))
        const center = foot_local + up_direction * (info.leg_size.y * 0.5)
        const local_coordinate = Basis:from_matrix(center, right, up_direction, front)
        const output = coordinate:multiple_basis(local_coordinate)

        self.current_leg_basis = output
        return output
    end,

    get_info = function (self: r6foot) : leginfo
        return self:get <<leginfo>> (private.info_key)
    end,

    set_info = function (self: r6foot, new: leginfo): ()
        self:set(private.info_key, new)
    end,

    get_reference = function (self: r6foot) : reference<BasePart>
        return private.maybe_origin:enactment(self, Reference)
    end,

    get_fake_leg = function (self: r6foot) : reference<BasePart>
        return private.maybe_fake_leg:extract(self, function()
            const reference = Reference:new()
            const info = self:get_info()
            const reference_of_origin = self:get_reference()

            local new: BasePart

            if info.leg_create_origin_clone then
                if reference_of_origin:is_instance_exists() then
                    new = reference_of_origin:get_instance():Clone()
                else
                    new = Instance.new "Part"
                    new.Size = Converter:to_vector3(info.leg_size)
                end
            else
                new = Instance.new "Part"
                new.Size = Converter:to_vector3(info.leg_size)
            end

            new.CFrame = reference_of_origin:get_instance().CFrame

            const prepare_fake_elements: {Instance} = table.freeze {new, unpack(new:GetDescendants())}
            const baseparts_list: {BasePart} = {}

            for _, v in prepare_fake_elements do
                if v:IsA("BasePart") then
                    v.CanCollide = false
                    v.CanQuery = false
                    v.Anchored = true
                    v.Massless = true
                    v.Name = v.Name .. "_R6Foot_visual_part"
                    v.Archivable = false
                    v.CanTouch = false
                    v.AudioCanCollide = false
                    
                    if v ~= new and not v:FindFirstAncestorOfClass("WeldConstraint") then
                        const weld_constraint_to_connect_with_fake_root = Instance.new "WeldConstraint"
                        weld_constraint_to_connect_with_fake_root.Name = "R6Foot_visual_part_root_connector_constraint"
                        weld_constraint_to_connect_with_fake_root.Part0 = new
                        weld_constraint_to_connect_with_fake_root.Part1 = v
                        weld_constraint_to_connect_with_fake_root.Active = true
                        weld_constraint_to_connect_with_fake_root.Parent = v
                    end

                    table.insert(baseparts_list, v)
                end
            end

            local changed_first_transparency = false

            if project.game.server then
                new:GetPropertyChangedSignal("Transparency"):Connect(function(...)
                    local changed_cancelled = false

                    if self:is_visible() and new.Transparency ~= 0 then
                        new.Transparency = 0
                        changed_cancelled = true
                    elseif not self:is_visible() and new.Transparency ~= 1 then
                        new.Transparency = 1
                        changed_cancelled = true
                    end

                    if changed_cancelled then
                        for _, v in baseparts_list do
                            v.LocalTransparencyModifier = new.LocalTransparencyModifier
                        end
                    end
                end)

                if self:is_visible() and new.Transparency ~= 0 then
                    new.Transparency = 0
                    changed_first_transparency = true
                elseif not self:is_visible() and new.Transparency ~= 1 then
                    new.Transparency = 1
                    changed_first_transparency = true
                end
            else
                new:GetPropertyChangedSignal("LocalTransparencyModifier"):Connect(function(...)
                    local changed_cancelled = false

                    if self:is_visible() and new.LocalTransparencyModifier ~= 0 then
                        new.LocalTransparencyModifier = 0
                        changed_cancelled = true
                    elseif not self:is_visible() and new.LocalTransparencyModifier ~= 1 then
                        new.LocalTransparencyModifier = 1
                        changed_cancelled = true
                    end

                    if changed_cancelled then
                        for _, v in baseparts_list do
                            v.LocalTransparencyModifier = new.LocalTransparencyModifier
                        end
                    end
                end)

                if self:is_visible() and new.LocalTransparencyModifier ~= 0 then
                    new.LocalTransparencyModifier = 0
                    changed_first_transparency = true
                elseif not self:is_visible() and new.LocalTransparencyModifier ~= 1 then
                    new.LocalTransparencyModifier = 1
                    changed_first_transparency = true
                end
            end

            if changed_first_transparency then
                if project.game.server then
                    for _, v in baseparts_list do
                        v.Transparency = new.Transparency
                    end
                else
                    for _, v in baseparts_list do
                        v.LocalTransparencyModifier = new.LocalTransparencyModifier
                    end
                end
            end

            new.Destroying:Once(function(): ()
                table.clear(baseparts_list)
                self:free()
            end)

            reference:set_instance(new)
            reference:subscribe({ReferenceNotification.ChangedInstance, ReferenceNotification.NullifiedInstance, ReferenceNotification.NewInstance}, ConnectionVariant.Ever, function ()
                if reference:get_instance() ~= new then
                    reference:set_instance(new)
                    project.console_out_error("changing Part instance of R6Foot fake_leg isn't allowed, change aborted")
                end
            end)

            const origin_instance = reference_of_origin:get_instance()
            const origin_basis = Basis:to_basis(origin_instance.CFrame)
            const position, up = Converter:to_vector(origin_instance.Position, origin_instance.CFrame.UpVector)

            self.hit_position = position - up * (info.leg_size.y * 0.5)
            self.target = origin_basis
            self.fallback_basis = origin_basis
            self.current_leg_basis = origin_basis

            new.Parent = origin_instance

            return reference :: reference<BasePart>
        end)
    end
}

class:host(function(new: r6foot): ()
    new:set_info(private.default_info)
    new:watch(private.free_fake_leg)
end)

do
    private.states = Maybe:new() :: maybe<statemachine, r6foot>
    private.info_key = SecurityRNG:get_hash_sha256("r6foot_info_key")
    private.visible_key = SecurityRNG:get_hash_blake3("r6foot_visible_key")
    private.default_info = LegInfo:new()
    private.maybe_origin = Maybe:new() :: maybe<reference<BasePart>, r6foot>
    private.maybe_fake_leg = Maybe:new() :: maybe<reference<BasePart>, r6foot>

    private.free_fake_leg = function (related: disposable)
        const self = related:as <<r6foot>>(class.type)

		if private.maybe_fake_leg:exist(self) then
			const reference = self:get_fake_leg()
			reference:get_instance():Destroy()
		end
    end

    private.get_visible = function (self: r6foot): boolean
        return self:get <<boolean>> (private.visible_key) or false
    end
end

return class