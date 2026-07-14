const Disposable = require("@game/ReplicatedStorage/code/Disposable")
const Event = require("@game/ReplicatedStorage/code/class/event/Event")
const object = require('@game/ReplicatedStorage/code/object')
const node = require("@game/ReplicatedStorage/code/class/node/Node")
const namefield = require('@game/ReplicatedStorage/code/static/namefield')
const Storage = require("@game/ReplicatedStorage/code/class/storage/Storage")
const Upload = require("@game/ReplicatedStorage/code/class/upload/Upload")
const Value = require("@game/ReplicatedStorage/code/class/value/Value")
const NodeNotificationType = require("@game/ReplicatedStorage/code/enums/NodeNotificationType")

const private = {};
const class = {__index = node}
setmetatable(class,class);

export type class = object.class<typeof(class)>

class.type = namefield.entity

function class.new ()
	return Disposable.new(class, true)
end

function class:get_health () : Value.generic<number>
	const this = self :: class
	const name = "health"
	return Upload.fetch(private.metadata:fetch(this), name, function ()
		const new_value = Value.new("number")
		new_value:bind_attribute(this, name)
		this:notificate(NodeNotificationType.new_lazy_value, name)
		return new_value 
	end)
end

--[[
	Генерирует для своей работы this:get_health():get_changed_event()
]]
function class:get_death_event ()
	const this = self :: class
	const name = "death_event"
	return Upload.fetch(private.metadata:fetch(this), name, function()
		const new = Event.new()
		const health = this:get_health()
		const changed = health:get_changed_event()
		local emitted = false
		changed:connect(function(a0, a1)
			if (a1 > 0 and a0 <= 0) then
				if (not emitted) then
					new:emit()
					emitted = true
				end
			else
				emitted = false
			end
		end)

		health:watch_free_event(function()
			new:free()
		end)

		this:notificate(NodeNotificationType.new_lazy_value, name)
		return new
	end):get_face()
end


private.metadata = Storage.new()

return table.freeze(class)