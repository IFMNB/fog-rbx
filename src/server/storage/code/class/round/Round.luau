const Disposable = require("@game/ReplicatedStorage/code/Disposable")
const object = require("@game/ReplicatedStorage/code/object")
const namefield = require("@game/ReplicatedStorage/code/static/namefield")
const project = require("@game/ReplicatedStorage/code/static/project")
const RoundMode = require("../../enums/RoundMode")

const private = {}
const class = {__index = Disposable}
setmetatable(class, class)

export type class = object.class<typeof(class)>

class.type = namefield.round
class.mode = RoundMode.trench_warfare



function class.new ()
    return Disposable.new(class, true)
end

table.freeze(class)
return class