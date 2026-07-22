const object = require("./object")
const namefield = require("./static/namefield")
const project = require("./static/project")
const Liberator = require("./struct/Liberator")

const private = {}
const class = { __index = object }

setmetatable(class, class)

export type base = object.class<typeof(class)>
type class_sample = { [any]: any } | base | ({ [any]: any } & base)
type sample_object = { [any]: any }

export type class = object.class<typeof(class)>


function class.new(class, allow_free: boolean?)
	const new_object = object.new(class)
	const typed_new_object = new_object :: class

	private.id_counted += 1
	private.allowed_clean[typed_new_object] = allow_free
	if not project.disposable_gc_collectable and allow_free then
		table.insert(private.every, typed_new_object)

		-- При (not allow_free) избавиться от объектов без возможности очистки невозможно
		-- Большинство таких объектов это синглтоны или они кому-то принадлежат,
		-- а значит их освобождение контроллируется на другой стороне
	end

	return new_object
end

class.type = namefield.disposable
class.arch_new = class.new

function class.get_classes_ever_created()
	return private.id_counted
end

do --free_cycle_region
	function class:can_free(): boolean
		const this = self :: class
		return private.allowed_clean[this] or false
	end

	function class:queue_free()
		const this = self :: class
		if not class.is_valid(this) then
			return
		end

		private.is_allowed_clean(this)
		if not project.disposable_watchers_call_after_destroying then
			private.do_watchers_list_for(this)
		end
		table.insert(private.to_free_queue, this)
	end

	function class:is_released()
		const this = self :: class
		return getmetatable(this) == nil
	end

	function class:is_queued_for_release()
		const this = self :: class
		return table.find(private.to_free_queue, this) ~= nil
	end

	@native
	function class:free()
		const this = self :: class
		if not private.is_allowed_clean(this) then
			return
		end

		if not class.is_valid(this) then
			return
		end

		if not project.disposable_free_behavior_is_deferred then
			if not project.disposable_watchers_call_after_destroying then
				private.do_watchers_list_for(this)
			end

			if not table.isfrozen(this) then
				table.clear(this)
				setmetatable(this, nil)
				table.freeze(this)
			end

			const cleanup = private.on_clean_event[this]
			if cleanup then
				table.clear(cleanup)
			end

			if project.disposable_watchers_call_after_destroying then
				private.do_watchers_list_for(this)
			end
		end

		if project.disposable_free_behavior_is_deferred then
			if not project.disposable_watchers_call_after_destroying then
				private.do_watchers_list_for(this)
			end

			this:queue_free()
		end

		if not project.disposable_gc_collectable then
			const pos = table.find(private.every, this)
			if pos then
				table.remove(private.every, pos)
			end
		end
	end

	function class:watch_free_event(what: Liberator.free_supported)
		const this = self :: class
		local this_list = private.on_clean_event[this] :: { Liberator.free_supported | unknown }
		if not this_list then
			private.on_clean_event[this] = {}
			this_list = {}
		end

		table.insert(this_list, what)
	end

	function class:unwatch_free_event(what: Liberator.free_supported)
		const this = self :: class
		const this_list = private.on_clean_event[this]
		if not this_list then
			return
		end

		const pos = table.find(this_list, what)
		if pos then
			table.remove(this_list, pos)
		end
	end

	-- Применяется на this.class
	function class:is_valid(): boolean
		const this = self :: class
		const is_object = class.is(this, class.type)
		return is_object and not class.is_released(this)
	end
end

