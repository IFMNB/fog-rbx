const Disposable = require("@game/ReplicatedStorage/code/Disposable")
const Storage = require("@game/ReplicatedStorage/code/class/storage/Storage")
const Timer = require("@game/ReplicatedStorage/code/class/timer/Timer")
const ConnectionState = require("@game/ReplicatedStorage/code/enums/ConnectionState")
const object = require("@game/ReplicatedStorage/code/object")
const namefield = require("@game/ReplicatedStorage/code/static/namefield")
const project = require("@game/ReplicatedStorage/code/static/project")

const private = {}
const class = { __index = Disposable }
setmetatable(class, class)

export type class = object.class<typeof(class)>

class.type = namefield.job

function class.new()
	return Disposable.new(class, true)
end

-- Виртуальная функция, замените на нужный наполнитель.
function class:action() end

-- Начинает работу Job
function class:start(with: Timer.class)
	const this = self :: class
	const metadata = private.metadata:fetch(this)

	this:stop()

	metadata.repeating_connection = with:get_end_event():connect(function()
		const state, out = pcall(function(...)
			this:action()
		end)

		assert(state or not project.debug, "job runtime error")
		with:start(true)
	end)

	metadata.timer = with
	metadata.watch_free = function()
		this:stop()
	end
	this:watch_free_event(metadata.watch_free)
	with:start(true)
end

-- Заканчивает работу Job
function class:stop()
	const this = self :: class
	const metadata = private.metadata:fetch(this)

	if metadata.repeating_connection then
		if metadata.repeating_connection.state == ConnectionState.connected then
			metadata.repeating_connection:disconnect()
		end
		metadata.repeating_connection = nil
	end

	if metadata.timer then
		metadata.timer:stop()
		metadata.timer = nil
	end

	if metadata.watch_free then
		this:unwatch_free_event(metadata.watch_free)
		metadata.watch_free = nil
	end
end

private.metadata = Storage.new()

return table.freeze(class)
