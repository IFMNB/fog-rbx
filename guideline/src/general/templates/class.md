```luau

const Storage = require("@game/ReplicatedStorage/code/class/storage/Storage")
const Upload = require("@game/ReplicatedStorage/code/class/upload/Upload")
const enum = require("../class/arch/enum")
const object = require("@game/ReplicatedStorage/code/object")
const namefield = require("@game/ReplicatedStorage/code/static/namefield")

const private = {}
const class = {__index = object}
setmetatable(class, class)

--[=[
    Не хочешь чтобы от класса можно было наследоваться с его функционалом?
    Пиши:

    ```luau
        const class = {}
        setmetatable(class, {__index = нужный_класс})
    ```
]=]

--[=[

    Если класс не подразумевает кастом значения, используй такую семантику:

    ```luau
        export type class = object.class<typeof(class)>
    ```
]=]
export type class<T = unknown> = object.class<setmetatable<{
    --[=[
        Дженерик функционал и поля/свойства класса
    ]=]
    
    default: T?
}, {__index: typeof(class)}>>

--[=[
    Почему требуется писать целую метатаблицу если нужны кастом-значения? Потому что иначе произойдет оверрайд
]=]

--[=[
    Пример базового объекта
]=]
class.type = namefield.object

--[=[
    Очень важное свойство.
]=]
class.property = true

--[=[
    В VSCode комментирование полей/свойств с примитивами и таблицами работает,
    в отличие от Roblox Studio
]=]
class.default = nil :: unknown

--[=[
    Возвращает текущее состояние
]=]
function class:get_state ()
    return Upload.fetch(private.states:get(self), "state", enum.Unknown)
end

--[=[
    Устанавливает текущее состояние
]=]
function class:set_state (new: number?)
    private.states:get(self)["state"] = new or enum.Unknown 
end

private.states = Storage.new()

return table.freeze(class)

```