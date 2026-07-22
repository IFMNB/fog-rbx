const namefield = require('@game/ReplicatedStorage/code/static/namefield')
const project = require("@game/ReplicatedStorage/code/static/project")

const private = {}
const class = {}

export type base = typeof(class)
type class_sample = {[any]: any} | base | ({[any]: any} & base)
type sample_object = {[any]: any}

export type class <parent = base, that = {}> = that & parent

--[=[
	Стандартный базовый конструктор для всех объектов в данном проекте
]=]
function class.new <T> (class: T, reflection)
	const new_object = setmetatable({}, {
		__index = class,
		class = class,
		reflection = reflection
	})

	private.id_counted += 1
	return new_object :: class<base, T>
end

class.__index = class

--[=[
	Базовый тип для всех объектов в данном проекте, дающий разницу между
	обычной таблицей с метатаблицей и объектом в проекте

	`Просто классы еще не завезли в язык`
]=]
class.type = namefield.object

--[=[
	`object.identity` является уникальным идентификатором объекта в рамках
	этой Luau Virtual Machine
]=]
class.identity = "" :: unknown
class.arch_new = class.new

-- Экземпляр конкретного типа вводит конкретное поведение
-- Однако экземпляр архетипа вводит глобальное поведение
-- для всех объектов которые создаются через него, и это
-- поведение работает независимо от конкретного типа

--[=[
	Выдает количество всех когда-либо созданных объектов
]=]
function class.get_objects_ever_created ()
	return private.id_counted
end

--[=[
	Сравнивает этот объект с любым переданным значением на соответствие типов
	и настоящего `type()` значения
]=]
function class:equals (with: any)
    const this = self :: class
    return this.is(with, this.type)
end

--[=[
	Делает этот экземпляр неизменяемым

	`Если новые классы Luau нельзя будет замораживать, то этот api будет удален`
]=]
function class:immutable()
	return table.freeze(self :: typeof(self))
end

--[=[
	Проверяет, что этот экземпляр является изменяемым
]=]
function class:is_immutable ()
	return table.isfrozen(self)
end

--[[
	Не все объекты могут поддерживать полноценное клонирование.
	Объекты имеющие большую часть информации внутри метаданных ***не*** будут
	иметь одинаковое поведение со своим оригиналом, поскольку их
	метаданные не будут совпадать с клонированным объектом.
]]
function class:clone ()
	const this = self :: class
	const default = getmetatable(this)
	local result : {[unknown]: unknown}|any

	if (default) then
		result = setmetatable(table.clone(this), default)
	else
		project.console_output "clone failure (unknown reason)"
		result = this.new(this :: any)

		for i,v in this :: {[unknown]: unknown} do
			result[i] = v
		end
	end

	return result :: typeof(self)
end

--[=[
	Проверяет, что этот конкретный объект является объектом с указанным типом,
	а также проверяет, что этот объект вообще является объектом
]=]
function class:is(classname: keyof<typeof(namefield)>|string|nil) : boolean
	const this = self :: class
	const meta = getmetatable(this) :: any
	classname = classname or class.type
	
	if (type(meta) == "table") then
		const index = meta.__index :: unknown
		
		if (type(index) == "table") then
			const object = index :: {[unknown]: unknown}
			
			return object.type == classname
				and true
				or class.is(object, classname)
				or false
		end
	end
	
	return false
end



do --base_region

	--[=[
		Позволяет обойти все дерево наследования этого объекта начиная от
		его класса, заканчивая базовым `object` классом
	]=]
	@native
	function class:do_for_all_inheritance (func: (class) -> (), recursive: boolean?, invert: boolean?)
		const this = self :: class
		local index = this :: class
		const see = {} :: {any}

		while (index) do
			if (not invert) then
				func(index)
			end

			if (recursive) then
				table.insert(see, index)
				local found = private.get__index_class(index, true)
				
				if (not found) then
					return
				else
					index = found
				end

				if (table.find(see, index)) then
					if (index.type == "object") then
						return
					else
						project.console_output(string.format ("cycle oop dependency \n%s", index.type))
						return
					end
				end
			end

			if (invert) then
				func(index)
			end
		end
	end

	--[=[
		Возвращает класс этого объекта или `nil`, если этот класс - `object`
	]=]
	function class:get_base () : class?
		const this = self :: class
		const index = private.get__index_class(this)

		if (index and index.type and namefield[index.type] ~= nil) then
			return index :: class
		end

		return nil
	end

end

do --private_region
	function private.get__index_class (this: class, force_next_class_by_index: boolean?) : class?
		const metatable = getmetatable(this) :: {[unknown]: unknown}?
		if (type(metatable) == "table") then
			if (namefield[rawget(metatable, "type")] and not force_next_class_by_index) then
				return metatable :: class
			else
				const class = metatable.class
				if (type(class) == "table") then
					return class :: class
				else
					const index = metatable.__index
					if (type(index) == "table") then
						return index :: class
					end

					project.console_output("cannot iterate over __index function type (or type isn't a table)")
					return nil :: never
				end
			end
		end

		return nil
	end

	private.id_counted = 0 :: number
end

return table.freeze(class)