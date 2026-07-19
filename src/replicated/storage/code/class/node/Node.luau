--[[
	LEGACY

	Большую часть кода класса занимает синхронизация с аттрибутами и фишки
	синронизации пары тройки объектов, +- это лишняя работа и повторение

	Уже существует `Attribute.class`, логика работы в этом направлении
	должна быть переписана (особенно это касается Notificate региона)

	TODO

	разные nodenotification понапридумывать
]]

const object = require "@game/ReplicatedStorage/code/object"
const namefield = require('@game/ReplicatedStorage/code/static/namefield')
const project = require("@game/ReplicatedStorage/code/static/project")
const Disposable = require("../../Disposable")
const Face = require("../face/Face")
const Linked = require("../../service/linked/Linked")
const Storage = require("../storage/Storage")
const NodeNotificationType = require("../../enums/NodeNotificationType")
const Upload = require("@game/ReplicatedStorage/code/class/upload/Upload")
const Connection = require("@game/ReplicatedStorage/code/class/connection/Connection")
const Event = require("@game/ReplicatedStorage/code/class/event/Event")
const Meta = require("@game/ReplicatedStorage/code/class/meta/Meta")

const private = {}
const class = {__index = Disposable}
setmetatable(class, class)

export type class = typeof(class.new())

--[=[
	`Node` - позволяет привязать объект к реальному экземпляру Roblox
	и сопровождать его на протяжении всей жизни
]=]
class.type = namefield.node
class.name = class.type :: string

--[=[
	Тег, который будет добавлен к экземпляру Roblox при инициализации ноды,
	чтобы можно было отличить его от обычного экземпляра
]=]
class.tag = "@node" :: "@node"|string
class.classname = "Object" :: string|{string}|"Object"

private.initiate_event = Upload.new()
private.changed_event = Upload.new()
private.notification_event = Upload.new()
private.attributes = Storage.new()
private.attributes_events = Storage.new()
private.instances = Upload.new()

function class.new(rbx_instance: Instance?)
	const this = Disposable.new(class, true)
	if (rbx_instance) then
		this:initiate(rbx_instance)
	end
	return this
end

--[=[
	Возвращает событие инициализации ноды

	Если нода уже была инициализирована, то вернет пустой `Face.class`
]=]
function class:get_initiate_event ()
	const this = self :: class
	private.assert_initiated_event(this)

	if (this:is_initiated()) then
		project.console_output("instance already initiated and this event cannot be fired again")
		return Face.new()
	else
		return private.initiate_event:fetch(this, Event.new):get_face()
	end
end

function class:get_notification_event () : Face.class<number, string, number, number>
	const this = self :: class
	return private.notification_event:fetch(this, function()
		const new = Event.new()

		this:watch_free_event(function()
			new:queue_free()
		end)

		return new
	end):get_face()
end

function class:get_changed_event ()
	const this = self :: class
	return private.get_changed_event_ctrl(this):get_face()
end

function private.get_changed_event_ctrl(this: class)
	return private.changed_event:fetch(this, function()
		const new = Event.new()

		this:watch_free_event(function()
			new:queue_free()
		end)

		return new
	end)
end

function class:get_instance() : Instance
	const this = self :: class
	return private.instances:fetch(this, error)
end

