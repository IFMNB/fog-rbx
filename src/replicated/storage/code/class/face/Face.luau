const Disposable = require("../../Disposable")
const object = require("../../object")
const namefield = require("../../static/namefield")
const project = require("../../static/project")
const Connection = require("../connection/Connection")

const class = {__index = Disposable}
setmetatable(class, class)
export type class <T... = ...any> = object.generic<{
    once: (self: unknown, f: (T...) -> ()) -> Connection.class,
    connect: (self: unknown, f: (T...) -> ()) -> Connection.class,
    wait: (self: unknown) -> T...
}, typeof(class)>

--[=[
    `Face` - интерфейс для работы с событиями
]=]
class.type = namefield.face

--[=[
    Возвращает неподготовленный `Face.class` объект, которому требуется
    заменить его методы вручную
]=]
function class.new () : class
    return Disposable.new(class, project.face_releaseable)
end

function class:once (f: () -> ()) : Connection.class
    return project.console_output "attempt to use default Face.class:once()"
end
function class:connect (f: () -> ()) : Connection.class
    return project.console_output "attempt to use default Face.class:connect()"
end
function class:wait () : ...unknown
    return project.console_output "attempt to use default Face.class:wait()"
end

return table.freeze(class)