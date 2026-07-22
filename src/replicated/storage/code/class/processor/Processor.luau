const RunService = game:GetService("RunService")
const object = require("@game/ReplicatedStorage/code/object")
const namefield = require("@game/ReplicatedStorage/code/static/namefield")
const project = require("@game/ReplicatedStorage/code/static/project")
const RuntimeVariant = require("../../enums/RuntimeVariant")
const Face = require("../face/Face")
const Liberator = require("../../struct/Liberator")
const Event = require("@game/ReplicatedStorage/code/class/event/Event")
const Storage = require("../storage/Storage")
const StorageMode = require("../../enums/StorageMode")
const Disposable = require("../../Disposable")
const Upload = require("../upload/Upload")
const Node = require("@game/ReplicatedStorage/code/class/node/Node")

const private = {}
const class = {__index = Node}
setmetatable(class, class)

export type class = object.class<typeof(class)>

class.type = namefield.processor
--[=[
	Аналогичен тегу из `Node.class`, однако указывает на то, что данный объект является процессором

	Может быть заменен наследниками на любой другой тег
]=]
class.tag = "@processor"

--[=[
	Частота обновления процессора в миллисекундах, за которой `Processor.class` будет выполнять
	свою работу в каждом кадре
]=]
class.hertz = project.default_processor_hertz

--[=[
	Указывает вариант поведения процессора в его работе
]=]
class.runtype = RuntimeVariant.Inherit

--[=[
	Частота обновленния процессора за 1 такт, то есть сколько раз он будет вызываться в одном кадре
	где ожидается его вызов, причем `Processor.class .hertz` не будет учитываться как ограничение
]=]
class.rate = 1

--[=[
	Время работы процессора в секундах с момента его инициализации
]=]
class.uptime = 0

--[=[
	Создаст базовый процессор, который будет испускать события в каждом кадре
	
	По умолчанию пустой и ничего не умеет
]=]
function class.new ()
    return Disposable.new (class, true)
end

--[=[
	Это виртуальная функция которая должна быть заменена в наследниках

	Она вызывается один раз при инициализации процессора и должна содержать
	в себе логику для подготовки процессора к работе, например, создание событий,
	инициализация переменных, и т.д
]=]
function class:ready (base: class)
	
end

--[=[
	Это виртуальная функция которая должна быть заменена в наследниках

	Она вызывается каждый раз в кадре и должна содержать в себе логику,
	которые должны обрабатывать данные в каждом кадре
]=]
function class:process (delta_time: number)
	
end

--[=[
	Это виртуальная функция которая должна быть заменена в наследниках

	Она вызывается каждый раз в кадре и должна содержать в себе логику,
	которые должны обрабатывать данные в каждом кадре после физической
	симуляции движка
]=]
function class:simulation (delta_time: number)
	
end

--[=[
	Указывает, что процессор готов к работе и может испускать события
]=]
function class:is_ready ()
	const this = self :: class
	return private.metadata[this] and private.metadata[this].ready == true
end

--[=[
	Возвращает событие, которое срабатывает, когда процессор готов к работе
]=]
function class:get_ready_event () : Face.class
	const this = self :: class
	if (this:is_ready()) then
		project.console_output("instance already ready and this event cannot be fired again")
		return Face.new()
	else
		return private.ready:fetch(this, Event.new):get_face()
	end
end

function class:get_process_stepped_event ()
	const this = self :: class
	return private.process_stepped:fetch(this, Event.new):get_face()
end

function class:get_simulation_event ()
	const this = self :: class
	return private.simulation:fetch(this, Event.new):get_face()
end

function class:initiate(as: Instance)
	const this = self :: class

	if (this:is_ready()) then
		project.console_output("instance already initiated, abort")
		return
	end

	if (this:is_initiated()) then
		private.metadata[this] = {
			ready = false,
			last_process = 0,
			last_simulation = 0,
		}
		this:get_instance():AddTag(private.supertag)
		this:watch_free_event(Liberator.new(private.ready, this, true))
	else
		this:get_initiate_event():once(function(...)
			RunService.PreSimulation:Once(function()
				if (this:is_queued_for_release() or this:is_released()) then
					return
				end

				private.metadata[this] = {
					ready = false,
					last_process = 0,
					last_simulation = 0,
					inititiated_time = DateTime.now().UnixTimestampMillis
				}
				this:get_instance():AddTag(private.supertag)
				this:watch_free_event(Liberator.new(private.ready, this, true))
			end)
		end)
		Node.initiate(this, as)
	end
