--!strict

const JestGlobals = require("@game/ReplicatedStorage/shared/dev_dependency/JestGlobals")

const describe = JestGlobals.describe
const it = JestGlobals.it
const expect = JestGlobals.expect

const Observer = require("@game/ReplicatedStorage/class/arch/Observer")
const EnumItem = require("@game/ReplicatedStorage/class/core/EnumItem")
const EnumObject = require("@game/ReplicatedStorage/class/core/EnumObject")
const ConnectionVariant = require("@game/ReplicatedStorage/enums/descriptor/ConnectionVariant")
const ObserverSettingVariant = require("@game/ReplicatedStorage/enums/descriptor/ObserverSettingVariant")

describe("Observer", function()
	const cached = EnumObject:new({
		First = EnumItem:new(),
		Second = EnumItem:new(),
		Third = EnumItem:new(),
	})
	const cached2 = EnumItem:new({ name = "TestNotification" })

	local function create_notification()
		return cached2
	end

	local function create_notifications()
		return cached
	end

	describe("class", function()
		it("has the correct type", function()
			expect(Observer.type).toBe("observer")
		end)

		it("inherits from runtimeobject", function()
			expect(Observer:is("runtimeobject")).toBe(true)
		end)

		it("creates an observer", function()
			local observer = Observer:new()

			expect(observer).toBeDefined()
			expect(observer:is("observer")).toBe(true)
		end)

		it("has new connections enabled by default", function()
			local observer = Observer:new()

			expect(observer.allow_new_connections).toBe(true)
		end)

		it("uses deferred calls by default", function()
			local observer = Observer:new()

			expect(observer.deffered_call).toBe(true)
		end)

		it("does not use deferred mode by default", function()
			local observer = Observer:new()

			expect(observer.deffered_mode).toBe(false)
		end)
	end)

	describe("subscribe", function()
		it("subscribes a function", function()
			local observer = Observer:new()
			local notification = create_notification()

			local called = false

			local pointer = observer:subscribe(notification, ConnectionVariant.Ever, function()
				called = true
			end)

			expect(pointer).toBeDefined()
			expect(called).toBe(false)
		end)

		it("returns a pointer for every connection", function()
			local observer = Observer:new()
			local notification = create_notification()

			local first = observer:subscribe(notification, ConnectionVariant.Ever, function() end)

			local second = observer:subscribe(notification, ConnectionVariant.Ever, function() end)

			expect(first).never.toBe(second)
		end)

		it("supports multiple callbacks in one subscription", function()
			local observer = Observer:new()
			local notification = create_notification()

			local first_called = false
			local second_called = false

			local first_pointer, second_pointer = observer:subscribe(notification, ConnectionVariant.Ever, function()
				first_called = true
			end, function()
				second_called = true
			end)

			expect(first_pointer).toBeDefined()
			expect(second_pointer).toBeDefined()
			expect(first_pointer).never.toBe(second_pointer)

			observer.deffered_call = false

			observer:notificate(notification)

			expect(first_called).toBe(true)
			expect(second_called).toBe(true)
		end)

		it("does not create a connection when connections are disabled", function()
			local observer = Observer:new()
			local notification = create_notification()

			observer.allow_new_connections = false

			local pointer = observer:subscribe(notification, ConnectionVariant.Ever, function() end)

			expect(pointer).toBeNil()
		end)
	end)

	describe("Ever", function()
		it("calls the callback every time", function()
			local observer = Observer:new()
			local notification = create_notification()

			observer.deffered_call = false

			local count = 0

			observer:subscribe(notification, ConnectionVariant.Ever, function()
				count += 1
			end)

			observer:notificate(notification)
			observer:notificate(notification)
			observer:notificate(notification)

			expect(count).toBe(3)
		end)
	end)

	describe("Once", function()
		it("calls the callback once", function()
			local observer = Observer:new()
			local notification = create_notification()

			observer.deffered_call = false

			local count = 0

			observer:subscribe(notification, ConnectionVariant.Once, function()
				count += 1
			end)

			observer:notificate(notification)
			observer:notificate(notification)

			expect(count).toBe(1)
		end)

		it("removes the connection after notification", function()
			local observer = Observer:new()
			local notification = create_notification()

			observer.deffered_call = false

			local pointer = observer:subscribe(notification, ConnectionVariant.Once, function() end)

			expect(observer:get_mode_of(pointer)).toBe(ConnectionVariant.Once)

			observer:notificate(notification)

			expect(pointer:is_pointed_exists()).toBe(true)

			observer:unsubscribe(pointer)

			expect(observer:get_mode_of(pointer)).toBeNil()
		end)
	end)

	describe("Next", function()
		it("moves the connection to Ever", function()
			local observer = Observer:new()
			local notification = create_notification()

			observer.deffered_call = false

			local count = 0

			local pointer = observer:subscribe(notification, ConnectionVariant.Next, function()
				count += 1
			end)

			expect(observer:get_mode_of(pointer)).toBe(ConnectionVariant.Next)

			observer:notificate(notification)

			expect(count).toBe(0)
			expect(observer:get_mode_of(pointer)).toBe(ConnectionVariant.Ever)

			observer:notificate(notification)

			expect(count).toBe(1)
		end)
	end)

	describe("Skip", function()
		it("moves the connection to Once", function()
			local observer = Observer:new()
			local notification = create_notification()

			observer.deffered_call = false

			local count = 0

			local pointer = observer:subscribe(notification, ConnectionVariant.Skip, function()
				count += 1
			end)

			expect(observer:get_mode_of(pointer)).toBe(ConnectionVariant.Skip)

			observer:notificate(notification)

			expect(count).toBe(0)
			expect(observer:get_mode_of(pointer)).toBe(ConnectionVariant.Once)

			observer:notificate(notification)

			expect(count).toBe(1)

			observer:notificate(notification)

			expect(count).toBe(1)
		end)
	end)

	describe("Hold", function()
		it("does not call the callback", function()
			local observer = Observer:new()
			local notification = create_notification()

			observer.deffered_call = false

			local called = false

			observer:subscribe(notification, ConnectionVariant.Hold, function()
				called = true
			end)

			observer:notificate(notification)

			expect(called).toBe(false)
		end)

		it("keeps the connection", function()
			local observer = Observer:new()
			local notification = create_notification()

			observer.deffered_call = false

			local pointer = observer:subscribe(notification, ConnectionVariant.Hold, function() end)

			observer:notificate(notification)

			expect(observer:get_mode_of(pointer)).toBe(ConnectionVariant.Hold)
		end)
	end)

	describe("Never", function()
		it("does not call the callback", function()
			local observer = Observer:new()
			local notification = create_notification()

			observer.deffered_call = false

			local called = false

			observer:subscribe(notification, ConnectionVariant.Never, function()
				called = true
			end)

			observer:notificate(notification)

			expect(called).toBe(false)
		end)

		it("keeps the connection", function()
			local observer = Observer:new()
			local notification = create_notification()

			observer.deffered_call = false

			local pointer = observer:subscribe(notification, ConnectionVariant.Never, function() end)

			observer:notificate(notification)

			expect(observer:get_mode_of(pointer)).toBe(ConnectionVariant.Never)
		end)
	end)

	describe("unsubscribe", function()
		it("removes a connection", function()
			local observer = Observer:new()
			local notification = create_notification()

			observer.deffered_call = false

			local count = 0

			local pointer = observer:subscribe(notification, ConnectionVariant.Ever, function()
				count += 1
			end)

			observer:unsubscribe(pointer)
			observer:notificate(notification)

			expect(count).toBe(0)
		end)

		it("accepts multiple pointers", function()
			local observer = Observer:new()
			local notification = create_notification()

			observer.deffered_call = false

			local first_count = 0
			local second_count = 0

			local first, second = observer:subscribe(notification, ConnectionVariant.Ever, function()
				first_count += 1
			end, function()
				second_count += 1
			end)

			observer:unsubscribe(first, second)
			observer:notificate(notification)

			expect(first_count).toBe(0)
			expect(second_count).toBe(0)
		end)

		it("is safe when called twice", function()
			local observer = Observer:new()
			local notification = create_notification()

			observer.deffered_call = false

			local pointer = observer:subscribe(notification, ConnectionVariant.Ever, function() end)

			observer:unsubscribe(pointer)
			observer:unsubscribe(pointer)

			expect(observer:get_mode_of(pointer)).toBeNil()
		end)

		it("allows a callback to unsubscribe another callback", function()
			local observer = Observer:new()
			local notification = create_notification()

			observer.deffered_call = false

			local first_count = 0
			local second_count = 0

			local first: any
			local second: any

			first = observer:subscribe(notification, ConnectionVariant.Ever, function()
				first_count += 1
				observer:unsubscribe(second)
			end)

			second = observer:subscribe(notification, ConnectionVariant.Ever, function()
				second_count += 1
			end)

			observer:notificate(notification)

			expect(first_count).toBe(1)
			expect(second_count).toBe(1)

			observer:notificate(notification)

			expect(first_count).toBe(2)
			expect(second_count).toBe(1)

			observer:unsubscribe(first)
		end)
	end)

	describe("get_mode_of", function()
		it("returns the current mode", function()
			local observer = Observer:new()
			local notification = create_notification()

			const pointer = observer:subscribe(notification, ConnectionVariant.Ever, function() end)

			expect(observer:get_mode_of(pointer)).toBe(ConnectionVariant.Ever)
		end)

		it("returns modes for multiple pointers", function()
			local observer = Observer:new()
			local notification = create_notification()

			const first, second = observer:subscribe(
				notification,
				ConnectionVariant.Ever,

				function() end,

				function() end
			)

			local first_mode, second_mode = observer:get_mode_of(first, second)

			expect(first_mode).toBe(ConnectionVariant.Ever)
			expect(second_mode).toBe(ConnectionVariant.Ever)
		end)

		it("returns no mode for an unknown pointer", function()
			local observer = Observer:new()
			local notification = create_notification()

			local pointer = Observer:new():subscribe(notification, ConnectionVariant.Ever, function() end)

			expect(observer:get_mode_of(pointer)).toBeNil()
		end)
	end)

	describe("subscription", function()
		it("changes Ever to Once", function()
			local observer = Observer:new()
			local notification = create_notification()

			local pointer = observer:subscribe(notification, ConnectionVariant.Ever, function() end)

			observer:subscription(ObserverSettingVariant.ChangeModeToOnce, pointer)

			expect(observer:get_mode_of(pointer)).toBe(ConnectionVariant.Once)
		end)

		it("changes Ever to Next", function()
			local observer = Observer:new()
			local notification = create_notification()

			local pointer = observer:subscribe(notification, ConnectionVariant.Ever, function() end)

			observer:subscription(ObserverSettingVariant.ChangeModeToNext, pointer)

			expect(observer:get_mode_of(pointer)).toBe(ConnectionVariant.Next)
		end)

		it("changes Ever to Skip", function()
			local observer = Observer:new()
			local notification = create_notification()

			local pointer = observer:subscribe(notification, ConnectionVariant.Ever, function() end)

			observer:subscription(ObserverSettingVariant.ChangeModeToSkip, pointer)

			expect(observer:get_mode_of(pointer)).toBe(ConnectionVariant.Skip)
		end)

		it("changes Once to Ever", function()
			local observer = Observer:new()
			local notification = create_notification()

			local pointer = observer:subscribe(notification, ConnectionVariant.Once, function() end)

			observer:subscription(ObserverSettingVariant.ChangeModeToEver, pointer)

			expect(observer:get_mode_of(pointer)).toBe(ConnectionVariant.Ever)
		end)
	end)

	describe("notifications", function()
		it("passes notification arguments to callback", function()
			local observer = Observer:new()
			local notification = create_notification()

			observer.deffered_call = false

			local received_a = nil
			local received_b = nil

			observer:subscribe(notification, ConnectionVariant.Ever, function(a, b)
				received_a = a
				received_b = b
			end)

			observer:notificate(notification, 123, "hello")

			expect(received_a).toBe(123)
			expect(received_b).toBe("hello")
		end)

		it("passes the related notification through nested observer", function()
			local observer = Observer:new()
			local nested = Observer:new()
			local notification = create_notification()

			observer.deffered_call = false
			nested.deffered_call = false

			local called = false
			local received = nil

			nested:subscribe(notification, ConnectionVariant.Ever, function(value)
				called = true
				received = value
			end)

			observer:subscribe(notification, ConnectionVariant.Ever, nested)

			observer:notificate(notification, 123)

			expect(called).toBe(true)
			expect(received).toBe(123)
		end)

		it("keeps notification iteration stable when a callback unsubscribes itself", function()
			local observer = Observer:new()
			local notification = create_notification()

			observer.deffered_call = false

			local count = 0
			local pointer

			pointer = observer:subscribe(notification, ConnectionVariant.Ever, function()
				count += 1
				observer:unsubscribe(pointer :: any)
			end)

			observer:notificate(notification)
			observer:notificate(notification)

			expect(count).toBe(1)
		end)
	end)

	describe("EnumObject notifications", function()
		it("subscribes to every enumitem", function()
			local observer = Observer:new()
			local notifications = create_notifications()

			observer.deffered_call = false

			local received = {}

			observer:subscribe(notifications, ConnectionVariant.Ever, function(related)
				table.insert(received, related)
			end)

			observer:notificate(notifications.First, notifications.First)
			observer:notificate(notifications.Second, notifications.Second)
			observer:notificate(notifications.Third, notifications.Third)

			expect(#received).toBe(3)
		end)

		it("does not notify for an unrelated enumitem", function()
			local observer = Observer:new()
			local notifications = create_notifications()
			local unrelated = create_notification()

			observer.deffered_call = false

			local count = 0

			observer:subscribe(notifications, ConnectionVariant.Ever, function()
				count += 1
			end)

			observer:notificate(unrelated)

			expect(count).toBe(0)
		end)
	end)

	describe("deferred mode", function()
		it("does not execute the callback synchronously", function()
			local observer = Observer:new()
			local notification = create_notification()

			observer.deffered_call = false
			observer.deffered_mode = true

			local called = false

			observer:subscribe(notification, ConnectionVariant.Ever, function()
				called = true
			end)

			local thread = coroutine.create(function()
				observer:notificate(notification)
			end)

			coroutine.resume(thread)

			expect(called).toBe(false)
		end)
	end)

	describe("connection failures", function()
		it("removes a failing function connection", function()
			local observer = Observer:new()
			local notification = create_notification()

			observer.deffered_call = false

			local count = 0

			local pointer = observer:subscribe(notification, ConnectionVariant.Ever, function()
				count += 1
				error("intentional failure")
			end)

			observer:notificate(notification)
			observer:notificate(notification)

			expect(count).toBe(1)
			expect(pointer:is_pointed_exists()).toBe(true)
		end)
	end)
end)
