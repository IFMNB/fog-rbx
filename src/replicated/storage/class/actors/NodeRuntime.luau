--!strict

const Node = require("@game/ReplicatedStorage/class/actors/Node")
const Notification = require("@game/ReplicatedStorage/class/common/Notification")
const Timer = require("@game/ReplicatedStorage/class/common/runtime/Timer")
const InstanceNotificationVariant = require("@game/ReplicatedStorage/enums/notifications/InstanceNotificationVariant")
const NodeNotificationVariant = require("@game/ReplicatedStorage/enums/notifications/NodeNotificationVariant")
const declare = require("@game/ReplicatedStorage/static/declare")
const namefield = require("@game/ReplicatedStorage/static/namefield")

const private = {}
const class: declare.noderuntime = Node:new({
	type = namefield.noderuntime,
	last_delta = 0,
	last_emit = 0,

	process = function(self: declare.noderuntime, delta: number): () end,

	simulate = function(self: declare.noderuntime, delta: number): () end,

	get_runtime = function(self: declare.noderuntime): declare.timer
		return private.schedules[self]
	end,
})

class:toggle_host(function(new: declare.noderuntime)
	const timer = Timer:new({ seconds = math.huge, modifier = 0.001 })
	const reference_notification_channel = new:get_reference():get_notification_event()
	local can = false

	reference_notification_channel:connect(function()
		can = true
		print("can")
	end, InstanceNotificationVariant.Newwie)
	reference_notification_channel:connect(function()
		can = false
		print("fuck")
	end, InstanceNotificationVariant.Nullified)

	timer:bind(function()
		if not can then
			return
		end

		new:process(timer:get_delta())
		new:notificate(Notification:new({ call_on = NodeNotificationVariant.ProcessStepped }))
		new:simulate(timer:get_delta())
		new:notificate(Notification:new({ call_on = NodeNotificationVariant.SimulationStepped }))
	end)

	private.schedules[new] = timer
end)

do
	private.schedules = setmetatable({} :: { [declare.noderuntime]: declare.timer }, table.freeze({ __mode = "ks" }))
end

return class
