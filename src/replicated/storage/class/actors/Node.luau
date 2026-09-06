--!strict
const Attribute = require("@game/ReplicatedStorage/class/actors/Attribute")
const Disposable = require("@game/ReplicatedStorage/class/arch/Disposable")
const Maid = require("@game/ReplicatedStorage/class/common/Maid")
const Maybe = require("@game/ReplicatedStorage/class/common/Maybe")
const Reference = require("@game/ReplicatedStorage/class/common/Reference")
const ConnectionVariant = require("@game/ReplicatedStorage/enums/descriptor/ConnectionVariant")
const DisposableNotification = require("@game/ReplicatedStorage/enums/notification/DisposableNotification")
const declare = require("@game/ReplicatedStorage/static/declare")

const private = {}
const class: declare.node = Disposable:new({
	type = "node",
	rid = "",

	get_reference = function(self: declare.node): declare.reference<any>
		return private.maybe_ref:extract(self, function()
			return Reference:new()
		end)
	end,

	get_attribute_list = function(self: declare.node): { declare.value }
		const result = {}

		for _, v in private.get_attributes(self) do
			table.insert(result, v:get_params())
		end

		return result
	end,

	get_attribute = function(self: declare.node, name: string): declare.value?
		for _, v in private.get_attributes(self) do
			if v.name == name then
				return v:get_params()
			end
		end

		return nil
	end,

	add_attribute = function(self: declare.node, name: string): declare.value
		const stored = private.get_attributes(self)
		const maid = private.get_maid(self)

		for _, v in stored do
			if v.name == name then
				return v:get_params()
			end
		end

		const attribute_new = Attribute:new({ name = name })
		maid:add_object(attribute_new)
		table.insert(stored, attribute_new)

		return attribute_new:get_params()
	end,

	remove_attribute = function(self: declare.node, name: string): ()
		const stored = private.get_attributes(self)
		const maid = private.get_maid(self)

		for i, v in stored do
			if v.name == name then
				maid:remove_object(v)
				v:queue_free()

				table.remove(stored, i)
				return
			end
		end

		return
	end,

	add_dependent = function(self: declare.node, of: declare.object): ()
		const dependent_list = private.dependent[self][of.type] or {}
		table.insert(dependent_list, of)

		for i = #dependent_list, 1, -1 do
			const dependent = dependent_list[i]
			if not dependent then
				table.remove(dependent_list, i)
			end
		end

		const maid = private.get_maid(self)
		if maid:is_supported(of) then
			maid:add_object(of :: any)
		end

		private.dependent[self][of.type] = dependent_list
	end,

	remove_dependent = function(self: declare.node, of: declare.object): ()
		const dependent_list = private.dependent[self][of.type]
		if dependent_list then
			const pos = table.find(dependent_list, of)
			if pos then
				const maid = private.get_maid(self)
				if maid:is_supported(of) then
					maid:remove_object(of :: any)
				end

				table.remove(dependent_list, pos)
			end
		end
	end,

	get_dependent = function(self: declare.node, like: declare.object): { declare.object }
		return table.clone(private.dependent[self][like.type] or {})
	end,
})

class:host(function(new: declare.node)
	local maid_create: (...any) -> ()
	maid_create = function()
		const new_maid = Maid:new()
		private.maids[new] = new_maid
		new_maid:subscribe(DisposableNotification.OnRelease, ConnectionVariant.Once, maid_create)
	end

	maid_create()
	private.attributes[new] = {}
	private.dependent[new] = {}

	new:subscribe(DisposableNotification.Released, ConnectionVariant.Once, function()
		private.get_maid(new):free()
		private.maids[new] = nil
		table.clear(private.dependent[new])
		table.clear(private.attributes[new])
	end)
end)

do
	private.meta = table.freeze({ __mode = "ks" })
	private.maybe_ref = Maybe:new() -- declare.reference
	private.maids = setmetatable({} :: { [declare.node]: declare.maid }, private.meta)
	private.attributes = setmetatable({} :: { [declare.node]: { declare.attribute } }, private.meta)
	private.dependent =
		setmetatable({} :: { [declare.node]: { ["names" | string]: { declare.object }? } }, private.meta)

	function private.get_attributes(to: declare.node)
		return private.attributes[to]
	end

	function private.get_maid(of: declare.node)
		return private.maids[of]
	end
end

return class
