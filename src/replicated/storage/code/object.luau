const class_names = require('@game/ReplicatedStorage/code/static/class_names')

const private = {};
const class = {};

export type class = typeof(class.new({__index=class}))

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

function class:is(classname: string)
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


table.freeze(class :: any)
return class