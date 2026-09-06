--!strict
const AssetService = game:GetService("AssetService")
const Observable = require("@game/ReplicatedStorage/class/arch/Observable")
const Notification = require("@game/ReplicatedStorage/class/common/notification/Notification")
const AssetTypeVariant = require("@game/ReplicatedStorage/enums/descriptor/AssetTypeVariant")
const DefaultVariant = require("@game/ReplicatedStorage/enums/descriptor/DefaultVariant")
const State = require("@game/ReplicatedStorage/enums/state/State")
const declare = require("@game/ReplicatedStorage/static/declare")
const project = require("@game/ReplicatedStorage/static/project")

const private = {}
const class: declare.asset = Observable:new({
	type = "asset",
	variant = DefaultVariant.Unknown,
	rid = 0,
	state = State.Nothing,

	get_asset = function(self: declare.asset): any
		self.state = State.Loading
		self:notificate(Notification:new({ on = State.Loading }))

		local loader = private.loaders[self.variant]

		if not loader then
			self.state = State.Failure
			self:notificate(Notification:new({ on = State.Failure }))
			project.console_out_error("unknown AssetVariant")
			return nil
		end

		local ok, result = pcall(loader, self)

		if ok then
			self.state = State.Successful
			self:notificate(Notification:new({ on = State.Successful }))
			return result
		else
			self.state = State.Failure
			self:notificate(Notification:new({ on = State.Failure }))
			project.console_out_error(result)
			return nil
		end
	end,
})

do
	private.loaders = table.freeze({

		[AssetTypeVariant.Model] = function(that: declare.asset): Instance
			return AssetService:LoadAssetAsync(that.rid)
		end,

		[AssetTypeVariant.Sound] = function(that: declare.asset): Sound
			local sound = Instance.new("Sound")
			sound.SoundId = string.format("rbxassetid://%d", that.rid)
			return sound
		end,

		[AssetTypeVariant.Image] = function(that: declare.asset): ImageLabel
			local image = Instance.new("ImageLabel")
			image.Image = string.format("rbxassetid://%d", that.rid)
			return image
		end,
	}) :: { [declare.enumitem]: (declare.asset) -> unknown }
end

return class
