--!strict
const Service = require("@game/ReplicatedStorage/class/arch/Service")
const Channel = require("@game/ReplicatedStorage/class/network/Channel")
const InternalChannelVariant = require("@game/ReplicatedStorage/enums/descriptor/InternalChannelVariant")
const UserDataRequire = require("@game/ReplicatedStorage/enums/require/UserDataRequire")
const declare = require("@game/ReplicatedStorage/static/declare")
const project = require("@game/ReplicatedStorage/static/project")

const private = {}
const class = Service:new({
	ask = function(of: declare.enumitem_user_data_require): unknown
        return private.map[of]()
    end,
})

do
    private.internal = Channel:new() :: declare.channel<declare.enumitem_user_data_require>
    private.internal:set_variant(InternalChannelVariant.UserData)
    private.internal.everyone = true
    private.internal.enabled = true

	private.map = table.freeze({
		[UserDataRequire.Profile] = function()
            project.console_out("profile request")
            
			if not class.enabled then
				return {}
			end

			project.console_out_error("indev")

			return {}
		end,

		[UserDataRequire.Perk] = function()
			if not class.enabled then
				return {}
			end

			project.console_out_error("indev")

			return {}
		end,
		[UserDataRequire.Loadout] = function()
			if not class.enabled then
				return {}
			end

			project.console_out_error("indev")

			return {}
		end,
		[UserDataRequire.Weaponry] = function()
			if not class.enabled then
				return {}
			end

			project.console_out_error("indev")

			return {}
		end,
		[UserDataRequire.Specialization] = function()
			if not class.enabled then
				return {}
			end

			project.console_out_error("indev")

			return {}
		end,
	})

	for i, v in private.map do
		private.internal:set_sync_response(i, v)
	end
end

class:log("active")

return class
