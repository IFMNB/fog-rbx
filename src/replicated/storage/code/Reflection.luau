--!strict

const Node = require("./class/node/Node")
const object = require("./object")
const nameconvention = require("./static/nameconvention")
const namefield = require("./static/namefield")

const class = {}
setmetatable(class, {__index = object})

export type class = object.class<{}, typeof(class)>

--[=[
    Автоматически получаемое свойство, обозначающее наименования поля, по которому
    изначально присваивается данное значение
]=]
class.name = ""

class.type = namefield.reflection

--[=[
    Возвращаемые результаты этого поля
]=]
class.result = {} :: {string}

--[=[
    Рефлексированное значение, то есть данные которые хранятся тут
]=]
class.reflected = nil :: unknown

--[=[

]=]
function class:enter ()
    const this = self :: class

end

return table.freeze(class)