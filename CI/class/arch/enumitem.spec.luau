--!strict

const JestGlobals = require("@game/ReplicatedStorage/shared/dev_dependency/JestGlobals")

const describe = JestGlobals.describe
const it = JestGlobals.it
const expect = JestGlobals.expect

const enumitem = require("@game/ReplicatedStorage/class/arch/EnumItem")
const object = require("@game/ReplicatedStorage/object")

describe("enumitem", function()
	describe("class", function()
		it("has the correct type", function()
			expect(enumitem.type).toBe("enumitem")
		end)

		it("inherits from object", function()
			expect(enumitem:is("object")).toBe(true)
			expect(enumitem:base()).toBe(object)
		end)

		it("is an enumitem", function()
			expect(enumitem:is("enumitem")).toBe(true)
			expect(enumitem:equals("enumitem")).toBe(true)
		end)
	end)

	describe("construction", function()
		it("creates an enumitem", function()
			const item = enumitem:new()

			expect(item).toBeDefined()
			expect(item:is("enumitem")).toBe(true)
			expect(item:is("object")).toBe(true)
		end)

		it("preserves the provided name", function()
			const item = enumitem:new({
				name = "Test",
			})

			expect(item.name).toBe("Test")
		end)

		it("generates a hashlink from the name", function()
			const item = enumitem:new({
				name = "Test",
			})

			expect(item.hashlink).toEqual(expect.any("string"))
			expect(item.hashlink).never.toBe("")
		end)

		it("generates the same hashlink for the same name", function()
			const first = enumitem:new({
				name = "Test",
			})

			const second = enumitem:new({
				name = "Test",
			})

			expect(first.hashlink).toBe(second.hashlink)
		end)

		it("generates different hashlinks for different names", function()
			const first = enumitem:new({
				name = "First",
			})

			const second = enumitem:new({
				name = "Second",
			})

			expect(first.hashlink).never.toBe(second.hashlink)
		end)

		it("has no enum by default", function()
			const item = enumitem:new({
				name = "Test",
			})

			expect(item.enum).toBeNil()
		end)
	end)

	describe("identity", function()
		it("creates unique identities", function()
			const first = enumitem:new({
				name = "First",
			})

			const second = enumitem:new({
				name = "Second",
			})

			expect(first.identity).never.toBe(second.identity)
		end)

		it("can be retrieved by object identity", function()
			const item = enumitem:new({
				name = "Test",
			})

			expect(object.require(item.identity)).toBe(item)
		end)
	end)
end)
