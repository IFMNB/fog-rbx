--!strict

const Disposable = require("../../Disposable")
const StorageMode = require("../../enums/StorageMode")
const object = require("../../object")
const namefield = require("../../static/namefield")
const Storage = require("../storage/Storage")

const private = {}
const class = {}
setmetatable(class, {__index = Disposable})

export type class = object.class<typeof(class)>

--[=[
    `Upload` - Lazy-хранилище и ленивый загрузчик одновременно
]=]
class.type = namefield.upload

function class.new ()
    const this = Disposable.new(class, true)
    return this
end

--[=[
    Вернет требуемое значение если оно есть, а если его нет то создаст
    при помощи переданного значения и запишет его в таблицу

    Может быть также применен как `Upload.class :fetch()`, поскольку каждый
    `Upload.class` имеет собственный реестр данных и может внутри хранит 
    ключ-значение пары вида:

    `[object.class]: unknown`
]=]
function class.fetch <T,U> (from: {[unknown]: unknown?}|class, key: U, reserved: (...any) -> T|T) : T
    const value = from[key]
    if (value) then
        return value
    end

    if (object.is(from, class.type)) then
        return class.fetch(private.upvalues:fetch(from), key, reserved)
    end

    const T = type(reserved)
    const T_do = private.type_do[T] or private.type_do["any"]
    const result = T_do(from, key, reserved)

    return result :: T
end


--[=[
    Проверяет нахождение ключа в собственном реестре
]=]
function class:is_exists (key: unknown)
    const this = self :: class
    const upvalues = private.upvalues:fetch(this)
    return upvalues[key] ~= nil
end

--[=[
    Очищает ключ и его значение из собственного реестра данных
]=]
function class:clear (key: unknown?)
    const this = self :: class
    const upvalues = private.upvalues:fetch(this)
    
    if (key == nil) then
        table.clear(upvalues)
    else
        upvalues[key] = nil
    end
end

private.type_do = table.freeze {
    ["function"] = function (this, key, func)
        const new = func()
        this[key] = new
        return new
    end,
    ["any"] = function (this, key, reserved)
        this[key] = reserved
        return reserved
    end
} :: {[string]: (...any) -> unknown}

private.upvalues = Storage.new(StorageMode.LazyAll)

return table.freeze(class)