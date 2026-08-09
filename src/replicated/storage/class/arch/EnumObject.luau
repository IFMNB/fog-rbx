--!strict

const Cryptography = require("@game/ReplicatedStorage/dependency/Cryptography")
const object = require("@game/ReplicatedStorage/object")
const declare = require("@game/ReplicatedStorage/static/declare")
const namefield = require("@game/ReplicatedStorage/static/namefield")

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

	is_my_enumitem = function(self: declare.enumobject, that: declare.enumitem): boolean
		return self[that.name] ~= nil
	end,

	assert_is_my_enumitem = function (self: declare.enumobject, that: unknown) : boolean
		return assert(object.is(that, namefield.enumitem) and self:is_my_enumitem(that :: declare.enumitem), "received data isn't expected enumitem")
	end
});

class:toggle_host(function(new: declare.enumobject)
	for i, v in new:get_enums_list() do
		const name = tostring(i)

		if v.enum == nil then
			v:child(new)
		end

		if v.name == "" then
			v.name = name
		end

		if v.hashlink == "" then
			(v :: any).hashlink = Cryptography.Hashing.Blake3.Digest(buffer.fromstring(name))
		end
	end
end)

return class
