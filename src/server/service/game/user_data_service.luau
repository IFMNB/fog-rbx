--!strict
const Service = require("@game/ReplicatedStorage/class/arch/Service")
const Channel = require("@game/ReplicatedStorage/class/network/Channel")
const InternalChannelVariant = require("@game/ReplicatedStorage/enums/descriptor/InternalChannelVariant")
const UserDataRequire = require("@game/ReplicatedStorage/enums/require/UserDataRequire")
const declare = require("@game/ReplicatedStorage/static/declare")
const project = require("@game/ReplicatedStorage/static/project")
const SoulRequire = require("@game/ServerStorage/enums/require/SoulRequire")
const dgame = require("@game/ReplicatedStorage/static/dgame")

const private = {}
const class = Service:new({
	ask = function(of: declare.enumitem_user_data_require): unknown
		return private.map[of]()
	end,
})

do
	private.internal = Channel:new() :: declare.channel<declare.enumitem_user_data_require|dgame.enumitem_soul_require>
	private.internal:set_variant(InternalChannelVariant.UserData)
	private.internal.everyone = true

	private.map = table.freeze({
		[UserDataRequire.Profile] = function()
			project.console_out("profile request")

			if not class.enabled then
				return {}
			end

			project.console_out_error("indev")

			return {}
		end,

		[UserDataRequire.Stats] = function()
			if not class.enabled then
				return {}
			end

			project.console_out_error("upsupported item")

			return {}
		end,
		[SoulRequire.ArmorStat] = function()
			if not class.enabled then
				return {}
			end

			project.console_out_error("indev")

			return {}
		end,
		[SoulRequire.ArmoryOpened] = function()
			if not class.enabled then
				return {}
			end

			project.console_out_error("indev")

			return {}
		end,
		[SoulRequire.WeaponStat] = function()
			if not class.enabled then
				return {}
			end

			project.console_out_error("indev")

			return {}
		end,
		[SoulRequire.LoadClass] = function()
			if not class.enabled then
				return {}
			end

			project.console_out_error("indev")

			return {}
		end,

		[SoulRequire.LoadOut] = function()
			if not class.enabled then
				return {}
			end

			project.console_out_error("indev")

			return {}
		end,

		[SoulRequire.Misc] = function()
			if not class.enabled then
				return {}
			end

			project.console_out_error("indev")

			return {}
		end,

		[SoulRequire.WeaponryOpened] = function()
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

	private.internal.enabled = true
end

return class
