--!strict
const AssetService = game:GetService("AssetService")
const Notification = require("@game/ReplicatedStorage/code/class/common/Notification")
const AssetStateVariant = require("@game/ReplicatedStorage/code/enums/descriptor/AssetStateVariant")
const AssetRequireNotificationVariant = require("@game/ReplicatedStorage/code/enums/notifications/AssetRequireNotificationVariant")
const AssetVariant = require("@game/ReplicatedStorage/code/enums/required/AssetVariant")
const runtimeobject = require("@game/ReplicatedStorage/code/runtimeobject")
const declare = require("@game/ReplicatedStorage/code/static/declare")
const namefield = require("@game/ReplicatedStorage/code/static/namefield")
const project = require("@game/ReplicatedStorage/code/static/project")

const private = {}
const class: declare.asset = runtimeobject:new({
	type = namefield.asset,
	variant = AssetVariant.Unknown,
	rid = 0,
	state = AssetStateVariant.Never,

	get_asset = function(self: declare.asset): any
        if self.state ~= AssetStateVariant.Never then 
            self.state = AssetStateVariant.Reload
        end

        local loader = private.loaders[self.variant]

        if not loader then
            self.state = AssetStateVariant.Unknown
            project.console_out_error("unknown AssetVariant")
            return nil
        end

        self.state = AssetStateVariant.Making
	    self:notificate(Notification:new({ call_on = AssetRequireNotificationVariant.Loading }))
        local ok, result = pcall(loader, self)

        if ok then
            self.state = AssetStateVariant.Loaded
            self:notificate(Notification:new {call_on = AssetRequireNotificationVariant.Successful, pack = {result}})
            return result
        else
            self.state = AssetStateVariant.Fail
    		self:notificate(Notification:new({ call_on = AssetRequireNotificationVariant.Failure, pack = { result } }))
            project.console_out_error(result)
            return nil
        end
    end,
})

do
	private.loaders = table.freeze({

		[AssetVariant.Model] = function(that: declare.asset): Instance
			return AssetService:LoadAssetAsync(that.rid)
		end,

		[AssetVariant.Sound] = function(that: declare.asset): Sound
			local sound = Instance.new("Sound")
			sound.SoundId = string.format("rbxassetid://%d", that.rid)
			return sound
		end,

		[AssetVariant.Image] = function(that: declare.asset): ImageLabel
			local image = Instance.new("ImageLabel")
			image.Image = string.format("rbxassetid://%d", that.rid)
			return image
		end,
	}) :: { [declare.enumitem]: (declare.asset) -> unknown }
end

return class
