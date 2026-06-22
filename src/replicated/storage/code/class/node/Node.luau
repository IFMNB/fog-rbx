--!strict

const object = require "@game/ReplicatedStorage/code/object"
const StorageMode = require("@game/ReplicatedStorage/code/enums/StorageMode")
const Storage = require("@game/ReplicatedStorage/code/service/storage/Storage")
const class_names = require('@game/ReplicatedStorage/code/static/class_names')
const project = require("@game/ReplicatedStorage/code/static/project")
const Upload = require("@game/ReplicatedStorage/code/class/upload/Upload")
const Connection = require("@game/ReplicatedStorage/code/class/connection/Connection")
const Event = require("@game/ReplicatedStorage/code/class/event/Event")
const Meta = require("@game/ReplicatedStorage/code/class/meta/Meta")

const private = {}
const class = {__index = object}
setmetatable(class, class)

export type class = typeof(class.new())

class.type = class_names.node
class.name = class.type :: string
class.changed = project.default_not_exists :: Event.class
class.tag = "@node"

private.node_attribute = Storage.create_table_with(StorageMode.LazyKeys) :: {[class]: RBXScriptSignal}
private.metadata = Storage.create_table_with(StorageMode.LazyKeys) :: {[class]: {
	lazy_initiate: Upload.class?
}}

function class.new(rbx_instance: Instance?)
	const this = object.new(class, true)
	if (rbx_instance) then
		this:initiate(rbx_instance)
	end
	return this
end

-- Событие испускает сигнал только если
function class:get_initiate_event () : Event.class
	const this = self :: class
	local metadata = private.metadata[this]
	if (not metadata) then private.metadata[this] = {}; metadata = private.metadata[this] end

	if (this:is_initiated()) then
		if (project.debug_mode) then
			error("")
		end
	else
		local lazy_initiate = metadata.lazy_initiate :: Upload.class
		if (not lazy_initiate) then
			lazy_initiate = Upload.new()
			this:watch_free_event(function ()
				lazy_initiate:free()
			end)
		end
		
		metadata.lazy_initiate = lazy_initiate
		return lazy_initiate:fetch_class("initiate", Event):get_event()
	end

	return nil :: never
end

function class.get_instance() : Instance
	if (project.debug_mode) then
		return error("Cannot get instance, node should be initiated")
	else
		return nil :: never
	end
end

do -- InitiateRegion

	function class:initiate(as: Instance)
		const this = self :: class
		local metadata = private.metadata[this]
		if (not metadata) then private.metadata[this] = {}; metadata = private.metadata[this] end
		const changed_event_controller = Event.new()
		const changed_event = changed_event_controller:get_event()
		const upload_initiate = metadata.lazy_initiate

		if (class.is_node_instance(as)) then
			error("cannot initiate a new node object, this is because instance already is node-instance")
		end

		this.changed = changed_event
		private.wrap_class(this, changed_event_controller)
		this:watch_free_event(private.on_free_node_destroy_instance(this))
		this.initiate = private.lock_initiated
		this.get_instance = function () return as end
		this.is_initiated = private.true_initiated
		if (upload_initiate and upload_initiate:is_exists("initiate")) then
			const event_controller = upload_initiate:get("initiate") :: Event.ctrl_class
			event_controller:emit()
			upload_initiate:free()
			metadata.lazy_initiate = nil
		end

		this:do_for_all_inheritance(function(a0)
			private.set_instance_attributes(this, a0)
		end, true, true)

		private.set_nodeclass_tag(this)
		as.Destroying:Once(function() 
			if (this.is_free == false) then
				this:free()
			end
		end)
	end

	function private.set_instance_attributes (this: class, from: object.class)
		const instance = this.get_instance() :: Instance
		const to_free : {RBXScriptConnection} = {}
		const to_free_event : {Connection.class} = {}

		for i,v in (from :: {[unknown]: unknown}) do
			if (i == "type" or i == "tag") or i == "is_free" then
				continue
			end

			const attribute_name = private.get_attribute_expected_name_of(i)

			if (attribute_name and private.get_attribute_expected_name_of(v)) then
				instance:SetAttribute(attribute_name, v)

				const attribute = instance:GetAttributeChangedSignal(attribute_name)

				if (project.debug_mode) then
					const callback = function ()
						(this :: {[unknown]: unknown})[i] = instance:GetAttribute(attribute_name)
					end
					const connection = attribute:Connect(callback)

					table.insert(to_free, connection)
				end
				
				const rollout = function (arg1: any, arg2: any)
					if (arg1 ~= attribute_name) then
						return
					end
					
					const attribute_value = instance:GetAttribute(attribute_name)
					if (attribute_value ~= arg2) then
						instance:SetAttribute(attribute_name, arg2)
					end
				end
				const event_connection =	this.changed:connect(rollout)

				table.insert(to_free_event, event_connection);
			end
		end

		this:watch_free_event(function()
			for i,v in to_free do
				v:Disconnect()
			end
			for i,v in to_free_event do
				v:disconnect()
			end
		end)
	end

	function private.lock_initiated (arg1)
		error(string.format("already initiated, but got %s", arg1));
	end

	function class.is_initiated ()
		return false
	end

	function private.true_initiated ()
		return true
	end

	function private.on_free_node_destroy_instance (this: class)
		return function ()
			const instance = this.get_instance()
			if (instance) then
				instance:Destroy()
			end
		end
	end

	private.attribute_expected_types = table.freeze ({
		string = true,
		boolean = true,
		number = true,
		Vector3 = true,
		Vector2 = true,
		CFrame = true,
		Color3 = true,
		UDim = true,
		UDim2 = true,
		BrickColor = true,
		NumberSequence = true,
		ColorSequence = true,
		NumberRange = true,
		Font = true,
		Rect = true
	}) :: {[string]: boolean}

	function private.get_attribute_expected_name_of(i: any) : string?
		const T = typeof(i)
		const value = private.attribute_expected_types[T]
		if (value == true) then
			return tostring(i)
		else
			return nil	
		end
	end

	function private.wrap_class (this: class, changed_event_controller: Event.ctrl_class)
		const new_meta = Meta.new()
		const meta = getmetatable(this) :: {[unknown]: unknown}
		const __index = meta.__index
		const __newindex = meta.__newindex

		setmetatable(this, new_meta)

		new_meta.__index = __index
		new_meta.__newindex = new_meta:wrap_newindex(__newindex, function(arg1, arg2, arg3)
			changed_event_controller:emit(arg2, arg3)
		end)
	end

	function private.set_nodeclass_tag (this: class) 
		const to: Instance = this.get_instance() :: Instance
		to:AddTag(this.tag)
		to:AddTag(this.type)
	end

end

function class.is_node_instance (of: Instance) 
	const tags : {string} = of:GetTags()

	for i,v in tags do
		if v == class.tag then
			return true
		end
	end

	return false
end


table.freeze(class :: any)
return class