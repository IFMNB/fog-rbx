--!strict

const object = require('../../object');
const class_names = require('@game/ReplicatedStorage/code/static/class_names')
const connection = require("../connection/Connection")
const connection_state = require('../../enums/ConnectionState')

const private = {}
const class = {__index = object}
setmetatable(class,class);

const private1 = {}
const class1 = {__index = object}
setmetatable(class1,class1)

export type class = typeof(object.new(class))
export type generic <T0 = never, T1 = never, T2 = never, T3 = never, U = never> = setmetatable<{
	__index: typeof(object),
	type: typeof(class.type),
	connect: (class, (T0,T1,T2,T3,...U) -> ()) -> connection.class,
	once: (class, (T0,T1,T2,T3,...U) -> ()) -> connection.class,
	new: () -> class1,
	wait: (class) -> (T0,T1,T2,T3,U)
}, typeof(object)>

class.type = class_names.event

private.events_listeners = setmetatable({}::{[class]:{[connection.class]: ()->()}}, {__mode="ks"})

function class.new ()
	const self = object.new(class)
	const event_controller = class1.new(self)
	private.events_listeners[self] = {}
	
	return event_controller
end

function class:connect (func: () -> ())
	const this = self :: class
	const my_listeners = private.events_listeners[this]
	const new_connection = connection.new()
	
	new_connection.state = connection_state.connected
	new_connection.disconnect = function ()
		my_listeners[new_connection] = nil
		new_connection.state = connection_state.disconnected
		new_connection.disconnect = error :: any
	end
	
	new_connection:watch_free_event(function ()
		new_connection:disconnect()
	end)
	
	return new_connection
	
end

function class:wait () : never
	const this = self :: class
	const running_coroutine = coroutine.running()

	this:once(function(...)
		coroutine.resume(running_coroutine, ...)
	end)

	return coroutine.yield()
end

function class:once (func: () -> ())
	const this = self :: class
	const new_connection = this:connect(func)
	new_connection.state = connection_state.once
	return new_connection
end






export type class1 = typeof(class1.new(nil::any))

class1.type = "event_controller" :: "event_controller"
class1.deferred = false

private1.events = setmetatable({}::{[class1]: class}, {__mode = "ks"})

function class1.new (of_event: class)
	const new = object.new(class1, true)
	private1.events[new] = of_event
	
	new:watch_free_event(function() 
		private1.events[new] = nil
		
		for i,v in private.events_listeners[of_event] do
			i:disconnect()
		end
		
		new:clear_all()
	end)
	
	return new
end

function class1:get_event()
	const this = self :: class1
	return private1.events[this]
end

function class1:is_exists()
	const this = self :: class1
	return this:get_event() ~= nil
end

function class1:clear_all()
	const this = self :: class1
	const event = this:get_event()
	
	if event then
		for i,v in private.events_listeners[event] do
			i:disconnect()
		end
		
		return true
	else
		return false
	end
end

function class1:emit(...: any)
	const this = self :: class1
	const event = assert(this:get_event())
	const connections = private.events_listeners[event]
	const to_clear : {connection.class} = {}
	
	for i,v in connections do
		if (i.state == connection_state.connected) then
			if (this.deferred) then
				task.defer(v, ...)
			else
				task.spawn(v, ...)
			end
			
		elseif (i.state == connection_state.once) then
			if (this.deferred) then
				task.defer(v, ...)
			else
				task.spawn(v, ...)
			end
			
			table.insert(to_clear,i)
		elseif (i.state == connection_state.disconnected) then
			table.insert(to_clear,i)
		end
	end
	
	for i,v in to_clear do
		v:disconnect()
	end
end

table.freeze(class :: any)
table.freeze(class1 :: any)
return class