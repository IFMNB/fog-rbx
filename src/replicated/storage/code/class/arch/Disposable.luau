--!strict

const DisposableStateVariant = require("../../enums/DisposableStateVariant")
const NotificationType = require("../../enums/NotificationType")
const runtimeobject = require("../../runtimeobject")
const declare = require("../../static/declare")
const namefield = require("../../static/namefield")
const project = require("../../static/project")
const Notification = require("../common/Notification")

const private = {}
const class : declare.disposable = runtimeobject:new({
    type = namefield.disposable,

    free = function (self: declare.disposable) : ()
        if self:get_state(DisposableStateVariant.New) then
            self:toggle_state(DisposableStateVariant.New)
        end
        if self:get_state(DisposableStateVariant.Normal) then
            self:toggle_state(DisposableStateVariant.Normal)
        end

    	self:toggle_state(DisposableStateVariant.PreRelease)
        self:notificate(Notification:new({
            call_on = NotificationType.PreRelease
        }))

        task.delay(0, function ()
            private.objects[self.identity] = nil

            self:toggle_state(DisposableStateVariant.PreRelease)
            self:toggle_state(DisposableStateVariant.Released)
        end)
    end,

    queue_free = function (self: declare.disposable) : ()
        const code = project.run(self.free, self)
        if code == 4 then
           self:get_notification_event():once(function ()
                self:free()
           end, NotificationType.Signal)
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