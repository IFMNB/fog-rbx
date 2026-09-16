--!strict
const Players = game:GetService("Players")

const User = require("@game/ReplicatedStorage/class/local/User")
const object = require("@game/ReplicatedStorage/object")
const declare = require("@game/ReplicatedStorage/static/declare")

const class : localuser = object:new {
    type = "localuser",
    uid = 0,

    get_player = function (self: localuser) : Player
        return assert(Players.LocalPlayer, "unable in serverside")
    end,

    get_user = function (self: localuser) : profile
        return User:new({uid = self:get_player().User.Id})
    end,

    require_get_configuration = function (self: localuser, of: enumitem<any>) : result

    end,

    require_save_configuration = function (self: localuser, of: enumitem<any>, ...: unknown) : ()
        
    end
}

return class