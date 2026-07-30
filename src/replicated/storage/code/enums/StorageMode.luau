--!strict

const EnumObject = require("../class/arch/EnumObject")
const EnumItem = require("../class/arch/EnumItem")
const declare = require("../static/declare")

const class = EnumObject:new({
	name = "StorageMode",

	--[=[
		Таблица, зарегистрированная для этого экземпляра, является
		ленивой и отсеивает ленивые ключи.

		Конкретно те, которые GC может очистить из-за их ссылочной
		природы.
	]=]
	LazyKeys = EnumItem:new({
		name = "LazyKeys",
	}),

	--[=[
		Таблица, зарегистрированная для этого экземпляра, является
		ленивой и отсеивает ленивые значения.

		Конкретно те, которые GC может очистить из-за их ссылочной
		природы.
	]=]
	LazyValues = EnumItem:new({
		name = "LazyValues",
	}),

	--[=[
		Таблица, зарегистрированная для этого экземпляра, является
		ленивой и отсеивает ленивые ключи и значения.

		Конкретно те, которые GC может очистить из-за их ссылочной
		природы.
	]=]
	LazyAll = EnumItem:new({
		name = "LazyAll",
	}),

	--[=[
		Таблица, зарегистрированная для этого экземпляра, является
		сильной и не позволит ключам и значениям внутри неё
		исчезнуть без прямых манипуляций с ней.
	]=]
	Strong = EnumItem:new({
		name = "Strong",
	}),
})

return class