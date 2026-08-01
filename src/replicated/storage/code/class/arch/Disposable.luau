--!strict
const Notification = require("@game/ReplicatedStorage/code/class/common/Notification")
const ConnectionMode = require("@game/ReplicatedStorage/code/enums/ConnectionMode")
const DisposableStateVariant = require("@game/ReplicatedStorage/code/enums/DisposableStateVariant")
const NotificationVariant = require("@game/ReplicatedStorage/code/enums/notifications/NotificationVariant")
const runtimeobject = require("@game/ReplicatedStorage/code/runtimeobject")
const declare = require("@game/ReplicatedStorage/code/static/declare")
const namefield = require("@game/ReplicatedStorage/code/static/namefield")
const project = require("@game/ReplicatedStorage/code/static/project")

const private = {}
const class : declare.disposable = runtimeobject:new({
    type = namefield.disposable,

    free = function (self: declare.disposable) : ()
        if self:get_state(DisposableStateVariant.Released) then
            return
        end

        if self:get_state(DisposableStateVariant.New) then
            self:toggle_state(DisposableStateVariant.New)
        end
        if self:get_state(DisposableStateVariant.Normal) then
            self:toggle_state(DisposableStateVariant.Normal)
        end
        if not self:get_state(DisposableStateVariant.PreRelease) then
		    self:toggle_state(DisposableStateVariant.PreRelease)
        end

        self:notificate(Notification:new({
            call_on = NotificationVariant.PreRelease
        }))

        task.delay(0, function ()
            private.objects[self.identity] = nil

            self:toggle_state(DisposableStateVariant.PreRelease)
            self:toggle_state(DisposableStateVariant.Released)
        end)
    end,

    queue_free = function (self: declare.disposable) : ()
        if not self:get_state(DisposableStateVariant.PreRelease) then
            self:toggle_state(DisposableStateVariant.PreRelease)
        end

        const code = project.run(self.free, self)

        if code == 4 then
           self:toggle_notice(function ()
                self:free()
           end, NotificationVariant.Signal, ConnectionMode.Once)
        end
    end,

    get_state = function (self: declare.disposable, of: declare.enumitem) : boolean
        for _, v in private.get_direct(self).states :: {declare.enumitem} do
            if v:equals(of) then
                return true
            end
        end

        return false
    end,

    toggle_state = function (self: declare.disposable, state: declare.enumitem) : ()
        const direct = private.get_direct(self)
        const pos = table.find(direct.states, state)

        if pos then
            table.remove(direct.states, pos)
        else
            table.insert(direct.states, state)
        end
    end
})

class:toggle_host(function(new: declare.disposable)
    private.objects[new.identity] = {
        self = new,
        states = {}
    }

    new:toggle_state(DisposableStateVariant.New)
    task.delay(0, function ()
        new:toggle_state(DisposableStateVariant.New)
        new:toggle_state(DisposableStateVariant.Normal)
    end)

    new:toggle_notice(function ()
        new:queue_free()
    end, NotificationVariant.PreRelease, ConnectionMode.Once)
end)

class:toggle_state(DisposableStateVariant.Normal)


do
    type direct = {
        self: declare.disposable,
        states: {declare.enumitem}
    }

    private.objects = {} :: {[unknown]: direct}

    function private.get_direct (of: declare.disposable)
        return private.objects[of.identity] or { self = of, states = { }} :: direct
    end
end

return class