const object = require("./object")
const namefield = require("./static/namefield")

const private = {}
const class = {__index = object}
setmetatable(class, class)

export type class = object.class<typeof(class)>

--[=[
    Аналогичен обычному конструктору, однако ведет свой учет созданных `Record`
]=]
function class.new(class)
	const record = object.new(class)
    private.id_counted += 1
    return record
end

--[=[
    `Record` следует считать аналогом `struct`

    В аналогии с `Godot`, это скорее `RefCounted` объект,
    суть которого быть неизменяемым и постоянно пересоздаваться
    как обычная структура Roblox
]=]
class.type = namefield.record
class.arch_new = class.new

--[=[
    Возвращает количество всех когда-либо созданных `Record`
]=]
function class.get_records_ever_created ()
    return private.id_counted
end

private.id_counted = 0

return table.freeze(class)