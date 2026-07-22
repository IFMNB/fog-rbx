--!strict

const object = require "@game/ReplicatedStorage/code/object"
const project = require("@game/ReplicatedStorage/code/static/project")
const namefield = require("@game/ReplicatedStorage/code/static/namefield")

const private = {}
const class = {}
setmetatable(class, {__index = object})

export type class <T = {[string]: any}> = object.class<setmetatable<{
    class: T,
    add: <U> (self: unknown, to: metamethods & U, f: methode<T>) -> (),
    remove: <U> (self: unknown, from: metamethods & U, f: methode<T>) -> (),
    set_main: <U> (self: unknown, to: metamethods & U, f: methode<T>?) -> ()
}, {__index: typeof(class)}>>
type table = setmetatable<{[any]:any}, {[any]: any}>
type default = setmetatable<{[any]: any}, {[any]: any}>
type methode <E = default, T... = ...unknown, U... = ...unknown> = (self: E, U...) -> T...
type metas<T = default> = {
	__index: methode<T, index<T, keyof<T>>, keyof<T>> | table | nil,
	__newindex: methode<T, keyof<T>, index<T, keyof<T>>> | table | nil,
	__metatable: unknown,
	__add: methode<T,number, number>?,
	__sub: methode<T,number, number>?,
	__mul: methode<T,number, number>?,
	__div: methode<T,number, number>?,
	__idiv: methode<T,number, number>?,
	__mod: methode<T,number, number>?,
	__pow: methode<T,number, number>?,
	__unm: methode<T,number, number>?,
	__band: methode<T>?,
	__bor: methode<T>?,
	__bxor: methode<T>?,
	__bnot: methode<T>?,
	__shl: methode<T>?,
	__shr: methode<T>?,
	__concat: methode<T, string, string>?,
	__len: methode<T, number>?,
	__eq: methode<T, boolean>?,
	__lt: methode<T, boolean>?,
	__le: methode<T, boolean>?,
	__call: methode<T, unknown, unknown>?,
	__tostring: methode<T, string>?,
	__iter: methode<T>?,
	__mode: (string | ("s"|"k"|"v"|"kv"|"kvs"))?,
	__gc: methode<T>?,
	__close: methode<T>?,
}

type function get_meta (T: type)
    if not T:is("table") then
        error("Can only call keyof on tables.")
    end

    local union = nil
    for property : type in T:properties() do
        if property:is("singleton") then
            if string.find(tostring(property:value()), "__") then
				union = if union then types.unionof(union, property) else property
            end
        end
    end

    return if union then union else types.singleton(nil)
end

export type metamethods = get_meta<metas>



class.type = namefield.meta

--[=[
    Подробнее об этом свойстве можно найти в `object`
]=]
class.class = nil :: class?

--[=[
    Будут ли вызваны сторонние подключения по этому метаметоду
]=]
class.exec = true
--[=[
    Вызывать main функцию только после вызова сторонних подключений
]=]
class.main_after = false
--[=[
    Будет ли вызвана main функция по этому метаметоду
]=]
class.main = true

class.__index = table.freeze {} :: (methode<table, index<table, keyof<table>>, keyof<table>> | table | nil)
class.__newindex = nil :: (methode<table, keyof<table>, index<table, keyof<table>>> | table | nil)
class.__metatable = nil :: unknown
class.__add = nil :: methode<table, number, number>?
class.__sub = nil :: methode<table, number, number>?
class.__mul = nil :: methode<table, number, number>?
class.__div = nil :: methode<table, number, number>?
class.__idiv = nil :: methode<table, number, number>?
class.__mod = nil :: methode<table, number, number>?
class.__pow = nil :: methode<table, number, number>?
class.__unm = nil :: methode<table, number, number>?
class.__band = nil :: methode<table>?
class.__bor = nil :: methode<table>?
class.__bxor = nil :: methode<table>?
class.__bnot = nil :: methode<table>?
class.__shl = nil :: methode<table>?
class.__shr = nil :: methode<table>?
class.__concat = nil :: methode<table, string, string>?
class.__len = nil :: methode<table, number>?
class.__eq = nil :: methode<table, boolean>?
class.__lt = nil :: methode<table, boolean>?
class.__le = nil :: methode<table, boolean>?
class.__call = nil :: methode<table, unknown, unknown>?
class.__tostring = nil :: methode<table, string>?
class.__iter = nil :: methode<table>?
class.__mode = nil :: (string | ("s" | "k" | "v" | "kv" | "kvs"))?
class.__gc = nil :: methode<table>?
class.__close = nil :: methode<table>?

