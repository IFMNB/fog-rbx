const object = require("@game/ReplicatedStorage/code/object")
const Node = require("@game/ReplicatedStorage/code/class/node/Node")
const namefield = require("@game/ReplicatedStorage/code/static/namefield")

const private = {}
const class = {}
setmetatable(class, table.freeze {__index = Node})

export type class = object.class<typeof(class)>

class.type = namefield.world
class.name = "Akuila & Flevington"
class.time_scale = 1
class.service_time_scale = 1
class.speed_scale = 1
class.damage_scale = 1
class.gravity_scale = 1
class.chunk_size = Vector3.new(32,32,32)

class.process = function (base: object.class, delta_time: number)
    
end

do
    const world = object.new(class, false)
    world:initiate(workspace)

    private.singletone = table.freeze(object.new(class, false))
    table.freeze(private)
    table.freeze(class)
end

return private.singletone