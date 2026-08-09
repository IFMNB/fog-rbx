--!strict
const Node = require("@game/ReplicatedStorage/class/actors/Node")
const Maybe = require("@game/ReplicatedStorage/class/common/Maybe")
const ConnectionMode = require("@game/ReplicatedStorage/enums/ConnectionMode")
const InstanceNotificationVariant = require("@game/ReplicatedStorage/enums/notifications/InstanceNotificationVariant")
const declare = require("@game/ReplicatedStorage/static/declare")
const namefield = require("@game/ReplicatedStorage/static/namefield")
const project = require("@game/ReplicatedStorage/static/project")

const private = {}
const class : declare.channel = Node:new <<Node<RemoteEvent>>>{
    type = namefield.channel,
    peers = {}
}

return class