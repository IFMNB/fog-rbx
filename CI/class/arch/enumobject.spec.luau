--!strict

const EnumItem = require("@game/ReplicatedStorage/class/core/EnumItem")
const JestGlobals = require("@game/ReplicatedStorage/shared/dev_dependency/JestGlobals")

const describe = JestGlobals.describe
const it = JestGlobals.it
const expect = JestGlobals.expect

const enumobject = require("@game/ReplicatedStorage/class/core/EnumObject")
const object = require("@game/ReplicatedStorage/object")

describe("enumobject", function()
	describe("class", function()
		it("has the correct type", function()
			expect(enumobject.type).toBe("enumobject")
		end)

		it("inherits from object", function()
			expect(enumobject:is("object")).toBe(true)
			expect(enumobject:base()).toBe(object)
		end)

		it("is an enumobject", function()
			expect(enumobject:is("enumobject")).toBe(true)
			expect(enumobject:equals("enumobject")).toBe(true)
		end)
	end)

	describe("construction", function()
		it("creates an enumobject", function()
			const new = enumobject:new()

			expect(new).toBeDefined()
			expect(new:is("enumobject")).toBe(true)
		end)

		it("has no enumitems by default", function()
			const new = enumobject:new()

			expect(new:get_enums_list()).toEqual({})
			expect(new:get_enums_count()).toBe(0)
		end)
	end)

	describe("get_enums_list", function()
		it("returns a new table", function()
			const new = enumobject:new()

			const first = new:get_enums_list()
			const second = new:get_enums_list()

			expect(first).never.toBe(second)
		end)
	end)

	describe("get_enums_count", function()
		it("returns zero for an empty enumobject", function()
			const new = enumobject:new()

			expect(new:get_enums_count()).toBe(0)
		end)
	end)

	describe("get_enums_name", function()
		it("does not returns the names of pseudo-enumitems", function()
			const first: any = {
				name = "First",
			}

			const second: any = {
				name = "Second",
			}

			const first_name, second_name = enumobject:get_enums_name(first, second)

			expect(first_name).never.toBe("First")
			expect(second_name).never.toBe("Second")
		end)

		it("returns the names of his items", function()
			const test =
				enumobject:new({ alpha = EnumItem:new({ name = "alpha" }), beta = EnumItem:new({ name = "beta" }) })
			const n0, n1 = test:get_enums_name(test.alpha, test.beta)

			expect(n0).toBe(test.alpha.name)
			expect(n1).toBe(test.beta.name)
		end)
	end)

	describe("is_my_enumitem", function()
		it("returns false for an unrelated enumitem", function()
			const first_enum = enumobject:new()
			const second_enum = enumobject:new()

			const item = {
				name = "Item",
			} :: any

			(first_enum :: any).Item = item

			expect(second_enum:is_my_enumitem(item)).toBe(false)
		end)

		it("rejects unknown items", function()
			const item_without_object = EnumItem:new({ name = "1" })
			const object_with_item = enumobject:new({ itemtest = EnumItem:new({ name = "2" }) })

			expect(enumobject:is_my_enumitem(item_without_object)).toBe(false)
			expect(enumobject:is_my_enumitem(object_with_item.itemtest)).toBe(false)
		end)
	end)

	describe("assert_is_my_enumitem", function()
		it("rejects an unrelated value", function()
			const new = enumobject:new()

			expect(function()
				new:assert_is_my_enumitem({})
			end).toThrow("received data isn't expected enumitem")
		end)
	end)

	describe("get_enumitem_by_hashlink", function()
		it("rejects an unknown hashlink", function()
			const new = enumobject:new()

			expect(function()
				new.get_enumitem_by_hashlink("unknown")
			end).toThrow("enumitem with received hashlink does not exists or loaded right now")
		end)
	end)
end)