do --collect_region
	function private.is_allowed_clean(this: class)
		if private.allowed_clean[this] then
			return true
		else
			project.console_output("cleaning is not allowed for this object, skipped")
			return false
		end
	end

	function private.do_watchers_list_for(this: class)
		const this_list = private.on_clean_event[this]

		if this_list then
			for i, v in this_list do
				private.watchers_parser(v)
			end

			table.clear(this_list)
		end
	end

	do --parsing_region
		function private.watchers_parser(v: Liberator.free_supported | unknown, liberator: Liberator.struct?): string?
			const T_luau = type(v)
			const parser_luau = private.parsers[T_luau]

			if liberator then
				if not project.object_allow_liberator_call_functions then
					if T_luau == "function" then
						return "function"
					end
				end
			end

			if parser_luau then
				parser_luau(v :: any)
				return T_luau
			end

			const T_roblox = typeof(v)
			const parser_roblox = private.parsers[T_roblox]
			if parser_roblox then
				parser_roblox(v :: any)
				return T_roblox
			end

			project.console_output("unknown unsupported @luau_data, i don't know how to work with him, skipped")
			return nil
		end

		private.parsers = {}
		private.parsers["function"] = function(func: () -> ())
			project.try(func, project.console_output)

			return "function"
		end
		private.parsers["thread"] = function(thread: thread)
			if coroutine.status(thread) ~= "dead" then
				coroutine.close(thread)
			end
			return "thread"
		end
		private.parsers["RBXScriptConnection"] = function(connection: RBXScriptConnection)
			if connection.Connected then
				connection:Disconnect()
			end
			return "RBXScriptConnection"
		end
		private.parsers["table"] = function(unknown_table: { [unknown]: unknown })
			if class.is(unknown_table, class.type) then
				return private.parsers["object"](unknown_table :: class | { [unknown]: unknown })
			end
			if unknown_table.for_index ~= nil and unknown_table.in_table ~= nil then
				return private.parsers["liberator"](unknown_table :: Liberator.struct)
			end

			const liberator = class.create_liberator(unknown_table, nil, true)
			return private.watchers_parser(liberator) :: string
		end

		@native
		function private.parsers.descriptors(liberator: Liberator.struct)
			if (liberator :: any).in_table == Liberator.in_table then
				return "liberator"
			else
				if type((liberator :: any).in_table) ~= "table" then
					project.console_output("unexpected liberator.in_table type")
					return "liberator"
				end
			end

			if liberator.parse_every_in_table and not liberator.for_index then
				const identity = liberator.identity :: string
				if not private.descriptor_recursive[identity] then
					private.descriptor_recursive[identity] = {}
				end

				const recursive = private.descriptor_recursive[identity]

				for i, v in table.clone(liberator.in_table) do
					const T = type(v)
					const childs_count = private.descriptor_childs[identity] or 0
					local parsing_value: Liberator.free_supported | unknown

					if T == "table" then
						if recursive[tostring(v)] then
							continue
						else
							recursive[tostring(v)] = i
						end

						private.descriptor_childs[identity] = childs_count + 1
						const new_descriptor: Liberator.struct = Liberator.new(
							liberator.in_table,
							v,
							liberator.parse_every_in_table :: boolean,
							liberator.identity
						)
						parsing_value = new_descriptor
						new_descriptor:queue_free()
					else
						parsing_value = v
					end

					const T_of_parsed_value = private.watchers_parser(parsing_value, liberator)
					if T_of_parsed_value and T_of_parsed_value ~= "object" then
						if project.liberator_can_delete_fields_in_table then
							if not table.isfrozen(liberator.in_table) then
								liberator.in_table[i] = v
							end
						end

						-- Удалять данные объектов небезопасно, поскольку эти данные могут быть ими использованы
						-- Вместо этого liberator позволяет объектам самостоятельно определиться что им нужно и когда
					end

					private.descriptor_childs[identity] = childs_count - 1
				end

				const childs_count = private.descriptor_childs[identity] or 0
				if childs_count == 0 then
					private.descriptor_recursive[identity] = nil
					liberator:queue_free()
				end

				return "liberator"
			elseif liberator.parse_every_in_table and liberator.for_index then
				const what_need_to_clear = liberator.in_table[liberator.for_index]
				if type(what_need_to_clear) == "table" then
					private.watchers_parser(
						class.create_liberator(
							what_need_to_clear :: { [unknown]: unknown },
							nil,
							liberator.parse_every_in_table :: boolean,
							liberator.identity
						),
						liberator
					)
				else
					private.watchers_parser(what_need_to_clear, liberator)
				end

				liberator.in_table[liberator.for_index] = nil
				return "liberator"
			else
				if liberator.for_index then
					const who_is_that: unknown = liberator.in_table[liberator.for_index]
					if who_is_that then
						private.watchers_parser(who_is_that)
						return "liberator"
					end
				end
			end

			project.console_output("desriptor didn't tell me my own way, skipped")
			return "liberator"
		end
		private.parsers["object"] = function(object: class | { [unknown]: unknown })
			if type(object.free) == "function" then
				const definitely_object = object :: class
				if class.can_free(definitely_object) then
					definitely_object:free()
				end
			end

			return "object"
		end
		private.parsers["userdata"] = function(userdata: any)
			if userdata:IsA "Instance" then
				return private.parsers["instance"](userdata :: Instance)
			end

			project.console_output("cannot parse userdata, because i don't know what i should do for him")
			return "userdata"
		end
		private.parsers["instance"] = function(instance: Instance)
			instance:Destroy()
			return "Instance"
		end

		table.freeze(private.parsers)
		private.descriptor_recursive = {} :: { [string]: { [string]: unknown } }
		private.descriptor_childs = {} :: { [string]: number? }
	end

	private.id_counted = 0 :: number
	private.every = {} :: { class }
	private.to_free_queue = setmetatable({} :: { class }, { __mode = "vs" })
	private.on_clean_event = setmetatable({} :: { [class]: { Liberator.free_supported }? }, { __mode = "ks" })
	private.allowed_clean = setmetatable({} :: { [class]: boolean }, { __mode = "vs" })

	@native
	function private.heartbeat_free()
		for i, v in table.clone(private.to_free_queue) :: { class } do
			if not project.disposable_gc_collectable then
				const pos_every = table.find(private.every, v)

				if pos_every then
					private.every[pos_every] = nil
				end
			end

			private.on_clean_event[v] = nil

			if not table.isfrozen(v) then
				table.clear(v)
				setmetatable(v, nil)
				table.freeze(v)
			end

			if not project.disposable_watchers_call_after_destroying then
				private.do_watchers_list_for(v :: never)
			end
		end

		table.clear(private.to_free_queue)
		const every_clone = table.clone(private.every)
		table.clear(private.every)

		for i, v in every_clone do
			if v == nil then
				continue
			else
				table.insert(private.every, v)
			end
		end
	end

	game:GetService("RunService").PreSimulation:Connect(private.heartbeat_free)
end

return table.freeze(class)
