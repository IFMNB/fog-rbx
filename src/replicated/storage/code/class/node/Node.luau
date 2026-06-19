--!strict

const object = require('../../object')
const class_names = require('@game/ReplicatedStorage/code/static/class_names')
const Event = require("../event/Event")
const Meta = require("../meta/Meta")
const NodeProcessState = require('../../enums/NodeProcessState') -- TODO
const ProjectSettings = require('@game/ReplicatedStorage/code/static/project_settings')

const private = {}
const class = {__index = object}
setmetatable(class, class)

export type class = typeof(class.new())

class.type = class_names.node
class.name = class.type :: string
class.changed = (nil::any) :: Event.generic<any, any>?
class.process_state = NodeProcessState.operational

private.to_ready = setmetatable({}::{class}, {__mode = 'vs'})
private.to_process = setmetatable({}::{class}, {__mode = 'vs'})
private.process_delta_time = setmetatable({}::{[class]:number}, {__mode = 'ks'})
private.base_nodes = setmetatable({}::{[class]: class}, {__mode='ks'})
private.node_attribute = setmetatable({}::{[class]:{RBXScriptSignal}}, {__mode = 'ks'})

function private.get_delta_time(this: class)
	const delta = private.process_delta_time[this]
	const time_new = os.clock()
	if (delta) then
		private.process_delta_time[this] = time_new
		return time_new - delta
	else
		private.process_delta_time[this] = time_new
		return time_new - time_new
	end
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
		
		const state, out = pcall(v.ready, v, private.base_nodes[v])

		if (not state) then
			if (ProjectSettings.DebugMode) then
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
		
		if (rawget(v :: {[string]: any}, "process") == nil) then
			continue
		end
		
		if (type(v.process) ~= "function") then
			table.insert(to_clear, v)
			warn("unexpected node.process() type, removed")
			continue
		end
		
		const delta_time = private.get_delta_time(v)
		const state, out = pcall(v.process :: any, v, delta_time, private.base_nodes[v])

		
		if (not state) then
			warn(v, "node.process() error", out)
		end
	end
	
	for i,v in to_clear do
		table.remove(private.to_process, table.find(private.to_process, v))
	end
	
	debug.profileend()
end

function private.handle_nodes ()
	return task.spawn(function()
		while task.wait(ProjectSettings.NodeProcessHertz) do
			debug.profilebegin("node.handlers")

			private.ready_handler()
			private.process_handler()

			debug.profileend()
		end
	end)
end

function class.new(rbx_instance: Instance?, init: boolean?)
	return object.new(class, true)
end

function class.get_instance() : Instance?
	return nil
end

function class.is_initiated ()
	return false
end

function private.true_initiated ()
	return true
end

function private.lock_initiated (arg1)
	error(string.format("already initiated, but got %s", arg1));
end

function private.set_base (this: class)
	const meta = getmetatable(this)
	const index = meta.__index
	if (type(index) == "table") then
		if (index.process and index.ready) then
			private.base_nodes[this] = index
		end
	end
end

function private.process_auto_remove (this: class)
	return function() 
		local id = table.find(private.to_process, this)
		if (id) then
			table.remove(private.to_process, id)
		end

		private.base_nodes[this] = nil
	end
end

function private.on_free_node_destroy_instance (this: class)
	return function ()
		const instance = this.get_instance()
		if (instance) then
			instance:Destroy()
		end
	end
end

function private.get_attribute_expected_name_of(i: any) : string?
	const T = typeof(i)
	if (T == "string" or T == "boolean" or T == "number" or T == "nil" or T == "Vector3" or T == "Vector2") then
		return tostring(i)
	else
		return nil	
	end
end

function private.wrap_class (this: class, changed_event_controller: Event.class1)
	const new_meta = Meta.new()
	const meta = getmetatable(this) :: {[unknown]: unknown}
	const __index = meta.__index
	const __newindex = meta.__newindex

	setmetatable(this, new_meta)

	new_meta.__index = __index
	new_meta.__newindex = new_meta:wrap_newindex(__newindex, function(arg1, arg2, arg3)
		
	end)
end

function class:initiate(as: Instance)
	const this = self :: class
	const changed_event_controller = Event.new()
	const changed_event = changed_event_controller:get_event()
	
	this.changed = changed_event
	this:watch_free_event(private.process_auto_remove(this))
	this:watch_free_event(private.on_free_node_destroy_instance(this))
	this.initiate = private.lock_initiated
	this.get_instance = function () return as end
	this.is_initiated = private.true_initiated
	private.set_base(this)
	
	table.insert(private.to_ready, this)
	table.insert(private.to_process, this)
	private.instantiate(this)
end

-- По умолчанию это виртуальная функция которая ничего не выполняет. Для работы замените на исполняемый код.
function class:ready (base: class)
	
end
-- По умолчанию это виртуальная функция которая ничего не выполняет. Для работы замените на исполняемый код.
function class:process (base: class, delta_time: number)
	
end

function private.set_instance_attributes (this: class, index: {[unknown]: unknown})
	const instance = this.get_instance() :: Instance
	const to_free : {RBXScriptConnection} = {}

	for i,v in index do
		const attribute_name = private.get_attribute_expected_name_of(v)

		if (attribute_name) then
			instance:SetAttribute(attribute_name, v)

			const attribute_signal = instance:GetAttributeChangedSignal(attribute_name)
			const set_new_value_from_attribute = function(new_value: any) 
				(this::{[unknown]:unknown})[i] = new_value
			end
			const connection = attribute_signal:Connect(set_new_value_from_attribute)

			table.insert(to_free, connection)
		end
	end

	this:watch_free_event(function() 
		for i,v in to_free do
			if v.Connected then
				v:Disconnect()
			end
		end
	end)
end

function private.instantiate_iter (this: class, underground: {})
	const metatable = getmetatable(underground) :: unknown|{[unknown]:unknown}
	const type_meta = type(metatable)

	if (type_meta == "table") then
		local index = (metatable :: {[unknown]: unknown}).__index

		if (type(index) == "table") then
			local class = index :: {[unknown]: unknown}
			private.set_instance_attributes(this, class)
		end
	end
end

private.classtag = "@node"

function private.get_nodeclass_tag (of: Instance) 
	const tags : {string} = of:GetTags()

	for i,v in tags do
		if v == private.classtag then
			return true
		end
	end

	return false
end

function private.set_nodeclass_tag (to: Instance, with: string) 
	to:AddTag(private.classtag)
	to:AddTag(with)
end

-- Инстанцирование выводит все поля и свойства экземпляра в аттрибуты скрипта-instance (aka self.instance). Обратное присваивание не поддерживается (только через студию)
function private.instantiate (this: class)
	const instance = this.get_instance()
	
	if (not instance) then
		error("instance does not exists")
	end
	
	if (not private.get_nodeclass_tag(instance)) then
		private.set_nodeclass_tag(instance, this.type)
	end
	
	private.instantiate_iter(this, this)
end

private.handle_nodes()

table.freeze(class :: any)
return class