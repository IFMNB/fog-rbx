--!strict
const Reference = require("@game/ReplicatedStorage/class/common/Reference")
const Maybe = require("@game/ReplicatedStorage/class/common/gc/Maybe")
const Disposable = require("@game/ReplicatedStorage/class/core/Disposable")
const R6Foot = require("@game/ReplicatedStorage/class/game/play/characters/ik/r6/R6Foot")
const Converter = require("@game/ReplicatedStorage/class/service/Converter")
const SecurityRNG = require("@game/ReplicatedStorage/class/service/SecurityRNG")
const IKR6Info = require("@game/ReplicatedStorage/class/struct/game/IKR6Info")
const Basis = require("@game/ReplicatedStorage/class/struct/geometry/Basis")
const ConnectionVariant = require("@game/ReplicatedStorage/enums/descriptor/ConnectionVariant")
const OperationVariant = require("@game/ReplicatedStorage/enums/descriptor/OperationVariant")
const ReferenceNotification = require("@game/ReplicatedStorage/enums/notification/ReferenceNotification")
const IKLegsState = require("@game/ReplicatedStorage/enums/state/IKLegsState")
const declare = require("@game/ReplicatedStorage/static/declare")
const project = require("@game/ReplicatedStorage/static/project")

const private = {}
const class : ikr6legs = Disposable:new {
    type = "ikr6legs",
    enabled = false,
    current_idle_time = 0,
    last_work_time = 0,

    get_humanoid = function (self: ikr6legs) : reference<Humanoid?>
        return private.maybe_humanoid:enactment(self, Reference)
    end,

    get_torso = function (self: ikr6legs) : reference<BasePart?>
        return private.maybe_torso:enactment(self, Reference)
    end,

    get_left_leg = function (self: ikr6legs) : r6foot
        return private.maybe_left_legs:enactment(self, R6Foot)
    end,

    get_right_leg = function (self: ikr6legs) : r6foot
        return private.maybe_right_legs:enactment(self, R6Foot)
    end,

    get_info = function (self: ikr6legs) : ikr6info
        return self:get <<ikr6info>> (private.info_key)
    end,

    set_info = function (self: ikr6legs, new: ikr6info): ()
        self:set(private.info_key, new)
    end,

    get_active_cycle_leg_pair = function (self: ikr6legs) : (r6foot, r6foot)
        const left_leg = self:get_left_leg()
        if left_leg.current then 
            return left_leg, self:get_right_leg()
        end

        const right_leg = self:get_right_leg()

        if right_leg.current then
            return right_leg, self:get_left_leg()
        end

        return left_leg, right_leg
    end,

    is_initiated = function (self: ikr6legs) : boolean
        return private.maybe_left_legs:exist(self) and private.maybe_right_legs:exist(self)
    end,

    is_active = function (self: ikr6legs) : boolean
        return private.active[self] or false
    end,

    is_fallback = function (self: ikr6legs) : boolean
        const left_leg, right_leg = self:get_left_leg(), self:get_right_leg()

        if left_leg.fallback and right_leg.fallback then
            return true
        end

        return false
    end
}

