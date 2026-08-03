--!strict

const EnumObject = require("../class/arch/EnumObject")
const EnumItem = require("../class/arch/EnumItem")

local map : {}

const class = EnumObject:new({
	name = "CloseReason",

	--[=[
		Сервер был выключен в результате технических неполадок Roblox.
	]=]
	RobloxMaintenance = EnumItem:new({
		name = "RobloxMaintenance",
	}),

	--[=[
		Сервер был выключен из-за приказа о выключении, направленного
		через дэшборд Roblox.
	]=]
	DeveloperShutdown = EnumItem:new({
		name = "DeveloperShutdown",
	}),

	--[=[
		Сервер был выключен в ходе рассылки обновлений через
		дэшборд Roblox.
	]=]
	DeveloperUpdate = EnumItem:new({
		name = "DeveloperUpdate",
	}),

	--[=[
		На сервере не осталось игроков.
	]=]
	ServerEmpty = EnumItem:new({
		name = "ServerEmpty",
	}),

	--[=[
		Сервер, скорее всего, имел утечку памяти и был выключен
		в результате переполнения доступного ОЗУ.
	]=]
	OutOfMemory = EnumItem:new({
		name = "OutOfMemory",
	}),

	--[=[
		Сервер был отключен в результате модерации Roblox.
	]=]
	Moderation = EnumItem:new({
		name = "Moderation",
	}),

	--[=[
		Сервер был выключен потому, что был подан сигнал от разработчика
		прямо на этом сервере.
	]=]
	ConsoleRequest = EnumItem:new({
		name = "ConsoleRequest",
	}),

	--[=[
		Сервер был выключен потому, что его синглтон был освобождён
		по неизвестной причине.
	]=]
	SingletoneDestroyed = EnumItem:new({
		name = "SingletoneDestroyed",
	}),

	--[=[
		Сервер выключен по внутриигровой причине, такой как уничтожение
		его экземпляра в ходе какого-либо режима игры.
	]=]
	GameReason = EnumItem:new({
		name = "GameReason",
	}),

})

map = {
	[Enum.CloseReason.Unknown] = class.Unknown,
	[Enum.CloseReason.ServerEmpty] = class.ServerEmpty,
	[Enum.CloseReason.RobloxMaintenance] = class.RobloxMaintenance,
	[Enum.CloseReason.OutOfMemory] = class.OutOfMemory,
	[Enum.CloseReason.Moderation] = class.Moderation,
	[Enum.CloseReason.DeveloperUpdate] = class.DeveloperUpdate,
	[Enum.CloseReason.DeveloperShutdown] = class.DeveloperShutdown,
}


return class