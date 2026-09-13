--!strict

const declare = require("./declare")
const project = require("./project")

type func = (...any) -> ...any

type argument = {
	read tval: { read string | argument },
	read opt: boolean,
	read var: boolean,
	read uor: boolean,
}

type out = {
	read result_type: argument,
	read arguments_types: { read argument },
	read guaranteed: boolean,
}

type tval = string | argument

type ftype = {
	read write: <T>(self: ftype, func: T, rtype: tval, ...tval) -> T,

	read read: (self: ftype, ...func) -> ...out,

	read is_opt: (self: ftype, argument: argument) -> boolean,
	read is_var: (self: ftype, argument: argument) -> boolean,
	read is_or: (self: ftype, argument: argument) -> boolean,

	read is_type: (self: ftype, argument: argument, ...string) -> boolean,

	read has_tval: (self: ftype, argument: argument, value: tval) -> boolean,

	read has_type: (self: ftype, argument: argument, ...string) -> boolean,

	read is_guaranteed: (self: ftype, out: out) -> boolean,
	read has_opt: (self: ftype, out: out) -> boolean,
	read has_var: (self: ftype, out: out) -> boolean,
	read has_or: (self: ftype, out: out) -> boolean,

	read result_is: (self: ftype, out: out, ...string) -> boolean,

	read get_result: (self: ftype, out: out) -> argument,

	read get_arguments: (self: ftype, out: out) -> { argument },

	read get_tval: (self: ftype, argument: argument) -> ...tval,

	read get_types: (self: ftype, argument: argument) -> ...string,

	read get_arguments_from_tval: (self: ftype, argument: argument) -> ...argument,

	read pack: setmetatable<{ [func]: out? }, { read __mode: "ks" }>,

	read opt: (self: ftype, ...tval) -> ...argument,

	read var: (self: ftype, ...tval) -> argument,

	read uor: (self: ftype, ...tval) -> argument,

	read var_or: (self: ftype, ...tval) -> argument,

	read var_or_opt: (self: ftype, ...tval) -> argument,

	read var_opt: (self: ftype, ...tval) -> argument,

	read or_opt: (self: ftype, ...tval) -> argument,
}

local function pack_argument(value: tval, opt: boolean?, var: boolean?, uor: boolean?): argument
	if type(value) == declare.string then
		return table.freeze({
			tval = table.freeze({
				value :: string,
			}),

			opt = opt == true,
			var = var == true,
			uor = uor == true,
		})
	end

	return value :: argument
end

local function get_tval(argument: argument): { tval }
	return argument.tval :: any
end

local function has_tval(argument: argument, value: tval): boolean
	for _, current in argument.tval do
		if current == value then
			return true
		end
	end

	return false
end

