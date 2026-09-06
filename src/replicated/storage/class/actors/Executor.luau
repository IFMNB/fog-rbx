--!strict

const Disposable = require("@game/ReplicatedStorage/class/arch/Disposable")
const Notification = require("@game/ReplicatedStorage/class/common/notification/Notification")
const Timer = require("@game/ReplicatedStorage/class/common/runtime/Timer")
const ConnectionVariant = require("@game/ReplicatedStorage/enums/descriptor/ConnectionVariant")
const ActionNotification = require("@game/ReplicatedStorage/enums/notification/ActionNotification")
const ExecutorNotification = require("@game/ReplicatedStorage/enums/notification/ExecutorNotification")
const declare = require("@game/ReplicatedStorage/static/declare")

const private = {}
const class: declare.executor = Disposable:new({
	type = "executor",
	last_delta = 0,
	last_emit = 0,

	process = function(self: declare.executor, delta: number): () end,

	simulate = function(self: declare.executor, delta: number): () end,

	get_timer = function(self: declare.executor): declare.timer
		return private.schedules[self]
	end,
})

class:host(function(new: declare.executor)
	const timer = Timer:new({ seconds = math.huge, modifier = 0.001 })
	private.schedules[new] = timer

	timer:subscribe(ActionNotification.Step, ConnectionVariant.Ever, function()
		new:process(timer:get_delta())
		new:notificate(Notification:new({ call_on = ExecutorNotification.Process }))
		new:simulate(timer:get_delta())
		new:notificate(Notification:new({ call_on = ExecutorNotification.Simulation }))
	end)
end)

do
	private.schedules = setmetatable({} :: { [declare.executor]: declare.timer }, table.freeze({ __mode = "ks" }))
end

return class
