--!strict

const Node = require("@game/ReplicatedStorage/class/actors/Node")
const Notification = require("@game/ReplicatedStorage/class/common/notification/Notification")
const Timer = require("@game/ReplicatedStorage/class/common/runtime/Timer")
const ConnectionVariant = require("@game/ReplicatedStorage/enums/descriptor/ConnectionVariant")
const OperationVariant = require("@game/ReplicatedStorage/enums/descriptor/OperationVariant")
const ActionNotification = require("@game/ReplicatedStorage/enums/notification/ActionNotification")
const NodeRuntimeNotification = require("@game/ReplicatedStorage/enums/notification/NodeRuntimeNotification")
const declare = require("@game/ReplicatedStorage/static/declare")
const namefield = require("@game/ReplicatedStorage/static/namefield")

const private = {}
const class: declare.noderuntime = Node:new({
	type = namefield.noderuntime,
	last_delta = 0,
	last_emit = 0,

	process = function(self: declare.noderuntime, delta: number): () end,

	simulate = function(self: declare.noderuntime, delta: number): () end,

	get_timer = function(self: declare.noderuntime): declare.timer
		return private.schedules[self]
	end,
})

class:host(function(new: declare.noderuntime)
	const timer = Timer:new({ seconds = math.huge, modifier = 0.001 })
	const reference_notification_channel = new:get_reference()
	local can = false

	private.schedules[new] = timer

	reference_notification_channel:subscribe(OperationVariant.New, ConnectionVariant.Ever, function()
		can = true
	end)

	reference_notification_channel:subscribe(OperationVariant.Null, ConnectionVariant.Ever,function()
		can = false
	end)

	timer:subscribe(ActionNotification.Step, ConnectionVariant.Ever, function ()
		if not can then return end

		new:process(timer:get_delta())
		new:notificate(Notification:new({ call_on = NodeRuntimeNotification.Process }))
		new:simulate(timer:get_delta())
		new:notificate(Notification:new({ call_on = NodeRuntimeNotification.Simulation }))
	end)

end)

do
	private.schedules = setmetatable({} :: { [declare.noderuntime]: declare.timer }, table.freeze({ __mode = "ks" }))
end

return class
