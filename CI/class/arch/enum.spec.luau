--!strict

const JestGlobals = require("@game/ReplicatedStorage/shared/dev_dependency/JestGlobals")

const describe = JestGlobals.describe
const it = JestGlobals.it
const expect = JestGlobals.expect

const enumobject = require("@game/ReplicatedStorage/class/core/EnumObject")
const enumitem = require("@game/ReplicatedStorage/class/core/EnumItem")

describe("enumobject with enumitems", function()
	local function create_enum()
		const new = enumobject:new({
			First = enumitem:new({ name = "First" }),
			Second = enumitem:new({ name = "Second" }),
			Third = enumitem:new({ name = "Third" }),
		})

		return new
	end

	describe("item initialization", function()
		it("assigns the enum to every item", function()
			const new = create_enum()

			expect(new.First.enum).toBe(new)
			expect(new.Second.enum).toBe(new)
			expect(new.Third.enum).toBe(new)
		end)

		it("assigns the property name to every item", function()
			const new = create_enum()

			expect(new.First.name).toBe("First")
			expect(new.Second.name).toBe("Second")
			expect(new.Third.name).toBe("Third")
		end)

		it("generates the final hashlink from the enumitem name", function()
			const new = create_enum()

			expect(new.First.hashlink).never.toBe("")
			expect(new.Second.hashlink).never.toBe("")
			expect(new.Third.hashlink).never.toBe("")

			expect(new.First.hashlink).never.toBe(new.Second.hashlink)
			expect(new.First.hashlink).never.toBe(new.Third.hashlink)
			expect(new.Second.hashlink).never.toBe(new.Third.hashlink)
		end)
	end)

	describe("get_enums_list", function()
		it("returns all enumitems", function()
			const new = create_enum()
			const list = new:get_enums_list()

			expect(list.First).toBe(new.First)
			expect(list.Second).toBe(new.Second)
			expect(list.Third).toBe(new.Third)
		end)

		it("does not include non-enumitem fields", function()
			const new = enumobject:new({
				First = enumitem:new({ name = "First" }),
				value = 123,
				name = "Test",
			})

			const list = new:get_enums_list()

			expect(list[new.name]).toBe(new.First)
			expect(list.value).toBeNil()
			expect(list.name).toBeNil()
		end)
	end)

	describe("get_enums_count", function()
		it("returns the number of array-position enumitems", function()
			const new = enumobject:new({
				[1] = enumitem:new(),
				[2] = enumitem:new(),
				[3] = enumitem:new(),
			})

			expect(new:get_enums_count()).toBe(3)
		end)
	end)

	describe("get_enums_name", function()
		it("returns names assigned by enumobject", function()
			const new = create_enum()

			const first, second, third = enumobject:get_enums_name(new.First, new.Second, new.Third)

			expect(first).toBe("First")
			expect(second).toBe("Second")
			expect(third).toBe("Third")
		end)
	end)

	describe("is_my_enumitem", function()
		it("recognizes its own enumitems", function()
			const new = create_enum()

			expect(new:is_my_enumitem(new.First)).toBe(true)
			expect(new:is_my_enumitem(new.Second)).toBe(true)
			expect(new:is_my_enumitem(new.Third)).toBe(true)
		end)

		it("rejects another enum's enumitem", function()
			const first = create_enum()
			const second = create_enum()

			expect(first:is_my_enumitem(second.First)).toBe(false)
		end)
	end)

	describe("assert_is_my_enumitem", function()
		it("accepts its own enumitem", function()
			const new = create_enum()

			expect(new:assert_is_my_enumitem(new.First)).toBe(true)
		end)

		it("rejects another enum's enumitem", function()
			const first = create_enum()
			const second = create_enum()

			expect(function()
				first:assert_is_my_enumitem(second.First)
			end).toThrow("received data isn't expected enumitem")
		end)

		it("rejects an ordinary object", function()
			const new = create_enum()

			expect(function()
				new:assert_is_my_enumitem({})
			end).toThrow("received data isn't expected enumitem")
		end)
	end)

	describe("hashlink lookup", function()
		it("retrieves an enumitem by hashlink", function()
			const new = create_enum()

			const first = new.get_enumitem_by_hashlink(new.First.hashlink)

			const second = new.get_enumitem_by_hashlink(new.Second.hashlink)

			expect(first).toBe(new.First)
			expect(second).toBe(new.Second)
		end)

		it("uses a global hashlink index", function()
			const first = create_enum()
			const second = create_enum()

			expect(first.get_enumitem_by_hashlink(second.First.hashlink)).toBe(second.First)
		end)
	end)

	describe("hashlink uniqueness", function()
		it("produces the same hashlink for equal names", function()
			const first = enumitem:new({
				name = "Same",
			})

			const second = enumitem:new({
				name = "Same",
			})

			expect(first.hashlink).toBe(second.hashlink)
		end)
	end)
end)