end

function class.is_processor_instance (of: Instance) : boolean
	const tags : {string} = of:GetTags()

	for _,v in tags do
		if v == private.supertag then
			return true
		end
	end

	return false
end


do --init_region
	type processor_metadata = {
		ready: boolean,
		last_process: number,
		last_simulation: number,
		inititiated_time: number
	}

	@native
	function private.process_step(processor: class, metadata: processor_metadata)
		const date = DateTime.now()
		const delta_time = (date.UnixTimestampMillis - metadata.last_process) / 1000

		if delta_time > processor.hertz then
			for i = 1, processor.rate do
				metadata.last_process = date.UnixTimestampMillis
				processor:process(delta_time)

				if private.process_stepped:is_exists(processor) then
					private.process_stepped:fetch(processor, Event.new):emit(delta_time)
				end
			end
		end
	end

	@native
	function private.simulation_step(processor: class, metadata: processor_metadata)
		const date = DateTime.now()
		const delta_time = (date.UnixTimestampMillis - metadata.last_simulation) / 1000

		if delta_time > processor.hertz then
			for i = 1, processor.rate do
				metadata.last_simulation = date.UnixTimestampMillis
				processor:simulation(delta_time)

				if private.simulation:is_exists(processor) then
					private.simulation:fetch(processor, Event.new):emit(delta_time)
				end
			end
		end
	end

	private.metadata = Storage.create_table_with(StorageMode.LazyKeys) :: {[class]: processor_metadata}
	private.signal_simulation = game:GetService "RunService".Heartbeat
	private.signal_processing = game:GetService "RunService".Heartbeat
	private.simulation = Upload.new()
	private.process_stepped = Upload.new()
	private.ready = Upload.new()
	private.supertag = class.tag
	private.process_do = table.freeze {private.process_step}
	private.simulation_do = table.freeze {private.simulation_step}

	private.signal_processing:Connect(function ()
		private.runtime(RuntimeVariant.Synchro, private.process_do, false)
	end)

	private.signal_simulation:Connect(function ()
		private.runtime(RuntimeVariant.Synchro, private.simulation_do, false)
	end)

	if (project.parallel) then
		private.signal_processing:ConnectParallel(function()
			private.runtime(RuntimeVariant.Parallel, private.process_do, true)
		end)

		private.signal_simulation:ConnectParallel(function()
			private.runtime(RuntimeVariant.Parallel, private.simulation_do, true)
		end)
	end

	@native
	function private.runtime (runvariant: number, run: {(class, processor_metadata) -> ()}, parallel: boolean?)
		for processor, metadata in private.metadata do
			if not private.can_run(processor, runvariant) then
				continue
			end
			if not processor:is_ready() and not parallel and private.setup_ready(processor, metadata) then
				continue
			end

			for i, v in run do
				v(processor, metadata)
			end
			
			if not parallel then
				processor.uptime = (DateTime.now().UnixTimestampMillis - metadata.inititiated_time)
			end
		end
	end

	@native
	function private.can_run (processor: class, runtype_machine: number)
		if (processor.runtype == RuntimeVariant.Disabled) then
			return false
		elseif (processor.runtype == RuntimeVariant.Inherit) then
			const ancestor = processor:get_nearest_ancestor_node()
			if (ancestor) then
				if (ancestor.runtype == RuntimeVariant.Disabled) then
					return false
				elseif (ancestor.runtype ~= runtype_machine) then
					return false
				end
			end
		else
			if (processor.runtype ~= runtype_machine) then
				return false
			end
		end

		return true
	end

	@native
	function private.setup_ready (processor: class, metadata: processor_metadata)
		if (not metadata.ready) then
			metadata.ready = true
			metadata.inititiated_time = DateTime.now().UnixTimestampMillis

			if private.ready:is_exists(processor) then
				const ready = private.ready:fetch(processor, Event.new)
				ready:emit()
				ready:queue_free()
			end

			return true
		end

		return false
	end

end

return table.freeze(class)