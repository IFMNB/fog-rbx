const class_names = require('@game/ReplicatedStorage/code/static/class_names')
const project = require("./static/project")

const private = {};
const class = {};

type base = typeof(class)
type class_base = setmetatable<{}, {__index: base}>
export type class <T = any> = setmetatable<{}, {__index: base|T}>
-- TODO сигнатуры ожидающие object.class несовместимы с более специфичными типами (невозможен каст T.class в object.class)

class.__index = class -- fast-link
class.type = class_names.object;
class.is_free = false

private.on_clean_event = setmetatable({} :: {[class]: {()->()}}, {__mode='ks'}) 
private.allowed_clean = setmetatable({} :: {[class]: boolean}, {__mode='vs'})

function private.clear_clean_list(this: class)
	private.on_clean_event[this] = nil
end

function private.is_allowed_clean(this: class)
	assert(private.allowed_clean[this], "cleaning is not allowed for this object")
end

function private.get_clean_list(this: class)
	return private.on_clean_event[this]
end

-- Всегда наследуемые экземпляры формируйте только от этого конструктора во избежание инвариации и локдауна типов.
function class.new (class, allow_free: boolean?)
	const new_object = setmetatable({}, {__index = class})
	const untyped_new_object = (new_object::unknown) :: class
	
	private.allowed_clean[untyped_new_object] = allow_free
	private.on_clean_event[untyped_new_object] = {}

	return new_object
end

-- Очищает объект и выпускает сигнал о его удалении.
function class:free()
	const this = self :: class
	const this_list = assert(private.get_clean_list(this), "object already cleaned")
	private.is_allowed_clean(this)
	
	for i, v in this_list do
		const state, err = pcall(v)
		if (not state) then
			warn(err)
		end
	end
	
	
	setmetatable(this, nil)
	table.clear(this)
	table.freeze(this)
	private.clear_clean_list(this)
end

function class:watch_free_event(func: ()->())
	const this = self :: class
	const this_list = private.get_clean_list(this)
	table.insert(this_list,func)
end

function class:unwatch_free_event(func: () -> ())
	const this : class = self
	const this_list = private.get_clean_list(this)
	table.remove(this_list, table.find(this_list, func))
end

function class:is(classname: string|class_names.class_names)
	const this = self :: class
	const meta = getmetatable(this) :: any
	
	if (type(meta) == "table") then
		const index = meta.__index :: unknown
		
		if (type(index) == "table") then
			const class = index :: {[unknown]: unknown}
			
			return class.type == classname
				and true
				or type(class.is) == "function"
				and class:is(classname)
				or false
		end
	end
	
	return false
end

function class:do_for_all_inheritance (func: (class) -> (), recursive: boolean?, invert: boolean?)
	const this = self :: class
	local index = this
	const see = {} :: {any}

	while (index) do
		if (not invert) then
			func(index)
		end

		if (recursive) then
			table.insert(see, index)
			index = private.get__index_class(index, true)
			
			if (not index) then
				return
			end

			if (table.find(see, index)) then
				if (index.type == "object") then
					return
				else
					if (project.debug_mode) then
						error(string.format ("cycle oop dependency \n%s", index.type ))
					end
					return
				end
			end
		end

		if (invert) then
			func(index)
		end
	end
end

function class:get_base () : class_base?
	const this = self :: class_base
	const index = private.get__index_class(this)

	if (index.type and class_names[index.type] ~= nil) then
		return index
	end

	return nil
end

function private.get__index_class (this: class, force_next_class_by_index: boolean?)
	const metatable = getmetatable(this) :: {[unknown]: unknown}?
	if (type(metatable) == "table") then
		if (class_names[rawget(metatable, "type")] and not force_next_class_by_index) then
			return metatable
		else
			const index = metatable.__index
			if (type(index) == "table") then
				return index
			else
				if (project.debug_mode) then
					error("cannot iterate over __index function type (or type isn't a table)")
				end
				return nil :: never
			end
		end
	end

	return nil
end


table.freeze(class :: any)
return class