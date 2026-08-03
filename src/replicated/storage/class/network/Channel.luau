--!strict
const Players = game:GetService("Players")
const Node = require("@game/ReplicatedStorage/class/actors/Node")
const Maybe = require("@game/ReplicatedStorage/class/common/Maybe")
const ConnectionMode = require("@game/ReplicatedStorage/enums/ConnectionMode")
const InstanceNotificationVariant = require("@game/ReplicatedStorage/enums/notifications/InstanceNotificationVariant")
const declare = require("@game/ReplicatedStorage/static/declare")
const namefield = require("@game/ReplicatedStorage/static/namefield")

const private = {apin = "peer_id"}
const class : declare.channel = Node:new <<Node<RemoteEvent>>>{
    type = namefield.channel,
    APIN = private.apin

    invoke = function (self: declare.channel, notification: declare.notification, rpc: boolean?) : ()
        
    end,

    send = function (self: declare.channel, notification: declare.notification, rpc: boolean?) : ()
        
    end,

    get_invoke_event = function (self: declare.channel) : declare.face<...any>
        
    end,

    get_sended_event = function (self: declare.channel) : declare.face<...any>
        
    end,

    get_peerid = function (that: Player?) : number
        if not that then return 0 end
        const id = that:GetAttribute(private.apin)
        
        if type(id) == "number" then
            return id
        else
            return -1
        end
    end,

    set_peerid = function (to: number, that: Player?)
        if not that then return end

        that:SetAttribute(private.apin, to)
    end
}

class:toggle_host(function(new: declare.channel)
    const reference = new:get_reference()
    const on_instance_exists = function (notification: declare.notification)
        const instance = reference:get_instance() :: RemoteEvent

        if class.get_peerid(Players.LocalPlayer) == 0 then
            -- TODO
        end
    end

    reference:toggle_notice(on_instance_exists, InstanceNotificationVariant.InstanceNew, ConnectionMode.Connection)
    reference:toggle_notice(on_instance_exists, InstanceNotificationVariant.InstanceChanged, ConnectionMode.Connection)
    reference:toggle_notice(function (notification)

    end, InstanceNotificationVariant.InstanceNullified, ConnectionMode.Connection)
end)

do
    private.invoke = Maybe:new()
    private.sended = Maybe:new()
end

return class