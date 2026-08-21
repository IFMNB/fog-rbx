--!strict
const UserDataRequire = require("@game/ReplicatedStorage/enums/require/UserDataRequire")
const runtimeobject = require("@game/ReplicatedStorage/runtimeobject")
const declare = require("@game/ReplicatedStorage/static/declare")
const namefield = require("@game/ReplicatedStorage/static/namefield")

const class : declare.userdata = runtimeobject:new {
    type = namefield.userdata,
    stored = nil,
    datatype = UserDataRequire.Profile,
}

return class