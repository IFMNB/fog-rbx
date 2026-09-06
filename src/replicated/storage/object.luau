--!strict


const project = require("./static/project")
const declare = require("./static/declare")

const private = {}
const class: declare.object = {
	identity = "never",
	type = "object",

	new = function <T,U> (self: T, that: U?)
		const T = (
			project.proto
				and setmetatable(table.clone(self), {
					__index = function(t, i)
						const var = rawget(t, i)
						return var
					end,
				})
			or table.clone(self)
		) :: declare.object

		private.load_to_new(T, that)
		private.bootload_new(T, self) 
		private.wake(T)

		return T :: any
	end, 

	renew = function <T> (self: T, that: { [unknown]: unknown }?)
		const compared: {[unknown]: unknown} = {}
		const self_T: declare.object = self :: any

		--[=[ Не позволяем из данной функции билдить новые объекты с новой семантикой ]=]

		if that then
			for i,v in self :: {[unknown]: unknown} do
				compared[i] = that[i]
			end
		end

		return assert(self_T:base<<declare.object>>(), "base corruption"):new(compared) :: any
	end,

	is = function(this, that)
		if that == "anyt" then
			return true
		end

		local base = private.ever[this]

		while base do
			const state, cached = private.get_cached_direct(base)
			if state then
				if cached.__type == that then
					return true
				end
			end

			base = private.ever[base]
		end

		return false
	end,

	equals = function(this, that)
		const state, cached = private.get_cached(this)
		return state and cached.__type == that or false
	end,

	base = function <T> (self: T & declare.object, expected: string|nil) : any
		const base = private.ever[self]
		if expected then 
			if self.is(base, expected) then
				return base
			else
				project.console_out_error "base has unexpected type, return nil"
			end
		else
			return base
		end

		return nil
	end,

	host = function <T> (self: T & declare.object, f: (any) -> (), last: boolean?)
		const state, cached = private.get_cached<<T,unknown>>(self)

		if state then
			const pos = table.find(cached.hosts, f)
			if pos then
				table.remove(cached.hosts, pos)
				return
			else
				table.insert(cached.hosts, f)
			end
		else
			project.console_out_error "cached isn't exists" 
			return
		end
	end,

	require = function (identity: unknown, assertion) : any
		const required = private.identity[identity]
		
		if assertion then
			const state, cached = private.get_cached(required)
			
			assert(state, "cannot get necessary object, cache empty")
			assert(cached.__type == assertion, "retrieved object isn't an assertion")
		end
		
		assert(required ~= nil, "necessary object is never exists")

		return required
	end,

	rebuild = function <T> (self: T, that: {[unknown]: unknown}) : T
		assert(type(that) == declare.table, "cannot rebuild that object, his type isn't a table type")

		return (self :: declare.object):renew(that)
	end,

	as = function <T> (self: unknown, as: string) : T
		assert((self :: declare.object):is(as), "cannot convert this object to required type")
		return self :: any
	end
}

do --private_region
	type cached <T = declare.object, U = unknown> = {
		__index: U,
		__metatable: nil|string,
		__type: string,

		self: unknown,
		hosts: { (new: T) -> () },
	}
	
	private.frozen = table.freeze {__mode = "ks"}
	private.cached = setmetatable({} :: { [unknown]: cached }, private.frozen)
	private.ever = setmetatable({} :: { [declare.object | unknown]: unknown }, private.frozen)
	private.identity = setmetatable({} :: {[unknown]: declare.object|unknown}, private.frozen)
	private.type_build_location = {} :: {[string]: ModuleScript?}
	private.counter = 0

	function private.get_cached_by_instance<T,U>(this: unknown): (boolean, cached<T,U>)
		const ever = private.ever[this]
		if ever then
			const cached = private.cached[ever]
			if cached then
				return true, cached
			end
		end

		return false, nil :: never
	end

	function private.get_cached_direct <T,U> (this: unknown) : (boolean, cached<T,U>)
		const cached = private.cached[this]
		const state = cached ~= nil
		return state, cached
	end

	function private.get_cached<T,U> (this: unknown) : (boolean, cached<T,U>)
		local state, cached = private.get_cached_direct <<T,unknown>>(this)
		if not state then state, cached = private.get_cached_by_instance <<T, unknown>>(this) end
		return state, cached
	end

	function private.lazyget_cached(this: unknown | { [unknown]: unknown }, parent): cached
		const Ttype = typeof(this)
		const meta: cached = private.cached[this]
			or {
				__index = parent,
				__metatable = if not project.proto then nil else if project.debug then "<metatable>" else nil,
				__type = Ttype == "table" and tostring((this :: any).type) or Ttype,

				self = this,
				hosts = {},
			}

		private.cached[this] = meta
		return meta
	end

	function private.wake_hosts(inside: cached, to: declare.object)
		for _, v in inside.hosts do
			if not project.debug then
				pcall(v, to)
			else
				v(to)
			end
		end
	end

	function private.load_to_new (new: declare.object, load: {[unknown]: unknown}|unknown|nil)
		const T = type(load)

		if T == "table" then
			for i, v in load :: {[unknown]: unknown} do
				(new :: {[unknown]: unknown})[i] = v
			end
		end
	end

	function private.get_hierarchy<T,U>(from: declare.object): {cached<T,U>}
		const result = {}
		local state, cached = private.get_cached(from)

		while state do
			table.insert(result, cached)

			if cached.__index ~= nil then
				state, cached = private.get_cached(cached.__index)

				if table.find(result, cached) then
					project.console_out("recursive hierarchy")
					break
				end
			else
				break
			end
		end

		return result
	end
 
	function private.wake (new: declare.object)
		const hierarchy =  private.get_hierarchy <<declare.object, unknown>> (new)
		const count = #hierarchy

		for i = count, 1, -1 do
			const cached = hierarchy[i]
			private.wake_hosts(cached, new)
		end
	end

	function private.generator (new: declare.object)
		private.counter += 1

		const __new = new :: {[string]: any}
		__new.identity = tostring(private.counter)
	end

	function private.bootload_new(new: declare.object, parent: unknown)
		private.generator(new)	
		private.identity[new.identity] = new
		private.ever[new] = parent
		private.lazyget_cached(new, parent)
	end

	private.bootload_new(class)

	if project.debug and project.debug_show_created_objects then
		class:host(function(new: declare.object)
			project.console_out(string.format("new %s", new.type))
		end)
	end
end



return class