do
    type raw = {
        read torso: basis,
        read size: vector,
        read move_dir: vector,
        read linear_vel: vector,
        read horizont_linear_vel: vector,
        read walkspeed: number,
        read speed_factor: number,
        read is_moving: boolean
    }
	private.rayparams = RaycastParams.new()
	private.rayparams.FilterType = Enum.RaycastFilterType.Exclude
	private.rayparams.RespectCanCollide = true
	private.rayparams.BruteForceAllSlow = false
	private.rayparams.IgnoreWater = true
    private.rayparams.ExcludeInstances = {}

    private.default_ikr6info = IKR6Info:new()
    private.info_key = SecurityRNG:get_hash_blake3("ikr6legs_info_key")
    private.list = setmetatable({} :: {ikr6legs}, declare.tables.__mode_vs)
    private.active = setmetatable({} :: {[ikr6legs]: boolean?}, declare.tables.__mode_ks)
    private.maybe_humanoid = Maybe:new() :: maybe<reference<Humanoid?>, ikr6legs>
    private.maybe_torso = Maybe:new() :: maybe<reference<BasePart?>, ikr6legs>
    private.maybe_left_legs = Maybe:new() :: maybe<r6foot, ikr6legs>
    private.maybe_right_legs = Maybe:new() :: maybe<r6foot, ikr6legs>
    private.signal = project.game.signal.postphysic

    private.register_new = function (new: ikr6legs)
        new:set_info(private.default_ikr6info)
        new:watch(private.free_legs)

        const left_leg =  new:get_left_leg()
        const right_leg = new:get_right_leg()

        const left_leg_state_machine = left_leg:get_states()
        const right_leg_state_machine = right_leg:get_states()

        left_leg_state_machine:set_state(true, IKLegsState.Planted)
        right_leg_state_machine:set_state(true, IKLegsState.Planted)

        left_leg.current = true

        private.signal:Once(function ()
            table.insert(private.list, new)
        end)
    end

    private.get_limb_of = function (humanoid: Humanoid, limb: Enum.Limb) : BasePart
        const parent = project.assert(humanoid.Parent, "cannot find parent of humanoid, crit", true) :: Instance
        const model = project.assert(parent:IsA("Model") and parent, "expected humanoid parent as a model, crit", true) :: Model

        for _, v in model:GetChildren() do
            if v:IsA("BasePart") and humanoid:GetLimb(v) == limb then
                return v
            end
        end

        return project.console_out_error(`cannot find limb {limb.Name} in {model:GetFullName()}, crit fail`)
    end

    private.maybe_humanoid:subscribe(OperationVariant.New, ConnectionVariant.Ever, function (ikr6legs: ikr6legs, new_reference: reference<Humanoid?>)
        new_reference:subscribe({ReferenceNotification.NewInstance, ReferenceNotification.ChangedInstance}, ConnectionVariant.Ever, function ()
            const var = new_reference:get_instance() :: Instance
            if var ~= nil and not var:IsA("Humanoid") then
                new_reference:set_instance(nil)
                project.console_out ("no other objects are allowed for this ikr6legs reference to humanoid, aborted")
                return
            elseif var == nil then
                return
            end

            const humanoid = var :: Humanoid

            const left_leg = ikr6legs:get_left_leg()
            if not left_leg:is_initiated() then
                const limb_part = private.get_limb_of(humanoid, Enum.Limb.LeftLeg)
                left_leg:get_reference():set_instance(limb_part)
            end
    
            const right_leg = ikr6legs:get_right_leg()
            if not right_leg:is_initiated() then
                const limb_part = private.get_limb_of(humanoid, Enum.Limb.RightLeg)
                right_leg:get_reference():set_instance(limb_part)
            end

            if project.debug.state then
                if right_leg:is_initiated() or left_leg:is_initiated() then
                    project.console_out("the humanoid changes for the already initialized ikr6legs, the limbs will not change")
                end

                if project.debug.show_ikr6legs_solver_path then
                    project.console_out("new humanoid setup")
                end
            end
        end)
    end)

    do -- global utility layer
        private.modify_params = function (with: Instance): ()
            private.rayparams.ExcludeInstances = {with}
        end

        private.mark_unactive = function (ikr6legs: ikr6legs)
            private.active[ikr6legs] = false
        end
        
        private.create_raw = function (torso: BasePart, humanoid: Humanoid) : raw
            const dir, lin, size = Converter:to_vector(humanoid.MoveDirection, torso.AssemblyLinearVelocity, torso.Size)
            const hor_lin_vel = vector.create(lin.x, 0, lin.z)

            return table.freeze {
                torso = Basis:to_basis(torso.CFrame),
                move_dir = dir,
                linear_vel = lin,
                size = size,
                horizont_linear_vel = hor_lin_vel,
                walkspeed = humanoid.WalkSpeed,
                speed_factor = math.clamp(vector.magnitude(hor_lin_vel) / math.max(humanoid.WalkSpeed, 0.001), 0, 1),
                is_moving = vector.magnitude(dir) >= 0.01
            }
        end

        private.free_legs = function (related: disposable)
            const self = related:as <<ikr6legs>>(class.type)

            table.remove(private.list, table.find(private.list, self) or 0)

            if private.maybe_left_legs:exist(self) then
                self:get_left_leg():free()
            end

            if private.maybe_right_legs:exist(self) then
                self:get_right_leg():free()
            end
        end

    end







    do -- leg world checks layer
        private.raycast = function (origin: vector, direction: vector): RaycastResult?
	        const safe_origin = origin + direction * 0.01
            const a0, a1 = Converter:to_vector3(safe_origin, direction)
	        return workspace:Raycast(a0, a1, private.rayparams)
        end
        
        private.get_step_raycast_data = function (raw: raw, info: leginfo, predicted: vector, state: enumitem_iklegs_state) : (vector, vector)
            const up = raw.torso.rotation.up
            const down = -up

            const move_length = vector.magnitude(raw.move_dir)

            local horizontal_direction: vector

            if move_length > 0.001 then
                horizontal_direction = raw.move_dir / move_length
            else
                horizontal_direction = raw.torso.rotation.front
            end

            const origin = predicted + up * info.raycast_up       
            const forward = if state == IKLegsState.Stepping then info.step_forward elseif state == IKLegsState.Planted then info.stand_forward elseif state == IKLegsState.Settling then info.idle_step_forward else 1     
            const direction = horizontal_direction * forward + down * (info.raycast_up + info.raycast_down)

            return origin, direction
        end

        private.is_step_blocked = function (raw: raw, foot: r6foot, info: leginfo, predicted: vector): boolean
            const move_length = vector.magnitude(raw.move_dir)
            if move_length <= 1e-5 then return false end

            const direction = raw.move_dir / move_length
            const up = raw.torso.rotation.up
            const obstacle_origin = predicted + up * info.step_obstacle_height
            const obstacle = private.raycast(obstacle_origin, direction * info.step_block_distance)
            if not obstacle then return false end

            const normal, position = Converter:to_vector(obstacle.Normal, obstacle.Position)
            if math.abs(vector.dot(normal, up)) > 0.5 then return false end

            const top_origin = position + direction * (info.leg_size.z * 0.5 + 0.05) + up * (info.step_max_height + 0.05)
            const top_result = private.raycast(top_origin, -up * (info.step_max_height + 0.15))
            if not top_result then return true end

            const top_normal, top_position = Converter:to_vector(top_result.Normal, top_result.Position)
            if vector.dot(top_normal, up) < 0.7 then return true end

            const height = vector.dot(top_position - predicted, up)
            return height > info.step_max_height
        end
    end

    do -- leg utility layer
        private.foot_update = function (raw: raw, foot: r6foot, info: leginfo, raycast_result: RaycastResult)
            foot.hit_normal, foot.hit_position = Converter:to_vector(raycast_result.Normal, raycast_result.Position)
            foot.up_direction = raw.torso.rotation.up
            foot.fallback_basis = Basis:to_basis(foot:get_reference():get_instance().CFrame)
        end

        private.update_foot_anchor = function(raw: raw,foot: r6foot, info: leginfo)
            const previous_lateral_position = foot.lateral_position
            foot.from = raw.torso.position
            foot.lateral_position = raw.torso.position + vector.create(0, -raw.size.y / 2, 0) + raw.torso.rotation.right * info.leg_diff
            
            const delta = foot.lateral_position - previous_lateral_position
            const up = raw.torso.rotation.up
            const planar_delta = delta - up * vector.dot(delta, up)
            
            foot.accumulated_distance += vector.magnitude(planar_delta)
        end

        private.should_step = function(raw: raw, foot: r6foot, info: leginfo): boolean
            const contact = foot:get_target_contact()
            const up = raw.torso.rotation.up

            const error_scale = (foot.lateral_position - contact) - up * vector.dot((foot.lateral_position - contact), up)
            const error_distance = vector.magnitude(error_scale)

            return error_distance >= info.step_distance_trigger_at or foot.accumulated_distance >= info.step_distance_trigger_at
        end

        private.get_step_speed = function (raw: raw, info: leginfo): number
            return info.step_speed_min + (info.step_speed_max - info.step_speed_min) *
                math.clamp(
                    (vector.magnitude(raw.horizont_linear_vel) - info.step_velocity_min) / -- speed
                    math.max(info.step_velocity_max - info.step_velocity_min, 0.001), -- factor
                    0, 1
                )
        end

        private.get_settle_speed = function (raw: raw, info: leginfo) : number
            return info.settle_speed_min + (info.settle_speed_max - info.settle_speed_min) * raw.speed_factor
        end
    end

    do -- leg placement layer
        private.step = function (raw: raw, foot: r6foot, info: leginfo, override: enumitem_iklegs_state?): (basis?, boolean)
            const prediction_factor = raw.speed_factor ^ info.leg_prediction_curve
            const prediction_time = info.leg_prediction_time_min + (info.leg_prediction_time_max - info.leg_prediction_time_min) * prediction_factor
            const predicted_bottom = foot.lateral_position + raw.horizont_linear_vel * prediction_time

            if private.is_step_blocked(raw, foot, info, predicted_bottom) then
                return nil, true
            end

            const raycast_origin, raycast_direction = private.get_step_raycast_data(raw, info, predicted_bottom, override or IKLegsState.Stepping)
            const raycast_result = private.raycast(raycast_origin, raycast_direction)
            if not raycast_result then
                foot.fallback = true
                return nil, false
            else
                foot.fallback = false
            end

            private.foot_update(raw, foot, info, raycast_result)

            const face = foot:get_foot_facing(raw.move_dir,raw.torso.rotation.front)
            const knee = foot:get_knee_pos(face,raw.torso.rotation.front)

            return foot:get_leg_basis(raw.torso, knee, face), false
        end

        private.stand = function (raw: raw, foot: r6foot, info: leginfo, override: enumitem_iklegs_state?) : basis?
            const raycast_origin, raycast_direction = private.get_step_raycast_data(raw, info, foot.lateral_position, override or IKLegsState.Planted)
            const raycast_result = private.raycast(raycast_origin, raycast_direction)
            if not raycast_result then return nil end

            private.foot_update(raw, foot, info, raycast_result)

            const knee = foot:get_knee_pos(vector.zero, raw.torso.rotation.front)
            const foot_facing_direction = foot:get_foot_facing(vector.zero, raw.torso.rotation.front)
            const leg_placement = foot:get_leg_basis(raw.torso, knee, foot_facing_direction)

            return leg_placement
        end
    end


    do -- solver utility layer

        private.solver_begin_step = function (foot: r6foot, new_target: basis, info: leginfo)
            foot.fallback = false
            foot.target = new_target
            foot.hit_position = new_target.position - new_target.rotation.up * (info.leg_size.y * 0.5)

            const foot_state_machine = foot:get_states()
            foot_state_machine:set_state(false, IKLegsState.Planted, IKLegsState.Settling)
            foot_state_machine:set_state(true, IKLegsState.Stepping)
        end
                
        private.solver_begin_idle_step = function (raw: raw, ikr6: ikr6legs) : boolean
            const active, other = ikr6:get_active_cycle_leg_pair()
            const active_state_machine = active:get_states()

            if not active_state_machine:get_state(IKLegsState.Planted) then
                return false
            end

            const info = other:get_info()
            const target_basis = private.stand(raw, other, info, IKLegsState.Settling)
            if not target_basis then return false end

            private.solver_begin_step(other, target_basis, info)
            active.current = false
            other.current = true

            return true
        end

        private.solver_begin_leg_fallback = function (r6foot: r6foot) : ()
            r6foot.fallback = true

            const origin = r6foot:get_reference():get_instance()
            const fallback = origin.CFrame
            const fallback_basis = Basis:to_basis(fallback)

            const state_machine = r6foot:get_states()

            r6foot.fallback_basis = fallback_basis
            r6foot.target = fallback_basis
            r6foot.hit_position = r6foot:get_target_contact()
            r6foot.hit_normal = fallback_basis.rotation.up

            r6foot:get_fake_leg():get_instance().CFrame = fallback

            state_machine:set_state(false, IKLegsState.Settling, IKLegsState.Stepping)
            state_machine:set_state(true, IKLegsState.Planted)
        end

        private.solver_begin_fallback = function (ikr6legs: ikr6legs)
            const left_leg, right_leg = ikr6legs:get_left_leg(), ikr6legs:get_right_leg()

            if left_leg.fallback then
                private.solver_begin_leg_fallback(left_leg)
            end

            if right_leg.fallback then
                private.solver_begin_leg_fallback(right_leg)
            end
        end

        private.solver_leg_fallback = function (r6foot: r6foot) : ()
            const origin = r6foot:get_reference():get_instance()
            const fallback = origin.CFrame
            const fallback_basis = Basis:to_basis(fallback)

            const state_machine = r6foot:get_states()
            const fake_leg = r6foot:get_fake_leg():get_instance()

            state_machine:set_state(false, IKLegsState.Settling, IKLegsState.Stepping)
            state_machine:set_state(true, IKLegsState.Planted)

            r6foot.fallback_basis = fallback_basis
            r6foot.target = fallback_basis
            r6foot.hit_position = r6foot:get_target_contact()

            fake_leg.CFrame = fallback
        end

        private.solver_fallback = function (ikr6legs: ikr6legs) : ()
            if project.debug.state and	project.debug.show_ikr6legs_solver_path then
                project.console_out "solver fallback"
            end

            for _, r6foot in {ikr6legs:get_left_leg(), ikr6legs:get_right_leg()} do
                private.solver_leg_fallback(r6foot)
            end
        end

        private.solver_foot_stepping = function (raw: raw, r6foot: r6foot, info: leginfo, fake_leg: BasePart, delta: number)
            const alpha = 1 - math.exp(-private.get_step_speed(raw, info) * delta)

            const current = Basis:to_basis(fake_leg.CFrame)
            const target = r6foot.target
            const next_basis = current:slerp(target, alpha)
            const offset = target.position - next_basis.position
            const horizontal = vector.create(offset.x, 0, offset.z)
            const distance = vector.magnitude(horizontal)
            const lift = math.min(distance, 1)
            const position = vector.create(next_basis.position.x, target.position.y + lift, next_basis.position.z)
            const new_basis = next_basis:clone({position = position})
            fake_leg.CFrame = Basis:to_cframe(new_basis)

            return
        end

        private.solver_foot_settling = function (raw: raw, r6foot: r6foot, info: leginfo, fake_leg: BasePart, delta: number)
            fake_leg.CFrame = fake_leg.CFrame:Lerp(Basis:to_cframe(r6foot.target), 1 - math.exp(-private.get_settle_speed(raw, info) * delta))
            return
        end

        private.solver_foot = function (raw: raw, ikr6legs: ikr6legs, delta: number)
            if project.debug.state and	project.debug.show_ikr6legs_solver_path then
                project.console_out "foots"
            end

            for _, r6foot in {ikr6legs:get_left_leg(), ikr6legs:get_right_leg()} do
                if not r6foot.enabled then continue end

                const info = r6foot:get_info()
                const state_machine = r6foot:get_states()
                const fake_leg = r6foot:get_fake_leg():get_instance()

                private.update_foot_anchor(raw, r6foot, info)

                if state_machine:get_state(IKLegsState.Stepping) then
                    private.solver_foot_stepping(raw, r6foot, info, fake_leg, delta)
                    
                    if r6foot:is_step_finished() then
                        state_machine:set_state(false, IKLegsState.Stepping)
                        state_machine:set_state(true, IKLegsState.Settling)
                    end

                    continue
                end

                if r6foot.fallback then
                    private.solver_leg_fallback(r6foot)
                    continue
                end

                r6foot.target = r6foot:get_plant_target()

                if state_machine:get_state(IKLegsState.Settling) then
                    private.solver_foot_settling(raw, r6foot, info, fake_leg, delta)

                    if r6foot:is_settle_finished() then
                        state_machine:set_state(false, IKLegsState.Settling, IKLegsState.Stepping)
                        state_machine:set_state(true, IKLegsState.Planted)

                        r6foot.accumulated_distance = 0
                    end

                    continue
                end

                fake_leg.CFrame = fake_leg.CFrame:Lerp(Basis:to_cframe(r6foot.target), 1 - math.exp(-info.planted_speed * delta))
            end
        end
    end

    private.solver_to_idle = function (raw: raw, r6foot: r6foot)
        if project.debug.state and	project.debug.show_ikr6legs_solver_path then
            project.console_out "move to idle"
        end

        const state_machine = r6foot:get_states()
        const info = r6foot:get_info()

        if state_machine:get_state(IKLegsState.Planted) then
            const target = private.stand(raw, r6foot, info, IKLegsState.Planted)

            if target then
                r6foot.target = target
                r6foot.hit_position = r6foot:get_target_contact()
            end
        end
    end

    private.world_solver  = function (delta: number)
        if project.debug.state and	project.debug.show_ikr6legs_solver_path then
            project.console_out ("world solver with ikr6legs list:", #private.list )
        end

        -- '__mode = "s"` gives the GC the right to reduce the size of the table,
        -- but this may cause optimization failures, so we cannot table.clear(private.active)
        for i, _ in private.active do
            private.active[i] = false
        end

        for _, ik in private.list do
            if not ik.enabled then
                private.mark_unactive(ik)

                if project.debug.state and	project.debug.show_ikr6legs_solver_path then
                    project.console_out "world solver unable"
                end

                continue
            end

            const info = ik:get_info()

            if info.ignore_hertz_limit then
                private.solver(ik, info, delta)
                continue
            end

            const hertz = math.max(info.update_hertz, 0.00001)
            const interval = 1 / hertz

            ik.last_work_time += delta
            if ik.last_work_time >= interval then
                const work_delta = ik.last_work_time
                ik.last_work_time -= interval

                private.solver(ik, info, work_delta)
            else
                if project.debug.state and	project.debug.show_ikr6legs_solver_path then
                    project.console_out "world solver skip"
                end
            end
        end
    end

    private.solver = function (ik: ikr6legs, info: ikr6info, delta: number)
        if project.debug.state and project.debug.show_ikr6legs_solver_path then
            project.console_out(`solver ({ik:iden()})`)
        end

        const reference_to_humanoid = ik:get_humanoid()
        const humanoid = reference_to_humanoid:get_instance()
        if humanoid == nil then 
            private.mark_unactive(ik)

            if project.debug.state then
                project.console_out_error('this solver has no humanoid, skip')
            end

            return
        end

        const torso = ik:get_torso():get_instance()
        if torso == nil then
            private.mark_unactive(ik) 

            if project.debug.state then
                project.console_out_error('this solver has no torso, skip')
            end

            return
        end

        private.active[ik] = true
        private.modify_params(torso.Parent or torso)
        const raw = private.create_raw(torso, humanoid)

        
        ik.current_idle_time = if raw.is_moving then 0 else ik.current_idle_time + delta
        if ik:is_fallback() then
            private.solver_fallback(ik)
        else
            private.solver_foot(raw, ik, delta)
        end

        if not raw.is_moving and ik.current_idle_time >= info.idle_time then
            private.solver_to_idle(raw, ik:get_left_leg())
            private.solver_to_idle(raw, ik:get_right_leg())
        end

        const active, other = ik:get_active_cycle_leg_pair()
        if not active:get_states():get_state(IKLegsState.Planted) then return end
        const other_info = other:get_info()
        if not private.should_step(raw, other, other_info) then return end
        const target, blocked = private.step(raw, other, other_info)
        
        if blocked then
            private.solver_begin_idle_step(raw, ik) 
            return
        end

        if not target then
            if private.solver_begin_idle_step(raw, ik) then
                return
            end

            private.solver_begin_leg_fallback(other)
            return
        else
            private.solver_begin_step(other, target, other_info)
        end

        active.current = false
        other.current = true
    end

    private.signal:Connect(private.world_solver)
    
    if project.debug.state and project.debug.register_ikr6legs_self then
        project.console_out "class ikr6legs registered in work cycle"
        private.register_new(class)
    end
end

class:host(private.register_new)

return class