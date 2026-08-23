--!strict
const UserDataRequire = require("@game/ReplicatedStorage/enums/require/UserDataRequire")
const declare = require("@game/ReplicatedStorage/static/declare")
const namefield = require("@game/ReplicatedStorage/static/namefield")
const Result = require("@game/ReplicatedStorage/struct/common/Result")

const class : declare.userdata = Result:new {
    type = namefield.userdata,
    of = UserDataRequire.Profile,
    result = { }
}

return class