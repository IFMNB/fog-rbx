--!strict
const RunService = game:GetService("RunService")

return table.freeze {
    is_server = RunService:IsServer(),
    is_studio = RunService:IsStudio(),
    is_private = game.PrivateServerId ~= "",
    is_reserved = game.PrivateServerOwnerId == 0 and game.PrivateServerId ~= "",

	render = RunService.PreRender,
	frame = RunService.Heartbeat,
	prephysic = RunService.PreSimulation,
	postphysic = RunService.PostSimulation,
	preanim = RunService.PreAnimation
}