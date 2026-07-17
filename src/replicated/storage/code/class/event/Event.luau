--[[
	TODO
	для launch надо реализовать логику проверки по hash коду енама количества соединений
	и активировать цикл только если количество соединений на hash код енама > 0
	это удобно потому что можно отправлять notification и не париться за оптимизацию
	если соединений внутри 500 а нужных 2 штуки 
	
	это все равно не спасет от ада потому что нужные соединения стоит хранить в словаре типа

	[hashcode :: string]: {Connection.class}

	а сейчас хранение реализовано в виде:

	[Event.class]: {Connection.class}

	
]]

const object = require("@game/ReplicatedStorage/code/object")
const Disposable = require("../../Disposable")
const ConnectionState = require("../../enums/ConnectionState")
const StorageMode = require("../../enums/StorageMode")
const namefield = require("@game/ReplicatedStorage/code/static/namefield")
const project = require("../../static/project")
const Connection = require("../connection/Connection")
const Face = require("../face/Face")
const Upload = require("../upload/Upload")
const Storage = require("../storage/Storage")

const private = {}
const class = { __index = Disposable }
setmetatable(class, class)

type meta = { connection: Connection.class, f: (...any) -> (), once: boolean?, fired: boolean? }
export type class<T... = ...any> = object.generic<{
	get_face: (self: unknown) -> Face.class<T...>,
}, typeof(class)>

--[=[
	`Event` - стандартный способ создавать события на которые
	произвольный код может безопасно подписываться и выполняться
]=]
class.type = namefield.event

--[=[
	Если `true`, то `Event.class` делигирует вызов наблюдателей в единый обработчик
]=]
class.deferred = project.default_behavior_is_deferred

--[=[
	Время, которое будет ждать `Event.class` перед вызовом события

	Если отрицателен, то задержки не будет
]=]
class.time_before_emit = project.default_event_time_before_emit

--[=[
	Описывает текущее состояние `Event.class`, если вдруг наблюдатели
	смогут получить доступ к этому объекту прямо во время выполнения,
	хотя обычно это невозможно
]=]
class.in_emit = false

--[=[
	Сколько раз при 1 вызове `:emit()` или `:launch()` будет проводиться
	вызов наблюдателей
]=]
class.steps = project.default_event_steps

function class.new()
	const this = Disposable.new(class, true)
	return this :: class
end

--[=[
	Возвращает подготовленный интерфейс для работы с `Event.class`, предоставляющий всем
	наблюдателям стандартизированный способ общения с событием
]=]
function class:get_face()
	const this = self :: class
	return private.events:fetch(this, function()
		const new = Face.new()

		--[=[
			Подключает произвольный код к событию, который будет выполняться каждый раз,
			пока существует событие или подписка не будет отозвана

			Часть функциональности устроена на стороне `Connection.class`, подробности там
		]=]
		new.connect = function(self: unknown, F: (...any) -> (), expected: number?): Connection.class
			if not class.is_valid(this) then
				project.console_output("event isn't valid")
				return
			end

			const new_connection = Connection.new()
			new_connection.expected = expected

			const meta: meta = {
				connection = new_connection,
				f = F,
			}

			private.generate_disconnect(this, new_connection, meta)
			this:watch_free_event(new)

			if object.is(new_connection, Disposable.type) then
				new_connection:watch_free_event(function()
					new_connection:disconnect()
				end)
			end

			table.insert(this:get_connections(), meta)

			return new_connection
		end

		--[=[
			Подключает произвольный код к событию, который будет выполняться,
			пока существует событие или подписка не будет отозвана. Будет вызван только
			один раз, после чего будет уничтожен

			Часть функциональности устроена на стороне `Connection.class`, подробности там
		]=]
		new.once = function(self: unknown, F: (...any) -> (), expected: number?): Connection.class
			if not class.is_valid(this) then
				project.console_output("event isn't valid")
				return
			end

			const new_connection = Connection.new()
			new_connection.expected = expected

			const meta: meta = {
				connection = new_connection,
				f = F,
				once = true,
			}

			private.generate_disconnect(this, new_connection, meta)
			this:watch_free_event(new)
			if object.is(new_connection, Disposable.type) then
				new_connection:watch_free_event(function()
					new_connection:disconnect()
				end)
			end
			table.insert(this:get_connections(), meta)

			return new_connection
		end

		new.wait = private.wait
		new.owner_identity = this.identity
		return new:immutable()
	end) :: Face.class
end

--[=[
	Возвращает список всех текущих `Connection.class`, представляющих
	наблюдателей за этим событием
]=]
function class:get_connections(): { meta }
	const this = self :: class
	const if_nil = project.event_strong_connections and {} or Storage.create_table_with(StorageMode.LazyKeys)
	const connections_list = private.connections:fetch(this, if_nil)
	print(connections_list)
	return connections_list
end

--[=[
	Регистрирует объекты для этого `Event.class`, которые должны быть освобождены
	в конце цикла кода после вызова `:emit()` или `:launch()`
]=]
function class:register_to_free_when_emitted(that: object.generic<{}, typeof(object)> | {})
	const this = self :: class
	table.insert(private.emit_preregistered_to_free_objects:fetch(this, {}), that)
