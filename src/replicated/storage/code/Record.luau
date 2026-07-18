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

--[=[
    Вернет плоскую неизменяемую копию структуры
]=]
function class:get_dictionary ()
    const that = table.clone (self)
    for i, v in self do
        const T = type(v)
        if (T ~= "string" or T ~= "number" or T ~= "boolean") then
            if (T == "table") then
                that[i] = class.get_dictionary(v) :: any
            end

            continue
        end
    end

    return table.freeze (that) :: typeof(self)
end

private.id_counted = 0

return table.freeze(class)