--!strict
const UserInputService = game:GetService("UserInputService")
const Observable = require("@game/ReplicatedStorage/class/arch/Observable")
const Channel = require("@game/ReplicatedStorage/class/network/Channel")
const ConnectionVariant = require("@game/ReplicatedStorage/enums/descriptor/ConnectionVariant")
const DisposableNotification = require("@game/ReplicatedStorage/enums/notification/DisposableNotification")
const InputNotification = require("@game/ReplicatedStorage/enums/notification/InputNotification")
const declare = require("@game/ReplicatedStorage/static/declare")

const project = require("@game/ReplicatedStorage/static/project")

const private = {}
const class: declare.input = Observable:new({
	type = "input",
	clamped = false,
	pressed = false,
	duration = 0.5,
	network = false,
	enabled = true,

	get_code = function(self: declare.input): { Enum.KeyCode }
		return table.clone(private.codes[self])
	end,

	set_code = function(self: declare.input, of: Enum.KeyCode, to: boolean?): ()
		const codes = private.codes[self]
		const pos = table.find(codes, of)

		if pos then
			if to then
				return
			end
			table.remove(codes, pos)
			self:notificate(InputNotification.CodeRemoved)
		else
			if not to then
				return
			end
			table.insert(codes, of)
			self:notificate(InputNotification.CodeAdded)
		end
	end,

	get_related = function(self: declare.input): declare.enumitem_action_map_variant?
		return private.related[self]
	end,

	set_related = function(self: declare.input, new: declare.enumitem_action_map_variant?): ()
		private.related[self] = new
		if new then
			self:notificate(InputNotification.RelatedChanged)
		else
			self:notificate(InputNotification.RelatedNullified)
		end
	end,

	invoke = function(self: declare.input): ()
		if not self:is_network_active() then
			project.console_out("input isn't enabled, network invoke aborted")
			return
		end

		const related = self:get_related()
		if related then
			private.channels[self]:send(related, self.pressed, self.clamped)
		else
			project.console_out("cannot send input event, related does not exists")
		end
	end,

	set_network = function(self: declare.input, to: boolean): ()
		const prev = private.net_active[self]
		private.net_active[self] = to
		if not to then
			if prev == to or not prev then
				return
			end
			self:notificate(InputNotification.NetworkDisabled)
		else
			if prev == to then
				return
			end
			self:notificate(InputNotification.NetworkEnabled)
		end
	end,

	is_network_active = function(self: declare.input): boolean
		return private.net_active[self] or false
	end,
})

class:host(function(new: declare.input)
	const channel = Channel:new()
	channel.everyone = true

	private.codes[new] = {}
	private.channels[new] = channel
	private.invoke_at[new] = 0

	table.insert(private.inputs, new)

	new:subscribe(InputNotification.RelatedChanged, ConnectionVariant.Ever, function()
		if not new:is_network_active() then
			return
		end

		channel:set_variant(new:get_related() :: declare.enumitem_action_map_variant)
		channel.enabled = true
	end)
	new:subscribe(InputNotification.RelatedNullified, ConnectionVariant.Ever, function()
		if not new:is_network_active() then
			return
		end

		channel.enabled = false
		channel:set_variant(new:get_related())
	end)

	new:subscribe(InputNotification.NetworkEnabled, ConnectionVariant.Ever, function()
		if not new:get_related() then
			return
		end

		channel.enabled = true
	end)
	new:subscribe(InputNotification.NetworkDisabled, ConnectionVariant.Ever, function()
		if not new:get_related() then
			return
		end

		channel.enabled = false
	end)

	new:subscribe(DisposableNotification.OnRelease, ConnectionVariant.Once, function()
		const pos = table.find(private.inputs, new)
		if pos then
			table.remove(private.inputs, pos)
		end
	end)
end)

do
	type pressed = boolean
	type clamped = boolean
	type state = {
		started: number,
		pressed_now: boolean,
		remove_on_next: boolean,
	}

	private.meta = table.freeze({ __mode = "ks" })
	private.channels = setmetatable(
		{} :: { [declare.input]: declare.channel<declare.enumitem_action_map_variant, (pressed, clamped)> },
		private.meta
	)
	private.codes = setmetatable({} :: { [declare.input]: { Enum.KeyCode } }, private.meta)
	private.related = setmetatable({} :: { [declare.input]: declare.enumitem_action_map_variant? }, private.meta)
	private.inputs = setmetatable({} :: { declare.input }, table.freeze({ __mode = "vs" }))
	private.invoke_at = setmetatable({} :: { [declare.input]: number }, private.meta)
	private.pressed = {} :: { [unknown]: Enum.KeyCode }
	private.net_active = setmetatable({} :: { [declare.input]: boolean? }, private.meta)

	UserInputService.InputBegan:Connect(function(a0: InputObject, intercepted: boolean)
		if intercepted then
			return
		end
		private.pressed[a0.KeyCode.Name] = a0.KeyCode

		private.for_inputs(function(input)
			if not input.enabled then
				return
			end

			if table.find(private.codes[input], a0.KeyCode) then
				const invoked = os.clock()

				input.pressed = true
				input:invoke()
				input:notificate(InputNotification.Pressed)
				private.invoke_at[input] = invoked

				task.delay(input.duration, function()
					if input.pressed and private.invoke_at[input] == invoked then
						input.clamped = true
						input:invoke()
						input:notificate(InputNotification.Clamped)
					end
				end)
			end
		end)
	end)

	UserInputService.InputEnded:Connect(function(a0: InputObject, intercepted: boolean)
		if intercepted then
			return
		end
		private.pressed[a0.KeyCode.Name] = nil

		private.for_inputs(function(input)
			if not input.enabled then
				return
			end

			const codes = private.codes[input]
			if table.find(codes, a0.KeyCode) then
				local can = false
				for _, v in codes do
					if private.pressed[v.Name] then
						can = true
						break
					end
				end

				if can then
					return
				end

				input.pressed = false
				input.clamped = false
				input:invoke()
				input:notificate(InputNotification.Stopped)
				private.invoke_at[input] = 0
			end
		end)
	end)

	private.for_inputs = function(f: (input: declare.input) -> ())
		for i = #private.inputs, 1, -1 do
			const input = private.inputs[i]
			if not input then
				table.remove(private.inputs, i)
				continue
			end

			f(input)
		end
	end
end

return class
