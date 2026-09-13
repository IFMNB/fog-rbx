--!strict
const Players = game:GetService("Players")

const User = require("@game/ReplicatedStorage/class/local/User")
const UserDataChannel = require("@game/ReplicatedStorage/internal/UserDataChannel")
const object = require("@game/ReplicatedStorage/object")
const runtimeobject = require("@game/ReplicatedStorage/runtimeobject")
const declare = require("@game/ReplicatedStorage/static/declare")

const class : declare.localuser = runtimeobject:new {
    type = "localuser",
    uid = 0,

    get_player = function (self: declare.localuser) : Player
        return assert(Players.LocalPlayer, "unable in serverside")
    end,

    get_user = function (self: declare.localuser) : declare.user
        return User:new({uid = self:get_player().User.Id})
    end,

    require_get_configuration = function (self: declare.localuser, of: declare.enumitem<any>) : declare.result
        UserDataChannel:sync(of)
    end,

    require_save_configuration = function (self: declare.localuser, of: declare.enumitem<any>, ...: unknown) : ()
        
    end
}

return class