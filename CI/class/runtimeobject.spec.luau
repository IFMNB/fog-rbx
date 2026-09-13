--!strict

const JestGlobals = require("@game/ReplicatedStorage/shared/dev_dependency/JestGlobals")

const describe = JestGlobals.describe
const it = JestGlobals.it
const expect = JestGlobals.expect

const runtimeobject = require("@game/ReplicatedStorage/runtimeobject")
const object = require("@game/ReplicatedStorage/object")

describe("runtimeobject", function()
	describe("class", function()
		it("inherits from object", function()
			expect(runtimeobject:is("object")).toBe(true)
			expect(runtimeobject:base()).toBe(object)
		end)

		it("has the correct type", function()
			expect(runtimeobject.type).toBe("runtimeobject")
		end)

		it("is an object and a runtimeobject", function()
			expect(runtimeobject:is("object")).toBe(true)
			expect(runtimeobject:is("runtimeobject")).toBe(true)

			expect(runtimeobject:equals("runtimeobject")).toBe(true)
			expect(runtimeobject:equals("object")).toBe(false)
		end)
	end)

	describe("construction", function()
		it("creates a runtimeobject", function()
			const new = runtimeobject:new()

			expect(new).toBeDefined()
			expect(new:is("runtimeobject")).toBe(true)
			expect(new:is("object")).toBe(true)
		end)

		it("creates unique identities", function()
			const first = runtimeobject:new()
			const second = runtimeobject:new()

			expect(first.identity).never.toBe(second.identity)
		end)

		it("can be retrieved through object.require", function()
			const new = runtimeobject:new()

			expect(object.require(new.identity)).toBe(new)
		end)

		it("initializes an empty dependency storage", function()
			const new = runtimeobject:new()

			expect(new:get_dependencies()).toEqual({})
		end)
	end)

	describe("creation time", function()
		it("returns a DateTime", function()
			const new = runtimeobject:new()
			const creation_time = new:get_creation_time()

			expect(creation_time).toEqual(expect.any("DateTime"))
		end)

		it("returns the creation time associated with the object", function()
			const new = runtimeobject:new()

			const first = new:get_creation_time()
			const second = new:get_creation_time()

			expect(first).toEqual(second)
		end)

		it("returns the immutable creation time", function()
			const new = runtimeobject:new()

			const first = new:get_creation_time()

			task.wait()

			const second = new:get_creation_time()

			expect(first).toEqual(second)
		end)

		it("gives different objects independent creation times", function()
			const first = runtimeobject:new()
			const second = runtimeobject:new()

			const first_time = first:get_creation_time()
			const second_time = second:get_creation_time()

			expect(first_time).toEqual(expect.any("DateTime"))
			expect(second_time).toEqual(expect.any("DateTime"))
		end)
	end)

	describe("dependencies", function()
		it("adds an unnamed dependency", function()
			const new = runtimeobject:new()
			const dependency = {}

			new:add_dependency(dependency)

			expect(new:get_dependency(1)).toBe(dependency)
		end)

		it("adds multiple unnamed dependencies", function()
			const new = runtimeobject:new()

			const first = {}
			const second = {}
			const third = {}

			new:add_dependency(first)
			new:add_dependency(second)
			new:add_dependency(third)

			expect(new:get_dependency(1)).toBe(first)
			expect(new:get_dependency(2)).toBe(second)
			expect(new:get_dependency(3)).toBe(third)
		end)

		it("does not add the same unnamed dependency twice", function()
			const new = runtimeobject:new()
			const dependency = {}

			new:add_dependency(dependency)
			new:add_dependency(dependency)

			expect(new:get_dependencies()).toEqual({
				dependency,
			})
		end)

		it("adds a named dependency", function()
			const new = runtimeobject:new()
			const dependency = {}

			new:add_dependency(dependency, "dependency")

			expect(new:get_dependency("dependency")).toBe(dependency)
		end)

		it("supports arbitrary labels", function()
			const new = runtimeobject:new()

			const first = {}
			const second = {}
			const third = {}

			new:add_dependency(first, "first")
			new:add_dependency(second, 123)
			new:add_dependency(third, true)

			expect(new:get_dependency("first")).toBe(first)
			expect(new:get_dependency(123)).toBe(second)
			expect(new:get_dependency(true)).toBe(third)
		end)

		it("does not overwrite an existing named dependency", function()
			const new = runtimeobject:new()

			const first = {}
			const second = {}

			new:add_dependency(first, "dependency")
			new:add_dependency(second, "dependency")

			expect(new:get_dependency("dependency")).toBe(first)
		end)

		it("removes an unnamed dependency", function()
			const new = runtimeobject:new()

			const first = {}
			const second = {}

			new:add_dependency(first)
			new:add_dependency(second)

			new:rem_dependency(first)

			expect(new:get_dependency(1)).toBe(second)
			expect(new:get_dependency(2)).toBeNil()
		end)

		it("removes a named dependency", function()
			const new = runtimeobject:new()
			const dependency = {}

			new:add_dependency(dependency, "dependency")
			new:rem_dependency(dependency, "dependency")

			expect(new:get_dependency("dependency")).toBeNil()
		end)

		it("does nothing when removing a missing unnamed dependency", function()
			const new = runtimeobject:new()

			const first = {}
			const missing = {}

			new:add_dependency(first)
			new:rem_dependency(missing)

			expect(new:get_dependency(1)).toBe(first)
		end)

		it("does nothing when removing a missing named dependency", function()
			const new = runtimeobject:new()

			const dependency = {}

			new:add_dependency(dependency, "dependency")
			new:rem_dependency({}, "missing")

			expect(new:get_dependency("dependency")).toBe(dependency)
		end)

		it("does not leak dependencies between objects", function()
			const first = runtimeobject:new()
			const second = runtimeobject:new()

			const dependency = {}

			first:add_dependency(dependency)

			expect(first:get_dependency(1)).toBe(dependency)
			expect(second:get_dependency(1)).toBeNil()
			expect(second:get_dependencies()).toEqual({})
		end)

		it("returns a copy from get_dependencies", function()
			const new = runtimeobject:new()
			const dependency = {}

			new:add_dependency(dependency)

			const dependencies = new:get_dependencies()

			table.clear(dependencies)

			expect(new:get_dependency(1)).toBe(dependency)
		end)
	end)

	describe("dependency replacement", function()
		it("allows a label to be reused after removal", function()
			const new = runtimeobject:new()

			const first = {}
			const second = {}

			new:add_dependency(first, "dependency")
			new:rem_dependency(first, "dependency")
			new:add_dependency(second, "dependency")

			expect(new:get_dependency("dependency")).toBe(second)
		end)

		it("allows an unnamed dependency to be re-added after removal", function()
			const new = runtimeobject:new()
			const dependency = {}

			new:add_dependency(dependency)
			new:rem_dependency(dependency)
			new:add_dependency(dependency)

			expect(new:get_dependency(1)).toBe(dependency)
		end)
	end)
end)