const ftype: ftype = table.freeze({
	write = function<T>(self: ftype, func: T, rtype: tval, ...: tval): T
		const args: { argument } = {}

		local has_var = false

		for _, value in { ... } do
			const argument = pack_argument(value)

			if argument.var then
				if has_var then
					project.console_out_error("ftype arg with .var already exists, skip")

					continue
				end

				has_var = true
			elseif has_var then
				project.console_out_error("ftype arg after .var is not allowed, skip")

				continue
			end

			table.insert(args, argument)
		end

		local result_type = pack_argument(rtype)

		self.pack[func] = table.freeze({
			result_type = result_type,
			arguments_types = table.freeze(args),
			guaranteed = true,
		})

		return func
	end,

	read = function(self: ftype, ...: func): ...out
		const result: { out } = {}

		for _, func in { ... } do
			table.insert(result, self.pack[func] or table.freeze({
				result_type = table.freeze({
					tval = table.freeze({
						declare["nil"],
					}),

					opt = false,
					var = false,
					uor = false,
				}),

				arguments_types = table.freeze({}),
				guaranteed = false,
			}) :: out)
		end

		return unpack(result)
	end,

	is_opt = function(_self: ftype, argument: argument): boolean
		return argument.opt
	end,

	is_var = function(_self: ftype, argument: argument): boolean
		return argument.var
	end,

	is_or = function(_self: ftype, argument: argument): boolean
		return argument.uor
	end,

	is_type = function(_self: ftype, argument: argument, ...: string): boolean
		for _, expected in { ... } do
			for _, actual in argument.tval do
				if type(actual) == declare.string and actual == expected then
					return true
				end
			end
		end

		return false
	end,

	has_tval = function(_self: ftype, argument: argument, value: tval): boolean
		return has_tval(argument, value)
	end,

	has_type = function(self: ftype, argument: argument, ...: string): boolean
		return self:is_type(argument, ...)
	end,

	is_guaranteed = function(_self: ftype, out: out): boolean
		return out.guaranteed
	end,

	has_opt = function(_self: ftype, out: out): boolean
		for _, argument in out.arguments_types do
			if argument.opt then
				return true
			end
		end

		return false
	end,

	has_var = function(_self: ftype, out: out): boolean
		for _, argument in out.arguments_types do
			if argument.var then
				return true
			end
		end

		return false
	end,

	has_or = function(_self: ftype, out: out): boolean
		for _, argument in out.arguments_types do
			if argument.uor then
				return true
			end
		end

		return false
	end,

	result_is = function(self: ftype, out: out, ...: string): boolean
		return self:is_type(out.result_type, ...)
	end,

	get_result = function(_self: ftype, out: out): argument
		return out.result_type
	end,

	get_arguments = function(_self: ftype, out: out): { argument }
		return out.arguments_types :: any
	end,

	get_tval = function(_self: ftype, argument: argument): ...tval
		const values = get_tval(argument)

		return unpack(values)
	end,

	get_types = function(_self: ftype, argument: argument): ...string
		const result: { string } = {}

		for _, value in argument.tval do
			if type(value) == declare.string then
				table.insert(result, value :: string)
			end
		end

		return unpack(result)
	end,

	get_arguments_from_tval = function(_self: ftype, argument: argument): ...argument
		const result: { argument } = {}

		for _, value in argument.tval do
			if type(value) == declare.table then
				table.insert(result, value :: argument)
			end
		end

		return unpack(result)
	end,

	opt = function(_self: ftype, ...: tval): ...argument
		const result: { argument } = {}

		for _, value in { ... } do
			local argument = pack_argument(value, true, false, false)

			table.insert(result, argument)
		end

		return unpack(result)
	end,

	var = function(_self: ftype, ...: tval): argument
		return table.freeze({
			tval = table.freeze({
				...,
			}),

			opt = false,
			var = true,
			uor = false,
		})
	end,

	uor = function(_self: ftype, ...: tval): argument
		return table.freeze({
			tval = table.freeze({
				...,
			}),

			opt = false,
			var = false,
			uor = true,
		})
	end,

	var_or = function(_self: ftype, ...: tval): argument
		return table.freeze({
			tval = table.freeze({
				...,
			}),

			opt = false,
			var = true,
			uor = true,
		})
	end,

	var_or_opt = function(_self: ftype, ...: tval): argument
		return table.freeze({
			tval = table.freeze({
				...,
			}),

			opt = true,
			var = true,
			uor = true,
		})
	end,

	var_opt = function(_self: ftype, ...: tval): argument
		return table.freeze({
			tval = table.freeze({
				...,
			}),

			opt = true,
			var = true,
			uor = false,
		})
	end,

	or_opt = function(_self: ftype, ...: tval): argument
		return table.freeze({
			tval = table.freeze({
				...,
			}),

			opt = true,
			var = false,
			uor = true,
		})
	end,

	pack = setmetatable(
		{} :: { [func]: out? },
		table.freeze({
			__mode = "ks" :: "ks",
		})
	),
})

return ftype
