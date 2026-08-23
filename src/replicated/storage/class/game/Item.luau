--!strict
const Node = require("@game/ReplicatedStorage/class/actors/Node")
const declare = require("@game/ReplicatedStorage/static/declare")
const namefield = require("@game/ReplicatedStorage/static/namefield")

const class : declare.item = Node:new <<declare.node<Model>>> {
    type = namefield.item, 
    equipable = false,
    dropable = false,
    deliverable = false,
    name = "",
}

class:host(function(new: declare.item)
    
end)

return class