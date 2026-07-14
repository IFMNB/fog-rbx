const object = require "@game/ReplicatedStorage/code/object" 
const Result = require("./Result")
const namefield = require('@game/ReplicatedStorage/code/static/namefield')

const class = {__index = object}
setmetatable(class, class)

export type class = object.class<typeof(class)>

class.type = namefield.raycast
class.from = Vector3.zero
class.to = Vector3.zero
class.direction = Vector3.new()
class.mult = 1
class.params = nil :: RaycastParams?
class.result = Result :: Result.class<RaycastResult>

function class.new ()
	return object.new(class, true)
end

function class:recalculate ()
	const this = self :: class
	this.direction = (this.to - this.from) * this.mult
end

function class:raycast()
	const this = self :: class
	local result = workspace:Raycast(this.from, this.direction, this.params)
	
	if (result) then
		this.result = Result.new(true, result)
		return true
	else
		this.result = false
		return false
	end
end

function class:set_to(to: Vector3)
	const this = self :: class
	this.to = to
	this:recalculate()
end

function class:set_from(from: Vector3)
	const this = self :: class
	this.from = from
	this:recalculate()
end

table.freeze(class :: any)
return class