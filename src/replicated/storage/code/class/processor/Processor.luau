--!strict

const object = require("@game/ReplicatedStorage/code/object")
const NodeProcessState = require("@game/ReplicatedStorage/code/enums/NodeProcessState")
const class_names = require("@game/ReplicatedStorage/code/static/class_names")
const project = require("@game/ReplicatedStorage/code/static/project")
const Event = require("@game/ReplicatedStorage/code/class/event/Event")
const StorageMode = require("@game/ReplicatedStorage/code/enums/StorageMode")
const Storage = require("@game/ReplicatedStorage/code/service/storage/Storage")
const Node = require("@game/ReplicatedStorage/code/class/node/Node")

const private = {}
const class = {__index = Node}
setmetatable(class, class)

export type class = typeof(class.new())

class.type = class_names.processor
class.tag = "@processor"
class.process_state = NodeProcessState.operational
class.node_process_hertz = project.default_node_process_hertz

private.metadata = Storage.create_table_with(StorageMode.LazyKeys) :: {[class]: {
    delta_time: number,
    process_stepped_controller: Event.ctrl_class?,
    ready_controller: Event.ctrl_class?
}}
private.to_ready = Storage.create_table_with(StorageMode.LazyValues) :: {class}
private.to_process = Storage.create_table_with(StorageMode.LazyValues) :: {class}

do -- ProcessRegion

	function private.handle_nodes ()
		return task.defer(function()
			while task.wait(project.default_node_process_hertz) do
				debug.profilebegin("node.handlers")

				private.ready_handler()
				private.process_handler()

				debug.profileend()
			end
		end)
	end

	function private.ready_handler()
		debug.profilebegin("node.ready_handler()")
		
		const to_clear : {class} = {}
		
		for i,v in private.to_ready do
			
			if (not v.get_instance()) then
				continue
			end
			
			if (v.process ~= nil and type(v.ready) ~= "function") then
				warn("unexpected node.ready() type, removed")
				v:free()
				continue
			end
			
			const state, out = pcall(v.ready :: any, v, v:get_base())

			if (not state) then
				if (project.debug_mode) then
					error("node.ready() error"..tostring(out))
				else
					warn("node.ready() error, skipped", out)
				end
			end
			
			table.insert(to_clear,v)
		end
		
		for i,v in to_clear do
			table.remove(private.to_ready, table.find(private.to_ready,v))
		end	
		
		debug.profileend()
	end

	function private.process_handler()
		debug.profilebegin("node.process_handler()")
		
		const to_clear : {class} = {}
		
		for i,v in private.to_process do
			if (table.find(private.to_ready, v)) then
				continue
			end
			
			if (not v.get_instance()) then
				continue
			end

			if (v.process_state == NodeProcessState.disabled) then
				continue
			end
			
			if (v.process == nil or v.process == class.process) then
				continue
			end
			
			if (type(v.process) ~= "function") then
				table.insert(to_clear :: any, v)
				warn("unexpected node.process() type, removed")
				continue
			end
			
			const delta_time = private.get_delta_time(v)
			if (delta_time <= v.node_process_hertz) then
				continue
			end

			const state, out = pcall(v.process :: any, v, delta_time, v:get_base())

			
			if (not state) then
				warn(v, "node.process() error", out)
			end
		end
		
		for i,v in to_clear do
			table.remove(private.to_process, table.find(private.to_process, v))
		end
		
		debug.profileend()
	end

	function private.process_auto_remove (this: class)
		return function() 
			local id = table.find(private.to_process, this)
			if (id) then
				table.remove(private.to_process, id)
			end

		end
	end


	function private.get_delta_time(this: class)
        const metadata = private.metadata[this]
		const delta = metadata.delta_time
		const time_new = os.clock()
		if (delta) then
			metadata.delta_time = time_new
			return time_new - delta
		else
			metadata.delta_time = time_new
			return time_new - time_new
		end
	end

end

function class.new ()
    return object.new (class, true)
end

-- По умолчанию это виртуальная функция которая ничего не выполняет. Для работы замените на исполняемый код.
function class:ready (base: class)
	
end
-- По умолчанию это виртуальная функция которая ничего не выполняет. Для работы замените на исполняемый код.
function class:process (base: class, delta_time: number)
	
end

function class:initiate(as: Instance)
    const this = self :: class

    Node.initiate(this, as)
	table.insert(private.to_ready, this)
	table.insert(private.to_process, this)

	private.metadata[this] = {
		delta_time = os.clock()
	}

	this:watch_free_event(function()
		table.remove(private.to_ready, table.find(private.to_ready, this))
		table.remove(private.to_process, table.find(private.to_process, this))
	end)
end


private.handle_nodes()

return table.freeze(class)