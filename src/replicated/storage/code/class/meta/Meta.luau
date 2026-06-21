const object = require "@game/ReplicatedStorage/code/object"
const class_names = require("../../static/class_names")

const class = {}
setmetatable(class, {__index = object})

export type class = typeof(class.new())
type table = setmetatable<{[any]:any}, {[any]:any}>
type __index = (table|(table,any) -> any|unknown)?
type __newindex = (table|(table,any,any)->()|unknown)?


class.type = class_names.meta
class.__index = nil :: __index
class.__newindex = nil :: __newindex
class.__metatable = nil :: any
class.override_newindex = false

function class.new ()
    return object.new(class, true)
end

function class:wrap_index (__index: __index?, set: (arg1: table, arg2: any) -> ()) : __index
    const type_index = type(__index)

    if (type_index == "table") then
        return function (arg1, arg2)
            set(arg1, arg2)
            return arg1[arg2]
        end
    elseif (type_index == "function") then
        return function (arg1, arg2)
            set(arg1, arg2)
            return __index(arg1, arg2)
        end
    else
        error("unexpected __index type")
    end
end

function class:wrap_newindex (__newindex: __newindex, set: (arg1: table, arg2: any, arg3: any) -> ()) : __newindex
    const this = self :: class
    const type_newindex = type(__newindex)

    if (type_newindex == "table") then
        return function (arg1, arg2, arg3)
            if (this.override_newindex) then
                arg1[arg2] = arg3
                set(arg1,arg2,arg3)
            else
                set(arg1,arg2,arg3)
                arg1[arg2] = arg3
            end
        end
    elseif (type_newindex == "function") then
        return function (arg1, arg2, arg3)
            if (this.override_newindex) then
                __newindex(arg1,arg2,arg3)
                set(arg1,arg2,arg3)
            else
                set(arg1,arg2,arg3)
                __newindex(arg1,arg2,arg3)
            end
        end
    else
        error("unexpected __newindex type")
    end
end

function class:lock()
    const this = self :: class
    const meta = getmetatable(this)

    this.__metatable = "@class meta"
    table.freeze(this)
    
    if (meta) then
        table.freeze(meta)
    end
end

table.freeze(class :: any)
return class