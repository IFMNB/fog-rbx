const Disposable = require("@game/ReplicatedStorage/Disposable")
const object = require("@game/ReplicatedStorage/object")
const namefield = require("@game/ReplicatedStorage/static/namefield")
const project = require("@game/ReplicatedStorage/static/project")
const RoundMode = require("../../enums/RoundMode")

const private = {}
const class = { __index = Disposable }
setmetatable(class, class)

export type class = object.class<typeof(class)>

class.type = namefield.round
class.mode = RoundMode.trench_warfare

function class.new()
	return Disposable.new(class, true)
end

table.freeze(class)
return class
