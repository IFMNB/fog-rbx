--!strict

const object = require("@game/ReplicatedStorage/code/object")
const World = require("@game/ReplicatedStorage/code/service/world/World")
const project = require("@game/ReplicatedStorage/code/static/project")
const Disposable = require("../../Disposable")
const Upload = require("../upload/Upload")
const Storage = require("../storage/Storage")
const Event = require("@game/ReplicatedStorage/code/class/event/Event")
const namefield = require("@game/ReplicatedStorage/code/static/namefield")

const private = {}
const class = {__index = Disposable}
setmetatable(class, class)

export type class = object.class<typeof(class)>

class.type = namefield.timer
class.time_to_wait = project.default_timer_time_to_wait
class.stepped_modificator = project.default_timer_time_stepped_modificator

private.metadata = Storage.new()

function class.new (time_to_wait: number|DateTime?)
    const this = Disposable.new(class, true)

    if (time_to_wait) then
        this.time_to_wait = time_to_wait
    end

    return this
end

function class:get_stepped_event()
    const this : class = self
    const metadata = private.metadata:fetch(this)
    return Upload.fetch(metadata, "stepped_event", Event.new):get_face()
end


function class:get_start_event()
    const this : class = self
    const metadata = private.metadata:fetch(this)
    return Upload.fetch(metadata, "start_event", Event.new):get_face()
end


function class:get_end_event()
    const this : class = self
    const metadata = private.metadata:fetch(this)
    return Upload.fetch(metadata, "end_event", Event.new):get_face()
end

function class:is_running() : boolean
    const this : class = self
    const metadata = private.metadata:fetch(this)
    return metadata.run or false
end

function class:get_current_runtime () : number
    const this : class = self
    const metadata = private.metadata:fetch(this)
    return metadata.runtime or 0
end

function class:start(service: boolean?) : ()
    const this : class = self
    const metadata = private.metadata:fetch(this)
    const thread = coroutine.running()

    metadata.run = true
    metadata.runtime = 0
    task.spawn(function ()
        if (metadata.start_event) then
            metadata.start_event:emit()
        end

        repeat
            if (service) then
                this:wait_service()
            else
                this:wait()
            end

            if (metadata.stepped_event) then
                metadata.stepped_event:emit()
            end

            metadata.runtime += 1 * this.stepped_modificator

            const T = typeof(this.time_to_wait)
            if (T == "DateTime") then
                const time = this.time_to_wait :: DateTime
                if (time.UnixTimestampMillis <= DateTime.now().UnixTimestampMillis) then
                    break
                end
            elseif (T == "number") then
                if (metadata.runtime >= this.time_to_wait) then
                    break
                end
            else
                this.time_to_wait = metadata.runtime + 1
                assert(not project.debug_mode, "unknown time_to_wait type")
            end

        until (metadata.run)

        if (metadata.end_event) then
            metadata.end_event:emit()
        end

        coroutine.resume(thread)
    end)

    return coroutine.yield()
end

-- Вызывает ожидание с учетом модификатора скорости работы игры
function class:wait() : ()
    const this = self :: class
    task.wait(this:get_wait_time())
end

function class:get_wait_time ()
    const this = self :: class
    const T = typeof(this.time_to_wait)

    if (T == "DateTime") then
        const date_time = this.time_to_wait :: DateTime
        return (DateTime.now().UnixTimestampMillis - date_time.UnixTimestampMillis) * World.time_scale
    elseif (T == "number") then
        const num_time = this.time_to_wait :: number
        return num_time * World.time_scale
    else
        assert(not project.debug_mode, "unexpected wait_time type")
        return project.default_timer_time_to_wait :: number
    end
end

-- Вызывает ожидание с учетом модификатора скорости работы инфраструктуры
function class:wait_service() : ()
    const this = self :: class
    task.wait(this:get_service_wait_time())
end

function class:get_service_wait_time ()
    const this = self :: class
    const T = typeof(this.time_to_wait)

    if (T == "DateTime") then
        const date_time = this.time_to_wait :: DateTime
        return (DateTime.now().UnixTimestampMillis - date_time.UnixTimestampMillis) * World.service_time_scale
    elseif (T == "number") then
        const num_time = this.time_to_wait :: number
        return num_time * World.service_time_scale
    else
        assert(not project.debug_mode, "unexpected wait_time type")
        return project.default_timer_time_to_wait :: number
    end
end

function class:stop ()
    const this : class = self
    const metadata = private.metadata:fetch(this)
    metadata.run = false
end

return table.freeze(class)