end

--[=[
	Возвращает текущие зарегистрированные объекты для этого `Event.class`
]=]
function class:get_registered_to_free_when_emitted()
	const this = self :: class
	return private.emit_preregistered_to_free_objects:fetch(this, {}) :: { object.generic<{}, typeof(object)> }
end

--[=[
	Освобождает зарегистрированные объекты для этого `Event.class`
]=]
function class:free_registered()
	const this = self :: class
	for _, v in this:get_registered_to_free_when_emitted() do
		v:queue_free()
	end
end

--[=[
	Вызывает событие с переданными аргументами
]=]
function class:emit(...: unknown)
	const this = self :: class
	const args = table.freeze({ ... })
	private.emit_parser(this, args)
end

--[=[
	Вызывает событие с переданными аргументами. Однако, будут вызваны
	только те наблюдатели, `expected` которых совпадает с переданным
	аргументом `enum`
]=]
function class:launch(enum: number, ...: unknown)
	const this = self :: class
	const args = table.freeze({ ... })
	private.emit_parser(this, args, enum)
end

do --private_region
	--[=[
		LEGACY

		По хорошему разбить на функции
	]=]
	function private.emit_parser(this: class, args: { unknown }, enum: number?)
		const multiple_steps = this.steps > 1
		const steps = this.steps
		const connections = this:get_connections()

		for i = 1, steps do
			this.in_emit = true

			if this.time_before_emit > 0 then
				task.wait(this.time_before_emit)
			end

			if this.deferred then
				if project.event_use_heartbeat_deferred then
					table.insert(private.heartbeat, { args = args, cons = connections, sended_enumerator = enum })

					private.signal:Wait()
					if multiple_steps then
						if i == steps then
							this.in_emit = false
							this:free_registered()
						end
					else
						this.in_emit = false
						this:free_registered()
					end
				else
					task.defer(private.emitter, this, i, steps, connections, args, enum)
				end
			else
				if project.event_emits_immediately then
					coroutine.resume(coroutine.create(private.emitter), this, i, steps, connections, args, enum)
				else
					task.spawn(private.emitter, this, i, steps, connections, args, enum)
				end
			end
		end
	end

	function private.emitter(
		this: class,
		i: number,
		max: number,
		connections: { meta },
		args: { unknown },
		enum: number?
	)
		for i, v in table.clone(connections) do
			if not private.is_expected_for_connection_equals_to_received(enum, v.connection) then
				continue
			end

			if v.once then
				v.connection:disconnect()
				if object.is(v.connection, Disposable.type) then
					v.connection:queue_free()
				end
			end

			private.execute(v, args)
		end

		this.in_emit = false
		if i == max then
			this:free_registered()
		end
	end

	function private.is_expected_for_connection_equals_to_received(enum: number?, v: Connection.class)
		return enum == nil or enum == v.expected
	end

	private.events = Upload.new()
	private.emit_preregistered_to_free_objects = Upload.new()
	private.connections = Upload.new()
	private.heartbeat = {} :: { { args: { any }, cons: { meta }, sended_enumerator: number? } }
	private.signal = game:GetService("RunService").Heartbeat

	--[=[
		Заставляет текущий поток дождаться вызова этого события, после чего продолжает свою работу

		Если событие передает аргументы, то они могут быть получены из этого метода, если записать
		результат его вызова в переменную или таблицу или куда-либо еще
	]=]
	private.wait = function(self: unknown, expected: number?)
		const thread = coroutine.running()
		const watchdog = function()
			if self.is_free then
				assert(
					not project.debug_mode,
					"event was destroyed while waiting, aborting Event.class:wait() call and continue thread"
				)
				coroutine.resume(thread)
				return
			end
		end

		self:once(function(...)
			coroutine.resume(thread, ...)
			self:unwatch_free_event(watchdog)
		end, expected)
		self:watch_free_event(watchdog)

		return coroutine.yield()
	end

	private.generate_disconnect = function(this: class, to: Connection.class, meta: meta)
		to.disconnect = function(self: unknown)
			if not meta.fired and to.state == ConnectionState.Alive and this.is_free ~= true then
				const connections = this:get_connections()
				const pos: number? = table.find(connections, meta)
				if pos then
					table.remove(connections, pos)
				end
			end
		end
	end

	if project.event_use_task_spawn then
		private.execute = function(meta: meta, args: { any })
			task.spawn(meta.f, table.unpack(args))
		end
	else
		private.execute = function(meta: meta, args: { any })
			assert(coroutine.resume(coroutine.create(meta.f), table.unpack(args)))
		end
	end

	private.signal:Connect(function(a0: number)
		for i, v in private.heartbeat do
			for j, d in table.clone(v.cons) do
				if not private.is_expected_for_connection_equals_to_received(v.sended_enumerator, d.connection) then
					continue
				end

				if d.once then
					d.connection:disconnect()
					if object.is(d.connection, Disposable.type) then
						d.connection:queue_free()
					end
				end
				private.execute(d, v.args)
			end
		end

		table.clear(private.heartbeat)
	end)
end

return table.freeze(class)