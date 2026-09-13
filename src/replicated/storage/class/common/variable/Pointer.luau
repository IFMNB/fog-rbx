--!strict
const runtimeobject = require("@game/ReplicatedStorage/runtimeobject")
const declare = require("@game/ReplicatedStorage/static/declare")
const ftype = require("@game/ReplicatedStorage/static/ftype")
const project = require("@game/ReplicatedStorage/static/project")

const private = {}
const class : declare.pointer = runtimeobject:new {
    type = "pointer",
    set_point = ftype:write(function <Y> (self: declare.pointer, to: Y, hard: boolean?): ()
        if project.assert(private.points_set[self], "cannot reload existed point, ") then return end
        private.points_set[self] = true

        if hard then
            private.points_hard[self] = to
        else
            private.points[self] = to
        end
    end, declare["nil"], "pointer", declare.anyt, ftype:opt(declare.boolean)),

    get_pointed = ftype:write(function (self: declare.pointer) : unknown
        if private.points_set[self] ~= true then
            return nil
        end

        if self:is_pointed_hard() then
            return private.points_hard[self]
        end

        return private.points[self]
    end, ftype:opt(declare.anyt), "pointer"),

    is_pointed_hard = ftype:write(function (self: declare.pointer) : boolean
        return private.points_hard[self] ~= nil
    end, declare.boolean, "pointer"),

    is_pointed_exists = ftype:write(function (self: declare.pointer) : boolean
        return private.points_set[self] == true and (private.points[self] ~= nil or self:is_pointed_hard())
    end, declare.boolean, "pointer")
}

do
    type list <T = unknown> = {[declare.pointer]: T}

    private.meta = table.freeze {__mode = "ks"}
    private.points_set = setmetatable({} :: list<boolean>, private.meta)
    private.points_hard = setmetatable({} :: list<unknown>, private.meta)
	private.points = setmetatable({} :: list<unknown>, table.freeze({ __mode = "kvs" }))
end

return class