const class_names = require('@game/ReplicatedStorage/code/static/class_names')

const private = {};
const class = {};

export type class = setmetatable<{}, {__index: typeof(class)}>

class.__index = class -- fast-link
class.type = class_names.object;

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
		task.defer(v)
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

function class:do_for_base (func: (class) -> (), recursive: boolean?, invert: boolean?)
	const this = self :: class
	local index = private.get__index_class(this)
	local next_index

	while (index) do
		if (index.type and class_names[index.type] ~= nil) then
			if (not invert) then
				func(index)
			end

			if (recursive) then
				next_index = private.get__index_class(index)
			end

			if (invert) then
				if (next_index) then
					func(next_index)
				end
			end
		end
		
		index = next_index
	end
end

function private.get__index_class (this: class)
	const metatable = getmetatable(this) :: {[unknown]: unknown}
	if (type(metatable) == "table") then
		const index = metatable.__index
		
		if (type(index) == "table") then
			return index
		end
	end

	return nil
end


table.freeze(class :: any)
return class