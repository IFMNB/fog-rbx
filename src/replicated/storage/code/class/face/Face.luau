const Disposable = require("../../Disposable")
const object = require("../../object")
const namefield = require("../../static/namefield")
const project = require("../../static/project")
const Connection = require("../connection/Connection")

const class = {__index = Disposable}
setmetatable(class, class)
export type class <T... = ...any> = object.generic<{
    once: (self: unknown, f: (T...) -> (), expected: number?) -> Connection.class,
    connect: (self: unknown, f: (T...) -> (), expected: number?) -> Connection.class,
    wait: (self: unknown, expected: number?) -> T...
}, typeof(class)>

--[=[
    `Face` - интерфейс для работы с событиями
]=]
class.type = namefield.face
class.owner_identity = nil :: typeof(class.identity)?

--[=[
    Возвращает неподготовленный `Face.class` объект, которому требуется
    заменить его методы вручную
]=]
function class.new () : class
    return Disposable.new(class, project.face_releaseable)
end

function class:once (f: () -> (), expected: number?) : Connection.class
    return project.console_output "attempt to use default Face.class:once()"
end
function class:connect (f: () -> (), expected: number?) : Connection.class
    return project.console_output "attempt to use default Face.class:connect()"
end
function class:wait (expected: number?) : ...unknown
    return project.console_output "attempt to use default Face.class:wait()"
end

return table.freeze(class)