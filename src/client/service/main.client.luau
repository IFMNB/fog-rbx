const Players = game:GetService("Players")

const IKR6Legs = require("@game/ReplicatedStorage/class/game/play/characters/ik/r6/IKR6Legs")
const LegInfo = require("@game/ReplicatedStorage/class/struct/game/LegInfo")





const function character_added (model: Model)
	const ik = IKR6Legs:new()

	const ref_humanoid = ik:get_humanoid()
	const ref_torso = ik:get_torso()

	ref_humanoid:set_instance(model:FindFirstChildOfClass("Humanoid"))
	ref_torso:set_instance(model:FindFirstChild("Torso"))

	const left_leg = ik:get_left_leg()
	const right_leg = ik:get_right_leg()

	const left_leg_info = LegInfo:new({
		leg_diff = -LegInfo.leg_diff,
	})

	const right_leg_info = LegInfo:new()

	left_leg:set_info(left_leg_info)
	right_leg:set_info(right_leg_info)
	left_leg:set_visible(true)
	right_leg:set_visible(true)

	left_leg.enabled = true
	right_leg.enabled = true
	ik.enabled = true
end

const function player_added (player: Player)
    if player.Character then
        character_added(player.Character)
    end

    player.CharacterAdded:Connect(character_added)
end

--Players.PlayerAdded:Connect(player_added)