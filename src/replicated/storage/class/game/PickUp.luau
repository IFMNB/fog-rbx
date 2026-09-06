--!strict
const ReplicatedStorage = game:GetService("ReplicatedStorage")
const Node = require("@game/ReplicatedStorage/class/actors/Node")
const Reference = require("@game/ReplicatedStorage/class/common/Reference")
const Signal = require("@game/ReplicatedStorage/class/common/Signal")
const Value = require("@game/ReplicatedStorage/class/common/Value")
const Maid = require("@game/ReplicatedStorage/class/common/gc/Maid")
const ConnectionVariant = require("@game/ReplicatedStorage/enums/descriptor/ConnectionVariant")
const OperationVariant = require("@game/ReplicatedStorage/enums/descriptor/OperationVariant")
const ActionNotification = require("@game/ReplicatedStorage/enums/notification/ActionNotification")
const DisposableNotification = require("@game/ReplicatedStorage/enums/notification/DisposableNotification")
const PickupNotification = require("@game/ReplicatedStorage/enums/notification/PickupNotification")
const ReferenceNotification = require("@game/ReplicatedStorage/enums/notification/ReferenceNotification")
const declare = require("@game/ReplicatedStorage/static/declare")

const project = require("@game/ReplicatedStorage/static/project")

const private = {}
const class: declare.pickup = (Node :: declare.node<PVInstance>):new({
	type = "pickup",

	dropable = false,
	pickable = false,
	time = Value:new() :: declare.value<number>,
	distance = Value:new() :: declare.value<number>,

	show_pickup = function(self: declare.pickup, set: boolean?): ()
		if set ~= nil then
			private.showed[self] = set
		else
			if private.showed[self] then
				private.showed[self] = false
			else
				private.showed[self] = true
			end
		end

		const current = private.showed[self] :: boolean

		if current then
			self:notificate(PickupNotification.Shown)
		else
			self:notificate(PickupNotification.Hidden)
		end
	end,

	get_last_interacted = function(self: declare.pickup): any?
		return private.interactions[self]
	end,
})

class:host(function(new: declare.pickup)
	do
		const typeless_new = new :: { [unknown]: unknown }
		typeless_new.distance = Value:new()
		typeless_new.time = Value:new()
	end

	new.distance:set_value(private.default_distance, true)
	new.time:set_value(private.default_time, true)
end)

class:host(function(new: declare.pickup)
	const maid = Maid:new()
	const reference = private.new_reference()
	const touch, dropped, pickedup, f0 = private.new_signals(reference)

	maid:add_object(f0, true)

	maid:add_object(
		touch:get_signal_event():connect(ActionNotification.Emit, function(p: Player)
			private.interactions[new] = p
			if project.debug_show_pickup_internal then
				project.console_out("Touch emitted")
			end
			new:notificate(PickupNotification.Touch)
		end),
		true
	)

	maid:add_object(
		pickedup:get_signal_event():connect(ActionNotification.Emit, function(p: Player)
			private.interactions[new] = p
			if not new.pickable then
				if project.debug_show_pickup_internal then
					project.console_out("PickedUp emit cancel")
				end
				return
			end
			new:notificate(PickupNotification.PickedUp)
		end),
		true
	)

	maid:add_object(
		dropped:get_signal_event():connect(ActionNotification.Emit, function(p: Player)
			private.interactions[new] = p
			if not new.dropable then
				if project.debug_show_pickup_internal then
					project.console_out("Drop emit cancel")
				end
				return
			end
			new:notificate(PickupNotification.Dropped)
		end),
		true
	)

	maid:add_object(
		new:subscribe(PickupNotification.Shown, ConnectionVariant.Ever, function()
			const prompt = reference:get_instance()
			const target = new:get_reference():get_instance()

			if target then
				prompt.Enabled = true
				prompt.Parent = target

				if project.debug_show_pickup_internal then
					project.console_out("PickUp shown")
				end
			end
		end),
		true
	)

	maid:add_object(
		new:subscribe(PickupNotification.Hidden, ConnectionVariant.Ever, function()
			const prompt = reference:get_instance()
			prompt.Enabled = false
			prompt.Parent = ReplicatedStorage.shared

			if project.debug_show_pickup_internal then
				project.console_out("PickUp hidded")
			end
		end),
		true
	)

	maid:add_object(
		new.distance:subscribe({ OperationVariant.Change, OperationVariant.New }, ConnectionVariant.Ever, function()
			const prompt = reference:get_instance()
			const value = new.distance:get_value() or private.default_distance
			prompt.MaxActivationDistance = value
			prompt.MaxIndicatorDistance = value * 2

			if project.debug_show_pickup_internal then
				project.console_out("PickUp distance changed")
			end
		end),
		true
	)

	maid:add_object(
		new.time:subscribe({ OperationVariant.Change, OperationVariant.New }, ConnectionVariant.Ever, function()
			const prompt = reference:get_instance()
			const value = new.time:get_value() or private.default_time
			prompt.HoldDuration = value

			if project.debug_show_pickup_internal then
				project.console_out("PickUp time changed")
			end
		end),
		true
	)

	maid:add_object(reference)

	new:subscribe(DisposableNotification.OnRelease, ConnectionVariant.Once, function()
		maid:free()
	end)
end)

do
	private.meta = table.freeze({ __mode = "ks" })
	private.showed = setmetatable({} :: { [declare.pickup]: boolean? }, private.meta)
	private.interactions = setmetatable({} :: { [declare.pickup]: unknown? }, private.meta)
	private.default_distance = 10
	private.default_time = 1

	private.new_reference = function()
		const reference = Reference:new() :: declare.reference<ProximityPrompt>
		const prompt = Instance.new("ProximityPrompt")
		prompt.Name = tostring(reference.identity)
		prompt.ActionText = "Pick up"
		prompt.RequiresLineOfSight = true
		prompt.Parent = ReplicatedStorage.shared
		prompt.HoldDuration = private.default_time
		prompt.MaxActivationDistance = private.default_distance
		prompt.MaxIndicatorDistance = private.default_distance * 2

		reference:set_instance(prompt)

		if project.debug_show_pickup_internal then
			project.console_out("created pickup reference")
		end

		return reference
	end

	private.new_signals = function(reference: declare.reference<ProximityPrompt>)
		const signal_touch = Signal:new() :: declare.signal<Player>
		const signal_dropped = Signal:new() :: declare.signal<Player>
		const signal_pickedup = Signal:new() :: declare.signal<Player>

		signal_touch:set_instance(reference:get_instance().PromptButtonHoldBegan)
		signal_dropped:set_instance(reference:get_instance().PromptButtonHoldEnded)
		signal_pickedup:set_instance(reference:get_instance().Triggered)

		return signal_touch,
			signal_dropped,
			signal_pickedup,
			reference:subscribe(
				{ ReferenceNotification.ChangedInstance, ReferenceNotification.NewInstance },
				ConnectionVariant.Ever,
				function()
					if project.debug_show_pickup_internal then
						project.console_out("reference changed his prompt, resetting signals")
					end

					const promp = reference:get_instance()
					assert(promp:IsA("ProximityPrompt"), "isn't a prompt, abort")

					signal_touch:set_instance(promp.PromptButtonHoldBegan)
					signal_dropped:set_instance(promp.PromptButtonHoldEnded)
					signal_pickedup:set_instance(promp.Triggered)
				end
			)
	end
end

return class