do -- InitiateRegion

	--[[
	Виртуальная функция которая вызывается после установки всех примитивных свойств и аттрибутов ноды,
	но до закрытия инициализации и вызова ее конечного ивента. Используйте это для инициализации
	сложных элементов класса и подгрузки аттрибутов для объектов нужного формата.
	]]
	function class:on_initiate(base: class?)
		
	end

	function class:initiate(as: Instance)
		const this = self :: class
		private.check_expected_instance_class(this, as)
		private.check_is_node_valid(this, as)
		private.instances:fetch(this, as)
		Linked.link(this, as)
		private.setup_instance_attributes(this, as)
		private.set_free_watchers(this, as)
		private.fire_on_initiate_func(this)
		private.lock_initiator(this, as)
		private.fire_initiate_event(this)
	end

	function private.fire_on_initiate_func (this: class)
		const base = this:get_base()
		if (base and base:is("node")) then
			this:on_initiate((base :: any) :: class)
		else
			this:on_initiate()
		end
		this.on_initiate = private.lock_initiated
	end

	function private.fire_initiate_event (this: class)
		if (private.initiate_event:is_exists(this)) then
			const event_ctrl = private.initiate_event:get(this) :: Event.class
			event_ctrl:emit()
		end
	end

	function private.setup_instance_attributes (this: class, as: Instance)
		private.wrap_class(this)
		private.set_nodeclass_tag(this)
		this:do_for_all_inheritance(function(a0)
			private.set_instance_attributes(this, a0)
		end, true, true)
	end

	function private.lock_initiator(this: class, as: Instance)
		this.is_initiated = private.true_initiated
		this.initiate = private.lock_initiated
		this.on_initiate = private.lock_initiated
	end

	function private.set_free_watchers (this: class, as: Instance)
		this:watch_free_event(private.on_free_node_destroy_instance(this))
		as.Destroying:Once(function() 
			if (object.is_valid(this)) then
				this:notificate(NodeNotificationType.InstanceDestroyed)
				this:queue_free()
			end
		end)
	end

	function private.check_is_node_valid (this: class, as: Instance)
		if (class.is_node_instance(as)) then 
			project.console_output "cannot initiate a new node object, this is because instance already is node-instance"
			return false
		end

		return true
	end

	function private.check_expected_instance_class (this: class, as: Instance)
		const expected_instance_classname = this.classname
		const type_expected_instance_classname = type(expected_instance_classname)

		if (type_expected_instance_classname == "string") then
			if (not as:IsA(expected_instance_classname :: string)) then
				project.console_output("unexpected instance class")
				return
			end
		elseif (type_expected_instance_classname == "table") then
			for i,v in expected_instance_classname :: {string} do
				if (not as:IsA(v)) then
					project.console_output("unexpected instance class")
					return
				end
			end
		else
			project.console_output("unexpected this.classname type")
			return
		end
	end

	--[[	NOTE

		Существующий объект Attribute.luau не заменяет это легаси потому что незачем.
		Работает - не трогай.
	]]
	@native
	function private.set_instance_attributes (this: class, from: object.class)
		const instance = this:get_instance() :: Instance
		const to_free : {RBXScriptConnection} = {}
		const to_free_event : {Connection.class} = {}
		const changed = this:get_changed_event()
		const attributes = private.attributes:fetch(this)

		for i,v in (from :: {[unknown]: unknown}) do
			if (i == "type" or i == "tag") or i == "is_free" then
				continue
			end

			const attribute_name = private.get_attribute_expected_name_of(i)

			if (attribute_name and private.get_attribute_expected_name_of(v)) then
				table.insert(attributes, attribute_name)
				instance:SetAttribute(attribute_name, v)

				const attribute = instance:GetAttributeChangedSignal(attribute_name)

				do -- on_explorer_attribute_changed
					if (project.debug_mode) then
						const callback = private.generate_callback_for_attribute(this, attribute_name, function(untyped_this: { [any]: any }, new)
							untyped_this[attribute_name] = new
						end)
						const connection = attribute:Connect(callback)
						table.insert(to_free, connection)
					end
				end
				
				do -- on_class_value_changed
					const rollout = private.generate_rollback_for_attribute(this, attribute_name)
					const event_connection =	changed:connect(rollout)
					table.insert(to_free_event, event_connection);
				end
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

	function private.generate_callback_for_attribute (this: class, attribute_name: string, how_set: (untyped_this: {[any]: any}, new: any) -> ())
		const instance = this:get_instance()
		return function ()
			const untyped_this = this :: any
			const old = untyped_this[attribute_name]
			const new = instance:GetAttribute(attribute_name)
			
			how_set(untyped_this, new)
			
			if (private.notification_event:is_exists(this)) then
				const event_ctrl = private.notification_event:fetch(this, Event.new) :: Event.class
				event_ctrl:launch(NodeNotificationType.ValueChanged, attribute_name, new, old)
			end

			const attributes_events = private.attributes_events:fetch(this)
			const event_ctrl = attributes_events[attribute_name] :: Event.class?
			if (event_ctrl) then
				event_ctrl:emit(new, old)
			end
		end
	end

	function private.generate_rollback_for_attribute (this: class, attribute_name: string)
		const instance = this:get_instance()
		return function (arg1: any, arg2: any)
			if (arg1 ~= attribute_name) then
				return
			end
			
			const attribute_value = instance:GetAttribute(attribute_name)
			if (attribute_value ~= arg2) then
				instance:SetAttribute(attribute_name, arg2)
			end
		end
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
			const instance = this:get_instance()
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

	private.notification_new_value = Storage.new()

	function class:notificate (notification_type: number, ...)
		const this = self :: class

		assert(not project.debug_mode or typeof(notification_type) == "number", "unexpected notification enum")

		if (private.notification_event:is_exists(this)) then
			const event_ctrl = private.notification_event:fetch(this, Event.new) :: Event.class
			event_ctrl:launch(notification_type, ...)
		end
	end

	function private.wrap_class (this: class)
		const new_meta = Meta.new()
		const meta = getmetatable(this) :: {[unknown]: unknown}
		const __index = meta.__index
		const __newindex = meta.__newindex
		const changed_event_controller = private.get_changed_event_ctrl(this)

		this:watch_free_event(new_meta)
		setmetatable(this, new_meta)

		new_meta.__index = __index
		new_meta.__newindex = new_meta:wrap_newindex(__newindex, function(arg1, arg2, arg3)
			changed_event_controller:emit(arg2, arg3)

			-- on_new_value_notification
			const notificated_new_values = private.notification_new_value:fetch(this)
			if (not notificated_new_values[arg2]) then
				notificated_new_values[arg2] = true
				if (private.notification_event:is_exists(this)) then
					const event_ctrl = private.notification_event:fetch(this, Event.new) :: Event.class
					event_ctrl:launch(NodeNotificationType.NewValue, arg2)
				end
			end
		end)
	end

	function private.set_nodeclass_tag (this: class) 
		const to: Instance = this:get_instance() :: Instance
		to:AddTag(this.tag)
		to:AddTag(this.type)
	end
end

-- Этот метод не зависит от того, существует ли аттрибут на instance или инициализирована ли this.
function class:is_attribute (key: any)
	const this =  self :: class
	if ((this :: {[any]: any})[key] == nil) then
		project.console_output("for node, this current property is empty")
	end
	

	return private.get_attribute_expected_name_of(key) ~= nil
end

-- Если this был инициализирован как нода, то список будет наполнен именами аттрибутов.
function class:attributes ()
	const this = self :: class
	return private.attributes:fetch(this)
end

-- Если неправильно использовать, то это может вызывать утечки памяти.
function class:get_attribute_event (key: any)
	const this = self :: class

	if (not this:is_attribute(key)) then
		error("unexpected key to node:get_attribute_event")
	end

	return Upload.fetch(private.attributes_events:fetch(this), key, Event, function(new: Event.class)
		this:watch_free_event(function()
			new:queue_free()
		end)
	end):get_face()
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

do --get_node_by_instance region
	function class.get_node_by_instance (that: Instance)
		return Linked.get_by_instance(that) :: class
	end
end

return table.freeze(class)