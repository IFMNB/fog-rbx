const object = require("@game/ReplicatedStorage/code/object")
const RigType = require("../../enums/RigType")
const namefield = require("@game/ReplicatedStorage/code/static/namefield")

const private = {}
const class = {}
setmetatable(class, {__index = object})

export type class = object.class<typeof(class)>

class.type = namefield.rigdescriptor
class.rig = RigType.R6

return table.freeze(class)