--!strict
const Struct = require("@game/ReplicatedStorage/class/core/Struct")

const class: leginfo = Struct:new({
	type = "leginfo",
	step_use_torso_alpha = 0,

	step_block_distance = 0.45,
	step_max_height = 0.65,
	step_obstacle_height = 0.12,

	step_speed_min = 5,
	step_speed_max = 80,

	step_velocity_min = 0,
	step_velocity_max = 32,

	settle_speed_min = 10,
	settle_speed_max = 150,

	planted_speed = 50,

	leg_follow_speed = 15,
	leg_rotation_inverse_coefficient = 0.5,

	leg_prediction_time_min = 0.01,
	leg_prediction_time_max = 0.1,
	leg_prediction_curve = 1.1,

	step_forward = 0.1,
	stand_forward = 0.1,
	idle_step_forward = 0,
	idle_time = 0.35,

	foot_settle_angle = math.rad(2),
})

return class