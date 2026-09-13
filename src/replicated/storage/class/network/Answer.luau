--!strict
const DefaultVariant = require("@game/ReplicatedStorage/enums/descriptor/DefaultVariant")
const runtimeobject = require("@game/ReplicatedStorage/runtimeobject")
const declare = require("@game/ReplicatedStorage/static/declare")
const Result = require("@game/ReplicatedStorage/struct/common/Result")

const class: declare.answer = runtimeobject:new {
    on = DefaultVariant.Unknown,

    get_answer_of = function (self: declare.answer, peer: declare.user|declare.localuser) : declare.result<unknown, ...any>
        const answer = self:get_dependency(peer.uid)
        const result = Result:new({result = answer, state = answer ~= nil})
        return result
    end,
    
    set_answer_of = function (self: declare.answer, peer: declare.user|declare.localuser, to: {any}) : ()
        self:add_dependency(peer.uid, to)
    end
}

return class