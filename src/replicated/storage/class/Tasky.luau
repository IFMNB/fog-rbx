--!strict
const Concur = require("@game/ReplicatedStorage/dependency/Concur")
const object = require("@game/ReplicatedStorage/object")
const declare = require("@game/ReplicatedStorage/static/declare")
const namefield = require("@game/ReplicatedStorage/static/namefield")
const project = require("@game/ReplicatedStorage/static/project")

type concur_instance = typeof(Concur.spawn(nil :: never))

const private = {}
const class: declare.tasky<concur_instance> = object:new({
	type = namefield.tasky,
	attempts = 1,
	time_to_hold = 0,
	time_to_response = project.retry_time,

	deploy = function(self: declare.tasky<concur_instance>, path: string)
		assert(not private.space[self][path], "already deployed")

		const thread = Concur.spawn(require, path)
		private.space[self][path] = thread

		Concur.spawn(function(...): ...any
			if thread:Await(self.time_to_response) then
				for i = 1, self.attempts do
					if private.space[self][path] == nil then
						break
					end

					const new = Concur.spawn(require, path)
					private.space[self][path] = new

					if not new:Await(self.time_to_response) then
						return
					end

					if self.time_to_hold > 0 then
						task.wait(self.time_to_hold)
					end
				end

				project.console_out "tasky couldn't start the task, it was thrown away"
			end
		end)
	end,

	is_exists = function(self: declare.tasky<concur_instance>, path: string)
		return private.space[self][path] ~= nil
	end,

	get_existed = function(self: declare.tasky<concur_instance>, path)
		return private.space[self][path]
	end,

	get_online = function(self: declare.tasky<concur_instance>)
		const r = {}

		for i, v in private.space[self] do
			if not v:IsCompleted() then
				r[i] = v
			end
		end

		return r
	end,

	get_offline = function(self: declare.tasky<concur_instance>)
		const r = {}

		for i, v in private.space[self] do
			if v:IsCompleted() then
				r[i] = v
			end
		end

		return r
	end,

	clear = function(self: declare.tasky<concur_instance>)
		for _, v: any in private.space[self] do
			if not v:IsCompleted() then
				v:Stop()
			end
		end

		table.clear(private.space[self])
	end,
})

class:host(function(new)
	private.space[new] = {}
end)

do
	private.space = setmetatable({} :: { [unknown]: { [string]: concur_instance? } }, table.freeze({ __mode = "ks" }))
	private.space[class] = {}
end

return class
