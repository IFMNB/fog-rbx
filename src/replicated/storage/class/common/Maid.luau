--!strict
const Disposable = require("@game/ReplicatedStorage/class/arch/Disposable")
const ConnectionVariant = require("@game/ReplicatedStorage/enums/descriptor/ConnectionVariant")
const DisposableNotification = require("@game/ReplicatedStorage/enums/notification/DisposableNotification")
const declare = require("@game/ReplicatedStorage/static/declare")
const project = require("@game/ReplicatedStorage/static/project")

const private = {}
const class : declare.maid = Disposable:new {
    type = "maid",

    add_object = function (self: declare.maid, that: declare.connection|declare.disposable|RBXScriptConnection) : ()
        table.insert(private.objects[self], that)
    end,

    add_key = function <T> (self: declare.maid, of: {[T]: unknown}, key: T) : ()
        if not private.pairs[self][of] then
            private.pairs[self][of] = {}
        end

        table.insert(private.pairs[self][of], key)
    end,

    remove_object = function (self: declare.maid, that: declare.connection|declare.disposable|RBXScriptConnection) : ()
        const pos = table.find(private.objects[self], that)
        if pos then
            table.remove(private.objects[self], pos)
        end
    end,

    remove_key = function <T> (self: declare.maid, of: {[T]: unknown}, key: T) : ()
        if not private.pairs[self][of] then
            return
        end

        const pos = table.find (private.pairs[self][of], key)
        if pos then
            table.remove(private.pairs[self][of], pos)
        end
    end,
}

class:host(function(new: declare.maid)
    private.objects[new] = {}
    private.pairs[new] = setmetatable({}, private.meta)

    new:subscribe(DisposableNotification.OnRelease, ConnectionVariant.Once, function ()
        for _, v in private.objects[new] do
            if class.is(v, "connection") then
                const connection = v :: declare.connection
                connection:disconnect()
            elseif class.is(v, "disposable") then
                const disposable = v :: declare.disposable
                disposable:free()
            elseif typeof(v) == declare.roblox.RBXScriptConnection then
                const connection = v :: RBXScriptConnection
                connection:Disconnect()
            else
                project.console_out("unknown object, skip")
            end
        end

        table.clear(private.pairs[new])
    end, function ()
        for k, v in private.pairs[new] do
            for _, j in v do
                k[j] = nil
            end
        end

        table.clear(private.pairs[new])
    end)
end)

do
    private.meta = table.freeze {__mode = "ks"}
    private.objects = setmetatable({ } :: {[declare.maid]: {declare.connection|declare.disposable|RBXScriptConnection}}, private.meta)
    private.pairs = setmetatable({ } :: {[declare.maid]: {[{[unknown]: unknown}]: {unknown}}}, private.meta)
end

return class