function class.new<T>()
    const this = object.new(class, class.type)
    return this :: class<T>
end

--[=[
    Устанавливает main функцию на этот метаметод, а следовательно и активируя
    всех сторонних подключенных наблюдателей на этот метаметод

    Установка nil отключает другие наблюдатели
]=]
function class:set_main <T> (to: metamethods & T, f: methode<table>|table?)
    const this = self :: class
    const T = type(f)
    f = f :: any

    if f then
        this[to] = function (...) : ...unknown
            local result
            const args = {...}

            if T == "function" and this.main and not this.main_after then
                result = {f(...)}
            end

            if this.exec then
                private.exe(this, to, ...)
            end

            if T == "function" and this.main and this.main_after then
                result = {f(...)}
            end

            if T == "function" then
                return unpack(result or {})
            end

            if T == "table" then
                if to == "__index" then
                    return f[args[2]]
                else
                    project.console_output "unexpected behaviour of tables: metamethode does not support table-type"
                    this:set_main(to, nil)
                    return
                end
            end
        end
    else
        (this::any)[to] = nil
    end
end

--[=[
    Встраивает пустышку взамен main, позволяя сторонним наблюдателям активироваться
    при фактическом отсутствии main функции

    Определенно вызовет баги при неправильном использовании, поскольку пустышка
    совсем ничего не возвращает и при этом перезаписывает стандартные метаметоды
    которые `LVM` может поставлять на данный тип. Скорее является тест-функцией,
    поэтому не рекомендуется к использованию
]=]
function class.set_main_empty <T> (self: class, to: metamethods & T)
    const this = self :: class
    this:set_main(to, private.empty)
end

--[=[
    Добавить стороннего наблюдателя на метаметод
]=]
function class:add <T> (to: metamethods & T, f: methode<table> )
    const this = self :: class
    const mt = private.get_mt_to(this, to)

    table.insert(mt, f)
end

--[=[
    Удалить стороннего наблюдателя с метаметода
]=]
function class:remove <T> (from: metamethods & T, f: methode<table>)
	const this = self :: class
    const mt = private.get_mt_to(this, from)
    const pos = table.find(mt, f)
    if (pos) then
        table.remove(mt, pos)
    end
end

function class:immutable ()
    const this = self :: class
    const my_meta : any = getmetatable(this)
    my_meta.__metatable = class.type
    this.__metatable = class.type

    table.freeze(my_meta)
    table.freeze(this)
end

do --private_region
    type metatable_pr = typeof(private.metatable)
    type meta<T> = setmetatable<T, metatable_pr>
    private.metatable = {__metatable = class.type, __mode = "ks"}
    private.method_connected = setmetatable({} :: {[string]: meta<{[class]: {methode<table>}}>}, private.metatable)

    function private.get_mt_to (this: class, that: metamethods) : {methode<table>}
        private.method_connected[that] = private.method_connected[that] or setmetatable({}, private.metatable)
        private.method_connected[that][this] = private.method_connected[that][this] or setmetatable({}, private.metatable)
        return private.method_connected[that][this]
    end

    function private.exe (this: any, name: string, ...)
        const connected_for = private.method_connected[name]
        if (connected_for) then
            const for_this_connected = connected_for[this]
            if (for_this_connected) then
                for _, v in for_this_connected do
                    const state, out = pcall(v, ...)
                    if not state then
                        project.console_output("from meta", out)
                    end
                end
            end
        end
    end

    function private.empty ()
        
    end
end

return table.freeze(class)