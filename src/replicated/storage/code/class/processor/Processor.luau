--[[
	TODO

	@IFMNB
	я удалил рантайм для этого класса, его надо будет написать
	+ добавить поддержку RuntimeVariant.luau енама

]]

const object = require("@game/ReplicatedStorage/code/object")
const NodeProcessState = require("@game/ReplicatedStorage/code/enums/NodeProcessState")
const namefield = require("@game/ReplicatedStorage/code/static/namefield")
const project = require("@game/ReplicatedStorage/code/static/project")
const Event = require("@game/ReplicatedStorage/code/class/event/Event")
const storage = require("@game/ReplicatedStorage/code/class/storage/Storage")
const Disposable = require("../../Disposable")
const Upload = require("../upload/Upload")
const Node = require("@game/ReplicatedStorage/code/class/node/Node")

const private = {}
const class = {__index = Node}
setmetatable(class, class)

export type class = object.class<typeof(class)>

class.type = namefield.processor
class.tag = "@processor"
class.process_state = NodeProcessState.operational
class.node_process_hertz = project.default_processor_hertz

function class.new ()
    return Disposable.new (class, true)
end

function class:ready (base: class)
	
end
function class:process (delta_time: number)
	
end

function class:simulation (delta_time: number)
	
end

function class:get_ready_event ()
	const this = self :: class
	return private.ready:fetch(this, Event.new):get_face()
end

function class:get_process_stepped_event ()
	const this = self :: class
	return private.process_stepped:fetch(this, Event.new):get_face()
end


private.metadata = storage.new()
private.ready = Upload.new()
private.workbench = Upload.new()

return table.freeze(class)