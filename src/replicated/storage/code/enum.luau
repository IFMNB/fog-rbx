const object = require("./object")
const namefield = require("./static/namefield")

const private = {}
const class = { __index = object }
setmetatable(class, class)

export type class = object.class<typeof(class), {[string]: number?}>

class.type = namefield.enum
class.arch_new = error

--[=[
	Стандартное значение для всех неизвестных вариантов енумераторов
]=]
class.Unknown = 0

--[=[
	Генерирует hashcode для конкретной строки на основе hashlink.
	Могут быть коллизии, не гарантирует их отсутствия

	Поскольку енумераторы не являются объектами в привычном смысле,
	они представляют из себя immutable объекты с константами внутри
]=]
function class.new(hashlink: string?)
	private.id_counter += 1
	hashlink = tostring(hashlink) or class.type

	local hval = 0x811c9dc5
	for i = 1, #hashlink do
		hval = bit32.bxor(hval, string.byte(hashlink, i))
		hval *= 0x01000193
		hval = bit32.band(hval, 0xFFFFFFFF)
	end

	return hval
end

--[=[
	Проверяет, является ли переданное число енамом из этой группы
]=]
function class:is_my_enumitem(that: number)
	const this = self :: class
	const list = this:get_enums_list()

	for _,v in list do
		if (that == v) then
			return true
		end
	end

	if (that == self.Unknown) then
		return true
	end
	
	return false
end

--[=[
	Вернет количество всех когда-либо созданных `enum`
]=]
function class.get_enums_ever_created()
	return private.id_counter
end

--[=[
	Вернет количество енамов в группе
]=]
function class:get_count()
	local j = 0
	for i, v in self do
		if type(v) == "number" then
			j += 1
		end
	end

	return j
end

--[=[
	Вернет все енамы из группы в числовом виде
]=]
function class:get_enums_list()
	const result = {} :: { number }

	for i, v in self do
		if type(v) == "number" then
			table.insert(result, v)
		end
	end

	return result
end

--[=[
	Вернет имя енама если он принадлежит этой группе, иначе `Unknown`
]=]
function class:get_name(by: number): string | "Unknown"
	for i, v in self do
		if type(v) == "number" and v == by then
			return i
		end
	end

	return "Unknown"
end

private.id_counter = 1

return table.freeze(class)
