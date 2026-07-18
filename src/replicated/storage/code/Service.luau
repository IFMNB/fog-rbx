const object = require("@game/ReplicatedStorage/code/object")
const Event = require("./class/event/Event")
const Upload = require("./class/upload/Upload")
const Face = require("./class/face/Face")
const project = require("./static/project")
const namefield = require("@game/ReplicatedStorage/code/static/namefield")

const private = {}
const class = {__index = object}
setmetatable(class, class)

export type class = object.class<typeof(class)>

class.type = namefield.service
class.new = error
class.arch_new = class.new
class.errors = 0
class.actions = 0

function class:log(...)
    const this = self :: class
    const message = this.type .. tostring(...)
    private.log:ecall("emit", message)
    project.console_output(this.type, ...)
end

function class:get_log_event () : Face.class<string>
    return private.log:fetch(self :: class, Event.new):get_face()
end

private.log = Upload.new()

return table.freeze(class)