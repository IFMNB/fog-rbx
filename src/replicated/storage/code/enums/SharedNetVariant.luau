--!strict

const EnumObject = require("../class/arch/EnumObject")
const EnumItem = require("../class/arch/EnumItem")
const declare = require("../static/declare")

const class = EnumObject:new({
	name = "NetworkChannel",

	--[=[
		Канал для внешнего небезопасного, но быстрого общения с клиентами
		через `UnreliableRemoteEvent`.
	]=]
	Unsafe = EnumItem:new({
		name = "Unsafe",
	}),

	--[=[
		Канал для внешнего безопасного, но медленного общения с клиентами
		через `RemoteEvent`.
	]=]
	Safe = EnumItem:new({
		name = "Safe",
	}),

	--[=[
		Канал для внутреннего общения внутри сети, поскольку работает на
		основе `BindableEvent`.
	]=]
	Internal = EnumItem:new({
		name = "Internal",
	})
})

return class
