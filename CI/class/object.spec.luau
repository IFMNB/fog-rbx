--!strict

const object = require("@game/ReplicatedStorage/object")

const JestGlobals = require("@game/ReplicatedStorage/shared/dev_dependency/JestGlobals")

local describe = JestGlobals.describe
local it = JestGlobals.it
local expect = JestGlobals.expect

describe("object", function()
	describe("class", function()
		it("has the correct root metadata", function()
			expect(object.type).toBe("object")
		end)

		it("is an object", function()
			expect(object:is("object")).toBe(true)
			expect(object:is("anyt")).toBe(true)
			expect(object:equals("object")).toBe(true)
		end)

		it("has no base", function()
			expect(object:base()).toBeNil()
		end)

		it("can require itself by identity", function()
			expect(object.require(object.identity)).toBe(object)
		end)

		it("can require itself with a valid assertion", function()
			expect(object.require(object.identity, "object")).toBe(object)
		end)

        it("require returns nil if required object does not exists", function ()
            expect(object.require("missing")).toBeNil()
        end)
	end)

	describe("new", function()
		it("creates a distinct object", function()
			local first = object:new()
			local second = object:new()

			expect(first).never.toBe(object)
			expect(second).never.toBe(object)
			expect(first).never.toBe(second)
		end)

		it("preserves the object type", function()
			local new = object:new()

			expect(new.type).toBe("object")
			expect(new:is("object")).toBe(true)
			expect(new:equals("object")).toBe(true)
		end)

		it("creates a new identity", function()
			local first = object:new()
			local second = object:new()

			expect(first.identity).toEqual(expect.any("string"))
			expect(second.identity).toEqual(expect.any("string"))
			expect(first.identity).never.toBe(second.identity)
		end)

		it("registers the created object by identity", function()
			local new = object:new()

			expect(object.require(new.identity)).toBe(new)
		end)

		it("accepts initial fields", function()
			local new = object:new({
				value = 123,
				name = "test",
				enabled = true,
			})

			expect(new.value).toBe(123)
			expect(new.name).toBe("test")
			expect(new.enabled).toBe(true)
		end)

		it("does not mutate the source table", function()
			local source = {
				value = 123,
			}

			local new = object:new(source)

			new.value = 456

			expect(source.value).toBe(123)
			expect(new.value).toBe(456)
		end)

		it("does not share ordinary table fields", function()
			local source = {
				nested = {
					value = 123,
				},
			}

			local first = object:new(source)
			local second = object:new(source)

			expect(first).never.toBe(second)
			expect(first.nested).toBe(source.nested)
			expect(second.nested).toBe(source.nested)
		end)

		it("accepts nil as the initial value", function()
			local new = object:new(nil)

			expect(new).toBeDefined()
			expect(new:is("object")).toBe(true)
		end)

		it("ignores non-table initial values", function()
			local new = object:new("invalid")

			expect(new).toBeDefined()
			expect(new:is("object")).toBe(true)
		end)
	end)

	describe("inheritance", function()
		it("reports its direct base", function()
			local new = object:new()

			expect(new:base()).toBe(object)
		end)

		it("reports its base when the expected type matches", function()
			local new = object:new()

			expect(new:base("object")).toBe(object)
		end)

		it("returns nil when the expected base type does not match", function()
			local new = object:new()

			expect(new:base("not_object")).toBeNil()
		end)

		it("is an instance of its base type", function()
			local new = object:new()

			expect(new:is("object")).toBe(true)
		end)

		it("does not claim unrelated types", function()
			local new = object:new()

			expect(new:is("string")).toBe(false)
			expect(new:is("number")).toBe(false)
			expect(new:is("not_object")).toBe(false)
		end)
	end)

	describe("equals", function()
		it("matches the object's direct cached type", function()
			local new = object:new()

			expect(new:equals("object")).toBe(true)
		end)

		it("does not match unrelated types", function()
			local new = object:new()

			expect(new:equals("not_object")).toBe(false)
		end)

		it("differs from is for inheritance", function()
			local new = object:new({type = "never"})

			expect(new:equals("object")).toBe(false)
			expect(new:is("object")).toBe(true)
		end)

        it("equals to anyt special type", function ()
            local new = object:new({type = "anyt"})

            expect(new:equals("anyt")).toBe(true)
        end)
	end)

	describe("require", function()
		it("retrieves an object by identity", function()
			local new = object:new()

			local retrieved = object.require(new.identity)

			expect(retrieved).toBe(new)
		end)

		it("supports assertion by type", function()
			local new = object:new()

			local retrieved = object.require(new.identity, "object")

			expect(retrieved).toBe(new)
		end)

		it("rejects an incorrect assertion", function()
			local new = object:new()

			expect(function()
				object.require(new.identity, "not_object")
			end).toThrow("retrieved object isn't an assertion")
		end)
	end)

	describe("host", function()
		it("calls a newly registered host when an object is created", function()
			local received = nil
            local out = function (new) received = new end

			object:host(out)
			local new = object:new()
            object:host(out)

			expect(received).toBe(new)
		end)

		it("does not register the same host twice", function()
			local calls = 0

			local host = function(_)
				calls += 1
			end

			object:host(host)
			object:host(host)

			object:new()

			expect(calls).toBe(0)
		end)

		it("can unregister an existing host", function()
			local calls = 0

			local host = function(_)
				calls += 1
			end

			object:host(host)
			object:host(host)

			object:new()

			expect(calls).toBe(0)
		end)
	end)

	describe("as", function()
		it("returns the object when the assertion succeeds", function()
			local new = object:new()

			local converted = new:as("object")

			expect(converted).toBe(new)
		end)

		it("rejects an invalid conversion", function()
			local new = object:new()

			expect(function()
				new:as("not_object")
			end).toThrow("cannot convert this object to required type")
		end)
	end)
end)
