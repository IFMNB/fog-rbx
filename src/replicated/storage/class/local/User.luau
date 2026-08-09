--!strict
const runtimeobject = require("@game/ReplicatedStorage/runtimeobject")
const declare = require("@game/ReplicatedStorage/static/declare")
const namefield = require("@game/ReplicatedStorage/static/namefield")

const class : declare.user = runtimeobject:new {
    type = namefield.user,
    unit = "" :: unknown,

    request_data = function <T> (self: declare.user, of: declare.enumitem) : declare.userdata<T>
        
    end
}

return class