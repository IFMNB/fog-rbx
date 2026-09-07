--!strict
const Players = game:GetService("Players")

const Reference = require("@game/ReplicatedStorage/class/common/Reference")
const Maybe = require("@game/ReplicatedStorage/class/common/gc/Maybe")
const UserConfig = require("@game/ReplicatedStorage/class/local/UserConfig")
const InternalChannelVariant = require("@game/ReplicatedStorage/enums/descriptor/InternalChannelVariant")
const object = require("@game/ReplicatedStorage/object")
const declare = require("@game/ReplicatedStorage/static/declare")

const UserData = require("@game/ReplicatedStorage/struct/common/UserData")

const private = {}
const class: declare.user = object:new({
	type = "user",
	uid = 0,

	request_data = function<T...>(self: declare.user, of: declare.enumitem_user_data_require): any
		const channel = private.get_channel()
		const state, out = pcall(function()
			return (channel:sync(of) :: { [any]: any })[self]()
		end)

		const userdata = UserData:new({ state = state, result = { out }, of = of })
		return userdata
	end,

	get_local_user = function(): declare.user
		return private.local_user
	end,

	get_player = function(self: declare.user): declare.reference<Player?>
		const player = Players:GetPlayerByUserId(self.uid)
		const reference = Reference:new() :: declare.reference<Player?>
		reference:set_instance(player)

		return reference
	end,

	get_config = function(self: declare.user): declare.userconfig
		return private.configs:extract(self, function()
			return UserConfig:new()
		end)
	end,
})

do
	type user_uid = unknown
	type channel_signletone = declare.channel<declare.enumitem_user_data_require>

	private.meta = table.freeze({ __mode = "ks" })
	private.configs = Maybe:new() -- userconfig
	private.local_user = class:new({ { uid = Players.LocalPlayer and Players.LocalPlayer.User.Id or 0 } })
	private.channel = nil :: channel_signletone?

	private.get_channel = function(): channel_signletone
		if private.channel then
			return private.channel
		else
			const channel = (
					require("@game/ReplicatedStorage/class/network/Channel") :: declare.channel
				):new() :: channel_signletone
			private.channel = channel

			channel:set_variant(InternalChannelVariant.UserData)
			channel.everyone = true
			channel.enabled = true

			return channel
		end
	end
end

return class
