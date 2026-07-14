const object = require "@game/ReplicatedStorage/code/object"
const project = require("@game/ReplicatedStorage/code/static/project")
const Disposable = require("../../Disposable")
const namefield = require("@game/ReplicatedStorage/code/static/namefield")

const class = {}
setmetatable(class, {__index = Disposable})

export type class = object.class<typeof(class)>
type table = setmetatable<{[any]:any}, {[any]:any}>
type __index = (table|(table,any) -> any|unknown)?
type __newindex = (table|(table,any,any)->()|unknown)?


class.type = namefield.meta
class.__index = nil :: __index
class.__newindex = nil :: __newindex
class.__metatable = nil :: any
class.override_newindex = false

function class.new ()
    return Disposable.new(class, true)
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
    elseif (type_newindex == "nil") then
        return nil :: never
    else
        if (project.debug_mode) then
            error("unexpected __newindex type")
        end
        return nil :: never
    end
end

function class:lock()
    const this = self :: class
    const meta = getmetatable(this)

    this.__metatable = "Meta.class @object"
    table.freeze(this)
    
    if (meta) then
        table.freeze(meta)
    end
end

function class:wrap (that: {})
    const this = self :: class
    const metatable = getmetatable(that)

    if (type(metatable) ~= "table") then
        project.console_output "cannot wrap this table, because of __metatable field"
        return
    end

    if (metatable) then
        if (object.is(metatable, class.type)) then
            project.console_output "cannot wrap already wrapped table"  
        else
            for i,v in metatable :: {[unknown]: unknown} do
                if (v == "__index") then
                    if (this.__index) then
                        this:wrap_index(v,this.__index)
                    else
                        this.__index = v
                    end
                    continue
                end

                if (v == "__newindex") then
                    if (this.__newindex) then
                        this:wrap_newindex(v,this.__newindex)
                    else
                        this.__newindex = v
                    end
                    continue
                end

                this[i] = v
            end
        end
    else
        setmetatable(that,this)
    end

    return
end

return table.freeze(class)