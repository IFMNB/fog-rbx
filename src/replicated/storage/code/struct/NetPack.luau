--!strict

const Players = game:GetService("Players")
const RunService = game:GetService("RunService")
const Record = require("../Record")
const enum = require("../enum")
const NetSource = require("../enums/NetSource")
const object = require("../object")
const namefield = require("../static/namefield")
const project = require("../static/project")

const class = { __index = Record }
setmetatable(class, class)

export type flat = {
    read to: {string}?,
    read loaded: {unknown}?,
    read expected: typeof(enum.Unknown)?,
    read rpc: boolean?,
    read from: number?,
    read sender: string?
}
export type class<T... = ...unknown> = object.generic<{
	payload: () -> T...,
}, typeof(class)>


class.type = namefield.netpack

--[=[
    Определяет машину, с которой был сгенерирован этот `NetPack.class`
]=]
class.from = NetSource.Unknown

--[=[
    Хранит в себе перечисленные внутри `Player.UserId`, которым должен быть выслан
    этот `NetPack.class`

    __`Если пустой, то вызов не будет отослан ни одному клиенту!`__

    Для `SharedVariant.Internal` вызов будет высылаться даже если список пуст
]=]
class.to = {} :: {string}

--[=[
    На стороне получателе будет вызывать указанный вид подписчиков, то есть работает
    аналогично `Face.class .expected`
]=]
class.expected = nil :: typeof(enum.Unknown)?

--[=[
    Если `true`, то со стороны вызвавшего этот `SharedNetLink` будет также вызван с точно
    таким жe `NetPack.class`

    Для `SharedNetVariant.Internal` состояние `true` работает как вызов `BindableEvent:Fire()`,
    а иначе вызова метода `BindableEvent` не произойдет
]=]
class.rpc = false

--[=[
    Полезная нагрузка, упакованная в этом файле
]=]
class.loaded = {}

class.sender = nil :: string?

function class.new(to: {Player|User}?, ...: unknown)
	const this = Record.new(class)
	const set : {string} = {}

    to = to or {}
    this.loaded = { ... }
    this.from = NetSource:get_enum_by_current_machine()
    this.sender = Players.LocalPlayer and Players.LocalPlayer.User:ToString()

    for _, that: Player | User in to :: {Player|User} do
        if (project.this(that, "User")) then
			table.insert(set, (that::User):ToString())
        elseif project.this(that,"Player") then
			table.insert(set, (that :: Player).User:ToString())
        else
            project.console_output "unexpected valuetype from NetPack.class .to list"
            continue
        end
    end

    for _, user_id in table.clone(set) :: {string} do
        const player = Players:GetPlayerByUserId(User.fromString(user_id) :: any)
        if (not player) then
            project.console_output "value from NetPack.class .to isn't a UserId"
            table.remove(this.to, table.find(this.to, user_id))
        end
    end

    this.to = set

	return this :: class
end

--[=[
    Конвертирует информацию из плоской таблицы в экземпляр `NetPack.class`
]=]
function class.convert_flat(from: flat)
    const that = class.new(nil, unpack(from.loaded or {}))
    
    if (type(from) == "table") then
		that.rpc = from.rpc
		that.to = from.to
		that.expected = from.expected
		that.loaded = from.loaded
        that.sender = from.sender
        that.from = from.from
    end

    return that
end

--[=[
    Переводит в плоскую неизменяемую таблицу
]=]
function class:get_flat() : flat
    return table.freeze(table.clone(self :: any)) 
end

--[=[
    Полезная нагрузка, которая пришла с источника. Она никогда недоступна
    для изменения, это принципиальное правило класса
]=]
function class:payload(): ...unknown
	return self.loaded
end

--[=[
    Возвращает все `Players`, которым было предназначено это сообщение
]=]
function class:get_players(): {Player}
	const this = self :: class
    const players: {Player} = {}

    for _, user_id in this.to :: {string} do
        const player = Players:GetPlayerByUserId(User.fromString(user_id) :: any)
        if (player) then
            table.insert(players, player)
        else
            project.console_output "unexpected value for NetPack.class :get_players() from NetPack.class .to"
            continue
        end
    end

    return players
end

function class:is_me_sender (): boolean
    const this = self :: class
    
    if RunService:IsServer() then
        return this.sender == nil and this.from == NetSource.FromServer
    else
        return this.sender == (Players.LocalPlayer and Players.LocalPlayer.User:ToString()) and this.from ~= NetSource.FromServer
    end
end

return table.freeze(class)
