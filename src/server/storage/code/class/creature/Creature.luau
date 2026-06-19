const object = require('@game/ServerStorage/code/object')
const node = require("@game/ReplicatedStorage/code/class/node/Node")
const class_names = require('@game/ReplicatedStorage/code/static/class_names')
const event = require('@game/ReplicatedStorage/code/class/event/Event')

const private = {};
const class = {__index = node}
setmetatable(class,class);

export type class = typeof(class.new()) 

class.type = class_names.creature
class.health = 100
class.run_speed = 24
class.walk_speed = 12
class.jump_height = 3
class.can_die = false
class.is_alive = false
class.alive_event = (nil::any) :: event.class
class.death_event = (nil::any) :: event.class

private.event_controller_alive = setmetatable({}::{[class]:event.class1}, {__mode='ks'})
private.event_controller_dead = setmetatable({}::{[class]:event.class1}, {__mode='ks'})

function private.set_event_controller_alive(this: class, to: event.class1)
	private.event_controller_alive[this] = to
end

function private.get_event_controller_alive(this: class)
	return private.event_controller_alive[this]
end

function private.set_event_controller_dead(this: class, to: event.class1)
	private.event_controller_dead[this] = to
end

function private.get_event_controller_dead(this: class)
	return private.event_controller_dead[this]
end

function class.new ()
	local self = object.new(class, true)
	local event_controller_alive = event.new()
	local event_controller_dead = event.new()
	
	private.set_event_controller_alive(self, event_controller_alive)
	private.set_event_controller_dead(self, event_controller_dead)

	local event_alive = event_controller_alive:get_event()
	local event_dead = event_controller_dead:get_event()
	
	self.alive_event = event_alive
	self.death_event = event_dead
	
	return self
end

function class:die()
	local this = self :: class
	this.health = 0
	private.get_event_controller_dead(this):emit()
end

function class:alive()
	local this = self :: class
	this.health = 1
	private.get_event_controller_alive(this):emit()
end

function class:check_life()
	local this = self :: class
	if (this.health <= 0) then
		this:die()
	else
		this:alive()
	end
end

table.freeze(class :: any)
return class