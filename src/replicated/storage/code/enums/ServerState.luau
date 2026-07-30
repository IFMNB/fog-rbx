--!strict

const EnumObject = require("../class/arch/EnumObject")
const EnumItem = require("../class/arch/EnumItem")
const declare = require("../static/declare")

const class = EnumObject:new({
	name = "ServerState",

	--[=[
		Сервер подготавливается к выключению. После завершения текущей
		сессии или активации сигнала выключения сервер будет уничтожен.
	]=]
	PendingShutdown = EnumItem:new({
		name = "PendingShutdown",
	}),

	--[=[
		Сервер на данный момент выключается.
	]=]
	Shutdown = EnumItem:new({
		name = "Shutdown",
	}),

	--[=[
		Сервер был инициализирован только что и в данный момент проходит
		проверки и подгружает информацию.
	]=]
	InitiatedNow = EnumItem:new({
		name = "InitiatedNow",
	}),

	--[=[
		Сервер находится в штатном состоянии.
	]=]
	Online = EnumItem:new({
		name = "Online",
	}),

	--[=[
		По неизвестной причине сервер находится в критическом состоянии:
		не отвечает на запросы, не может продолжать игру или находится
		в ином состоянии, не позволяющем ему работать.
	]=]
	Critical = EnumItem:new({
		name = "Critical",
	}),
})

return class
