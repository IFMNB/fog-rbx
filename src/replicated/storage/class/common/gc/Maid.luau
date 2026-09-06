--!strict
const Disposable = require("@game/ReplicatedStorage/class/arch/Disposable")
const ConnectionVariant = require("@game/ReplicatedStorage/enums/descriptor/ConnectionVariant")
const DisposableNotification = require("@game/ReplicatedStorage/enums/notification/DisposableNotification")
const declare = require("@game/ReplicatedStorage/static/declare")

const project = require("@game/ReplicatedStorage/static/project")

const private = {}
const class: declare.maid = Disposable:new({
	type = "maid",

	add_object = function(self: declare.maid, that: any, strong: boolean?): () -- #12
		if strong then
			table.insert(private.s_objects[self], that)
		else
			table.insert(private.objects[self], that)
		end
	end,

	add_key = function<T>(self: declare.maid, of: { [T]: unknown }, key: T): ()
		if not private.pairs[self][of] then
			private.pairs[self][of] = {}
		end

		table.insert(private.pairs[self][of], key)
	end,

	remove_object = function(self: declare.maid, that: any): () -- #12
		do
			const pos: number? = table.find(private.objects[self], that)

			if pos then
				table.remove(private.objects[self], pos)
			end
		end

		do
			const pos: number? = table.find(private.s_objects[self], that)

			if pos then
				table.remove(private.s_objects[self], pos)
			end
		end
	end,

	remove_key = function<T>(self: declare.maid, of: { [T]: unknown }, key: T): ()
		if not private.pairs[self][of] then
			return
		end

		const pos: number? = table.find(private.pairs[self][of], key)
		if pos then
			table.remove(private.pairs[self][of], pos)
		end
	end,

	is_supported = function(self: declare.maid, that: unknown): boolean
		for _, v in private.supported do
			if self.is(that, v) then
				return true
			else
				if typeof(that) == v then
					return true
				end
			end
		end

		return false
	end,
})

class:host(function(new: declare.maid)
	private.objects[new] = setmetatable({}, private.meta)
	private.s_objects[new] = {}
	private.pairs[new] = setmetatable({}, private.meta)

	new:subscribe(
		DisposableNotification.OnRelease,
		ConnectionVariant.Once,
		function()
			private.cycle(private.objects[new], private.s_objects[new])
		end,
		function()
			for k, v in private.pairs[new] do
				for _, j in v do
					k[j] = nil
				end
			end

			table.clear(private.pairs[new])
		end,
		if project.debug and project.debug_show_maids_releasing
			then function()
				project.console_out("maid ", new.identity, " is released")
			end
			else nil :: never
	)
end)

do
	private.meta = table.freeze({ __mode = "ks" })
	private.objects = setmetatable({} :: { [declare.maid]: { unknown } }, private.meta)
	private.s_objects = setmetatable({} :: { [declare.maid]: { unknown } }, private.meta)
	private.pairs = setmetatable({} :: { [declare.maid]: { [{ [unknown]: unknown }]: { unknown } } }, private.meta)

	private.supported = table.freeze({
		"connection",
		"disposable",
		declare.roblox.RBXScriptConnection,
		declare.roblox.Instance,
	})

	private.cycle = function(t: { unknown })
		for _, v in t do
			if class.is(v, "connection") then
				const connection = v :: declare.connection
				connection:disconnect()
			elseif class.is(v, "disposable") then
				const disposable = v :: declare.disposable
				disposable:free()
			elseif class.is(v, "reference") then
				const reference = v :: declare.reference
				reference:clear()
			elseif typeof(v) == declare.roblox.RBXScriptConnection then
				const connection = v :: RBXScriptConnection
				connection:Disconnect()
			elseif type(v) == declare["function"] then
				const func = v :: (...any) -> () | any
				if project.debug then
					func()
				else
					pcall(func)
				end
			elseif typeof(v) == declare.roblox.Instance then
				const instance = v :: Instance
				instance:Destroy()
			else
				project.console_out("unknown object, skip")
			end
		end
	end
end

return class
