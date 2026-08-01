--!strict

const Schedule = require("@game/ReplicatedStorage/code/class/common/runtime/Schedule")
const Node = require("@game/ReplicatedStorage/code/class/rbxwrap/Node")
const ControllerNotificationVariant = require("@game/ReplicatedStorage/code/enums/notifications/ControllerNotificationVariant")
const declare = require("@game/ReplicatedStorage/code/static/declare")
const namefield = require("@game/ReplicatedStorage/code/static/namefield")

const private = {}
const class: declare.runtimeobject = Node:new({
	type = namefield.noderuntime,
	last_delta = 0,
	last_emit = 0,

	process = function(self: declare.node, delta: number): () end,

	simulate = function(self: declare.node, delta: number): () end,

	get_schedule = function(self: declare.noderuntime): declare.schedule
		return private.schedules[self]
	end,
})

class:toggle_host(function(new: declare.noderuntime)
	const schedule = Schedule:new()

    --TODO: завязать выполнение рантайма на schedule
    

	private.schedules[new] = schedule
end)

do
	private.schedules = setmetatable({} :: { [declare.noderuntime]: declare.schedule }, table.freeze({ __mode = "ks" }))
end

return class
