const Service = require("../../Service")
const Event = require("../../class/event/Event")
const Upload = require("../../class/upload/Upload")

const object = require("../../object")
const namefield = require("../../static/namefield")

const private = {}
const class = {}
setmetatable(class, {__index = Service})

class.type = namefield.anime

do --init_region
    const anime = object.new(class, class.type)
    private.singletone = anime

    table.freeze(private)
    table.freeze(class)
end

return private.singletone