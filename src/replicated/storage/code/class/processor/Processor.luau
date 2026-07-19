const object = require("@game/ReplicatedStorage/code/object")
const namefield = require("@game/ReplicatedStorage/code/static/namefield")
const project = require("@game/ReplicatedStorage/code/static/project")
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
	Частота обновленния процессора за 1 такт, то есть сколько раз он будет вызываться в одном кадре
	где ожидается его вызов, причем `Processor.class .hertz` не будет учитываться как ограничение
]=]
class.rate = 1

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

function class:initiated (as: Instance)
	const this = self :: class
	this:get_initiate_event():once(function(...)
		private.metadata[this] = {
			ready = false,
			last_process = 0,
			last_simulation = 0
		}
		this:watch_free_event(Liberator.new(private.ready, this, true))
	end)
	Node.initiate(this, as)
end


do --init_region
	type processor_metadata = {
		ready: boolean,
		last_process: number,
		last_simulation: number
	}

	private.metadata = Storage.create_table_with(StorageMode.LazyKeys) :: {[class]: processor_metadata}
	private.signal = game:GetService "RunService".Heartbeat
	private.simulation = Upload.new()
	private.process_stepped = Upload.new()
	private.ready = Upload.new()

	private.signal:Connect(function ()
		for processor, metadata in private.metadata do
			if (not metadata.ready) then
				metadata.ready = true

				if private.ready:is_exists(processor) then
					const ready = private.ready:fetch(processor, Event.new)
					ready:emit()
					ready:queue_free()
				end
			end

			const delta_time = DateTime.now().UnixTimestampMillis - metadata.last_process
			
			if (delta_time > processor.hertz) then
				for i = 1, processor.rate do
					metadata.last_process = DateTime.now().UnixTimestampMillis
					processor:process(delta_time)

					if private.process_stepped:is_exists(processor) then
						private.process_stepped:fetch(processor, Event.new):emit(delta_time)
					end
				end
			end
			
			const delta_simulation = DateTime.now().UnixTimestampMillis - metadata.last_simulation
			
			if (delta_simulation > processor.hertz) then
				for i = 1, processor.rate do
					metadata.last_simulation = DateTime.now().UnixTimestampMillis
					processor:simulation(delta_simulation)

					if private.simulation:is_exists(processor) then
						private.simulation:fetch(processor, Event.new):emit(delta_simulation)
					end
				end
			end
		end
	end)
end

return table.freeze(class)