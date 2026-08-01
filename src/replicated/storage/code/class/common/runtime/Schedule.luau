--!strict

const Controller = require("@game/ReplicatedStorage/code/class/common/runtime/Controller")
const Timer = require("@game/ReplicatedStorage/code/class/common/runtime/Timer")
const runtimeobject = require("@game/ReplicatedStorage/code/runtimeobject")
const declare = require("@game/ReplicatedStorage/code/static/declare")
const namefield = require("@game/ReplicatedStorage/code/static/namefield")

const private = {}
const class : declare.schedule = runtimeobject:new {
    type = namefield.schedule,

    get_control = function(self: declare.schedule): declare.controller
        return private.controllers[self]
    end,

    get_loop = function(self: declare.schedule): declare.timer
        return private.loops[self]
    end,
}

class:toggle_host(function(new: declare.schedule)
    const controller = Controller:new()
    const loop = Timer:new({ seconds = math.huge })

    private.controllers[new] = controller
    private.loops[new] = loop

    controller:get_notification_event():connect(new)
    loop:get_notification_event():connect(new)
end)

do
    private.frozen = table.freeze {__mode = "ks"}
    private.loops = setmetatable({} :: {[declare.schedule]: declare.timer}, private.frozen)
    private.controllers = setmetatable({} :: {[declare.schedule]: declare.controller}, private.frozen)
end

return class