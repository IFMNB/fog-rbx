const HttpService = game:GetService("HttpService")
const Disposable = require("@game/ReplicatedStorage/code/Disposable")
const Event = require("@game/ReplicatedStorage/code/class/event/Event")
const Face = require("@game/ReplicatedStorage/code/class/face/Face")
const Storage = require("@game/ReplicatedStorage/code/class/storage/Storage")
const Upload = require("@game/ReplicatedStorage/code/class/upload/Upload")
const object = require("@game/ReplicatedStorage/code/object")
const namefield = require("@game/ReplicatedStorage/code/static/namefield")
const Result = require("@game/ReplicatedStorage/code/struct/Result")

const private = {}
const class = {}
setmetatable(class, {__index = Disposable})

type request_result = Result.class<{[string]: unknown}>
export type class = object.class<typeof(class)>

class.type = namefield.httprequest
class.address = ""
class.nocache = false
class.headers = nil :: any
class.last = Result

function class.new (address: string?)
    const this = Disposable.new(class, true)

    if (address) then
        this.address = address
    end

    return this
end

function class:get_response_async () : request_result
    const this = self :: class
    this:request_response()
    return this:get_response_event():wait()
end

function class:request_response ()
    const this = self :: class
    task.spawn(function ()
        this:request_response_async()
    end)
end

function class:request_response_async () : ()
    const this = self :: class
    const metadata = private.metadata:fetch(this)
    local state = false

    const json_data = Result.call_of(function()
        return HttpService:GetAsync(this.address, this.nocache, this.headers)
    end)

    if (json_data.state) then
        const data = Result.call_of(function(json_string: string) : {[string]: unknown}
            return HttpService:JSONDecode(json_string)
        end, json_data.result)

        if (data.state) then
            this.last = data
            state = true
        end
    end

    if (this.last ~= Result and not state) then
        object.queue_free(this.last)
        this.last = nil
    end

    if (metadata.response_event) then
        metadata.response_event:emit(this.last)
    end
end


function class:get_response_event () : Face.class<request_result>
    const this = self :: class
    return Upload.fetch(private.metadata:fetch(this), "response_event", Event):get_face()
end

private.metadata = Storage.new()

return table.freeze(class)