--!strict
const Reference = require("@game/ReplicatedStorage/class/common/Reference")
const Maybe = require("@game/ReplicatedStorage/class/common/gc/Maybe")
const Disposable = require("@game/ReplicatedStorage/class/core/Disposable")
const SecurityRNG = require("@game/ReplicatedStorage/class/service/SecurityRNG")
const IKR6Info = require("@game/ReplicatedStorage/class/struct/game/IKR6Info")
const ctags = require("@game/ReplicatedStorage/static/ctags")
const ctype = require("@game/ReplicatedStorage/static/ctype")
const declare = require("@game/ReplicatedStorage/static/declare")
const ftype = require("@game/ReplicatedStorage/static/ftype")
const ReferenceBasePart = require("@game/ReplicatedStorage/templates/class/reference/ReferenceBasePart")
const ReferenceHumanoid = require("@game/ReplicatedStorage/templates/class/reference/ReferenceHumanoid")

const private = {}
const class : ikr6solver = Disposable:new {
    type = "ikr6solver",

    enabled = false,
    current_idle_time = 0,
    last_work_time = 0,

    get_humanoid = ftype:write(function (self: ikr6solver) : reference<Humanoid?>
	    return private.maybe_humanoid:enactment(self, ReferenceHumanoid)
    end, Reference.type, "ikr6solver"),

    get_torso = ftype:write(function (self: ikr6solver) : reference<BasePart?>
	    return private.maybe_torso:enactment(self, ReferenceBasePart)
    end, Reference.type, "ikr6solver"),

    get_info = ftype:write(function (self: ikr6solver) : ikr6info
        return self:get <<ikr6info>> (private.info_key)
    end, IKR6Info.type, "ikr6solver"),

    set_info = ftype:write(function (self: ikr6solver, new: ikr6info): ()
        self:set(private.info_key, new)
    end, declare["nil"], "ikr6solver", IKR6Info.type),
}

do
	private.maybe_humanoid = Maybe:new() :: maybe<reference<Humanoid?>, ikr6solver>
	private.maybe_torso = Maybe:new() :: maybe<reference<BasePart?>, ikr6solver>
    private.info_key = SecurityRNG:get_hash_blake3("ikr6legs_info_key")

    ctype:read(class):write_tag(ctags.class, ctags.inverse_kinematic, ctags.immersiveness, ctags.game)
end

return class