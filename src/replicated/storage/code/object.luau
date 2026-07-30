--!strict

const namefield = require("@game/ReplicatedStorage/code/static/namefield")
const empty = require("./static/empty")
const project = require("./static/project")
const declare = require("./static/declare")

const private = {}
const class: declare.object = {
	identity = "never",
	type = namefield.object,

	new = function(self, that, ...)
		const T = (
			project.prototype_oop
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

	is = function(this, that)
		local base = private.ever[this]

		while base do
			const state, cached = private.get_cached_direct(base)
			if state then
				return cached.__type == that
			end

			base = private.ever[base]
		end

		return false
	end,

	equals = function(this, that)
		const state, cached = private.get_cached(this)
		return state and cached.__type == that or false
	end,

	get_base = function(self)
		return private.ever[self] :: any
	end,

	toggle_host = function <T> (self: T, f: (T) -> ())
		const state, cached = private.get_cached<<T,unknown>>(self)

		if state then
			const pos = table.find(cached.hosts, f)
			if pos then
				table.remove(cached.hosts, pos)
				if project.debug_object_hosts then project.console_out_error "host deleted" end
				return
			else
				table.insert(cached.hosts, f)
			end
		else
			project.console_out_error "cached isn't exists" 
			return
		end
	end,
}

do --private_region
	type cached <T = declare.object, U = unknown> = {
		__index: U,
		__metatable: empty.instance,
		__type: string,

		self: unknown,
		hosts: { (new: T) -> () },
	}
	
	private.cached = setmetatable({} :: { [unknown]: cached }, table.freeze({ __mode = "ks" }))
	private.ever = setmetatable({} :: { [declare.object | unknown]: unknown }, table.freeze({ __mode = "ks" }))

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
				__metatable = empty,
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
				project.mcall(v, to)
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

		for i = count, count, -1 do
			const cached = hierarchy[i]
			private.wake_hosts(cached, new)
		end
	end

	function private.bootload_new(new: declare.object, parent: unknown)
		(new :: any).identity = tostring(new)
	
		private.ever[new] = parent
		private.lazyget_cached(new, parent)
	end

	private.bootload_new(class)
end

if project.debug then
	class:toggle_host(function(new: declare.object)
		project.console_out("created a new ", new.type," object", new, "hosts:", private.get_hierarchy(new))
	end)
end

return class
