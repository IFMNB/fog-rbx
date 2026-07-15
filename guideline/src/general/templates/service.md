Большая часть инструкций аналогична классу

```luau

const Service = require("@game/ReplicatedStorage/code/Service")
const Event = require("@game/ReplicatedStorage/code/class/event/Event")
const Face = require("@game/ReplicatedStorage/code/class/face/Face")
const Storage = require("@game/ReplicatedStorage/code/class/storage/Storage")
const Upload = require("@game/ReplicatedStorage/code/class/upload/Upload")
const object = require("@game/ReplicatedStorage/code/object")
const namefield = require("@game/ReplicatedStorage/code/static/namefield")

const private = {}
const class = {}
setmetatable(class, {__index = Service})

--[==[

    Если класс не подразумевает кастом значения, используй такую семантику:

    ```luau
        export type class = object.class<typeof(class)>
    ```

]==]
export type class<T = unknown> = object.generic<{
    --[=[
        Дженерик функционал и поля/свойства класса
    ]=]
    
    default: T?
}, typeof(class)>

class.type = namefield.имя_типа
class.поле = значение
class.свойство = булеан / енам  / иное

--[=[
    Если требуется свойство в виде класса объекта, то не создавай его как поле/свойство прямо в классе, это может привести к багам если кто-то удалит его. Используй Upload с его ленивым созданием и возвращай такие сущности из ленивых get
]=]

--[=[
    Событие обновления значения сервиса с названием `имя`. Это событие зависит от неавтоматического вызова `:set_имя()` и не может быть автоматизировано в силу того, что оно описывает. Поэтому сам метод сеттера вызывает `:emit()` у события.
]=]
function class:get_имя_event()
    const this = self :: class
    return Upload.fetch(private.metadata:fetch(this), "server_environment_update_event", Event.new):get_face()
end

--[=[
    Ленивый геттер для свойства. Поля обычно такими не должны обладать
]=]
function class:get_имя()
    const this = self :: class
    return Upload.fetch(private, имя_ключа, стандартное_значение)
end

--[=[
    Сеттер для свойства. Поля обычно таким не должны обладать
]=]
function class:set_имя (значение: ожидаемый строгий тип)
    const this = self :: class
    private.имя_ключа = значение

    Upload.ecall(private, "имя_ивента_по_ключу", private.имя_ивента_по_ключу, значение)
end

--[=[
    Любое действие связанное и работающее с сервисом является методом
]=]
function class:make_action(what: number?)
    const this = self :: class

    print (what or "nothing to do")
    private.do(what)
end

--[=[
    Любое действие которое может быть не связано с сервисом является функцией класса
]=]
function class.act()

end

do --private_region
    private.metadata = Storage.new()

    function private.do (...)

    end
end


do --initiate_region
    const browser = Upload.fetch(private, "singletone", object.new(class, false))

    --[=[
        В этом do end блоке происходит инициализация сервиса: подписки на соединения, включение jobs и тп
    ]=]

    table.freeze(class)
    -- table.freeze(private) -- если сам private не изменяется, но этим можно принебречь
end

return private.singletone
```