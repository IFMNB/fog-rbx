--!strict

const Cryptography = require("@game/ReplicatedStorage/dependency/Cryptography")
const object = require("@game/ReplicatedStorage/object")
const declare = require("@game/ReplicatedStorage/static/declare")
const project = require("@game/ReplicatedStorage/static/project")
const EnumItem = require("@game/ReplicatedStorage/class/arch/EnumItem")
const ftype = require("@game/ReplicatedStorage/static/ftype")

const private = {}
const class: declare.enumobject = object:new({
	type = "enumobject",
	name = script.Name,

	get_enums_list = ftype:write(function<T>(self: declare.enumobject): { [unknown]: declare.enumitem }
		const result: { [unknown]: declare.enumitem } = {}
		for i, v in self :: { [string]: unknown } do
			if object.is(v, EnumItem.type) then
				result[i] = v :: declare.enumitem
			end
		end

		return result
	end, declare.table, "enumobject"),

	get_enums_count = ftype:write(function(self: declare.enumobject): number
		local count = 0

		for _, _ in self:get_enums_list() do
			count += 1
		end

		return count
	end, declare.number, "enumobject"),

	get_enums_name = ftype:write(function(self: declare.enumobject, ...: declare.enumitem): ...string
		const result: { string } = {}

		for i, v in { ... } do
			if self:is_my_enumitem(v) then
				table.insert(result, v.name)
			end
		end

		return unpack(result)
	end, ftype:var(declare.string), "enumobject", ftype:var("enumitem")),

	get_enumitem_by_hashlink = ftype:write(function(hashlink: string): declare.enumitem
		return assert(
			private.item_builded[hashlink],
			"enumitem with received hashlink does not exists or loaded right now"
		)
	end, "enumitem", declare.string),

	is_my_enumitem = ftype:write(function(self: declare.enumobject, that: declare.enumitem): boolean
		return object.is(that, EnumItem.type) and self[that.name] ~= nil and that.enum == self
	end, declare.boolean, "enumobject", "enumitem"),

	assert_is_my_enumitem = ftype:write(function(self: declare.enumobject, that: unknown): boolean
		return assert(
			object.is(that, "enumitem") and self:is_my_enumitem(that :: declare.enumitem),
			"received data isn't expected enumitem"
		)
	end, declare.boolean, "enumobject", "enumitem"),
})

class:host(function(new: declare.enumobject)
	for i, v in new:get_enums_list() do
		const name = tostring(i);

		(v :: any).enum = new
		v.name = name;		(v :: any).hashlink = Cryptography.Hashing.Blake3.Digest(buffer.fromstring(name))

		if project.debug then
			const collision = private.item_builded[v.hashlink]

			if collision then
				project.console_out_error(
					string.format(
						"enumitem hashlink collision with: \n\n %s (%s) \n %s (%s) \n\n parents: \n\n %s \n %s  ",
						v.name,
						v.hashlink,
						collision.name,
						collision.hashlink,
						v.enum and v.enum.name or "null",
						collision.enum and collision.enum.name or "null"
					)
				)
			end
		end

		private.item_builded[v.hashlink] = v
		if project.enumobject_freeze_related_items then
			table.freeze(v)
		end
	end
end)

do
	private.item_builded = setmetatable({} :: { [string]: declare.enumitem }, table.freeze({ __mode = "vs" }))
end

return class
