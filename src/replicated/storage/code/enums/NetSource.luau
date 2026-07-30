--!strict

const Players = game:GetService("Players")
const RunService = game:GetService("RunService")

const EnumObject = require("../class/arch/EnumObject")
const EnumItem = require("../class/arch/EnumItem")
const declare = require("../static/declare")

const class = EnumObject:new({
	name = "NetSource",

	--[=[
		Источник этого сетевого трафика — сервер.

		Обращения с `NetSource.FromServer`, полученные от клиентов,
		приведут к автоматическому кику клиента.
	]=]
	FromServer = EnumItem:new({
		name = "FromServer",
	}),

	--[=[
		Источник этого сетевого трафика — эта машина.

		Существует только на стороне текущей машины, на которой
		работает этот код. Иначе всегда преобразуется в
		`NetSource.FromClient`.
	]=]
	FromMe = EnumItem:new({
		name = "FromMe",
	}),

	--[=[
		Источник этого сетевого трафика — другой клиент.

		Определяется на стороне сервера вручную.
	]=]
	FromClient = EnumItem:new({
		name = "FromClient",
	}),

	--[=[
		`NetSource.FromClient` и `NetSource.FromServer`
		устанавливаются только вручную.
	]=]
	get_enum_by_current_machine = function(self)
		if RunService:IsServer() then
			return self.FromMe
		else
			if Players.LocalPlayer then
				return self.FromMe
			else
				return self.Unknown
			end
		end
	end,
})

return class