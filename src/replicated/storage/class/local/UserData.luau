--!strict
const EnumObject = require("@game/ReplicatedStorage/class/arch/EnumObject")
const runtimeobject = require("@game/ReplicatedStorage/runtimeobject")
const declare = require("@game/ReplicatedStorage/static/declare")
const namefield = require("@game/ReplicatedStorage/static/namefield")

const class : declare.userdata = runtimeobject:new {
    type = namefield.userdata,
    stored = {},
    datatype = EnumObject.Unknown,

    
}

return class