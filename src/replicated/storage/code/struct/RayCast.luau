--!strict

const object = require "@game/ReplicatedStorage/code/object" 
const Record = require("../Record")
const Result = require("./Result")
const namefield = require('@game/ReplicatedStorage/code/static/namefield')

const class = {}

export type class = Record.extend<typeof(class)>
export type extend<T = {}> = object.class<T, class>

class.type = namefield.raycast 
class.from = Vector3.zero
class.to = Vector3.zero
class.direction = Vector3.new()
class.mult = 1
class.params = nil :: RaycastParams?
class.result = (Result :: any) :: Result.class<RaycastResult>

function class.new ()
	return Record.new(class) :: class
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
		this.result = Result.new(false, result :: any)
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

return table.freeze(class)