--!strict
const Path = require("@game/ReplicatedStorage/class/core/Path")
const Service = require("@game/ReplicatedStorage/class/core/Service")
const declare = require("@game/ReplicatedStorage/static/declare")
const project = require("@game/ReplicatedStorage/static/project")

const private = {}
const class : parallel = Service:new {
    type = "parallel",

    get_worker = function (self: parallel) : ...Actor
        return unpack(private.workers)
    end,

    add_worker = function (self: parallel, ...: Script|LocalScript|string|path) : Actor
        const worker = Instance.new("Actor")

        for _, v in {...} do
            const T = typeof(v)
            
            if T == declare.roblox.Instance or T == declare.string then
                const new_path = Path:new()
                new_path:set_path(v :: Instance|string)
                
                const output = new_path:get_object()
                if not output then
                    project.console_out_error("cannot find required element of parallel spawn, skip")
                    continue
                end

                if not output:IsA("Script") or output:IsA("LocalScript") then
                    project.console_out_error("cannot require unsupported element, skip")
                    continue
                end

                const clone = output:Clone()
                clone.Parent = worker
                clone.Enabled = true
            else
                project.console_out_error("unknown parallel spawn request, skip")
                continue
            end
        end

        table.insert(private.workers, worker)
        worker.Destroying:Once(function()
            table.remove(private.workers, table.find(private.workers, worker) or 0)
        end)

        worker.Parent = script

        return worker
    end,

    rem_worker = function (self: parallel, ...: Actor) : ()
        for _, v in {...} do
            v:Destroy()
        end
    end
}

do
    private.workers = setmetatable({} :: {Actor}, declare.tables.__mode_vs)
end

return class