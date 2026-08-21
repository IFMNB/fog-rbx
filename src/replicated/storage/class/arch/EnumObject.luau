--!strict

const Cryptography = require("@game/ReplicatedStorage/dependency/Cryptography")
const object = require("@game/ReplicatedStorage/object")
const declare = require("@game/ReplicatedStorage/static/declare")
const namefield = require("@game/ReplicatedStorage/static/namefield")
const project = require("@game/ReplicatedStorage/static/project")

const private = {}
const class: declare.enumobject = object:new({
	type = namefield.enumobject,
	name = script.Name,

	get_enums_list = function<T>(self: declare.enumobject): { [unknown]: declare.enumitem }
		const result: { [unknown]: declare.enumitem } = {}
		for i, v in self :: { [string]: unknown } do
			if object.is(v, namefield.enumitem) then
				result[i] = v :: declare.enumitem
			end
		end

		return result
	end,

	get_enums_count = function(self: declare.enumobject): number
		return #self:get_enums_list()
	end,

	get_enums_name = function(...: declare.enumitem): ...string
		const result: { string } = {}
		for i, v in { ... } do
			table.insert(result, v.name)
		end

		return unpack(result)
	end,

	get_enumitem_by_hashlink = function(hashlink: string): declare.enumitem
		return assert(
			private.item_builded[hashlink],
			"enumitem with received hashlink does not exists or loaded right now"
		)
	end,

	is_my_enumitem = function(self: declare.enumobject, that: declare.enumitem): boolean
		return self[that.name] ~= nil
	end,

	assert_is_my_enumitem = function(self: declare.enumobject, that: unknown): boolean
		return assert(
			object.is(that, namefield.enumitem) and self:is_my_enumitem(that :: declare.enumitem),
			"received data isn't expected enumitem"
		)
	end,
})

class:host(function(new: declare.enumobject)
	for i, v in new:get_enums_list() do
		const name = tostring(i);

		(v :: any).enum = new;
		v.name = name;
		(v :: any).hashlink = Cryptography.Hashing.Blake3.Digest(buffer.fromstring(name));
	
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
	end
end)

do
	private.item_builded = setmetatable({} :: { [string]: declare.enumitem }, table.freeze({ __mode = "vs" }))
end

return class
