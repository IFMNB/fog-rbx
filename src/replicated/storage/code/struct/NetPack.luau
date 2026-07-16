const Players = game:GetService("Players")
const Record = require("../Record")
const Wrapper = require("../class/wrapper/Wrapper")
const NetSource = require("../enums/NetSource")
const object = require("../object")
const namefield = require("../static/namefield")

const class = {__index = Record}
setmetatable(class, class)

export type class <T... = ...unknown> = object.generic<{
    payload: () -> T...
}, typeof(class)>

class.type = namefield.netpack
--[=[
    Указывает откуда произошел этот пакет. Используются `NetSource` енамы
]=]
class.from = NetSource.Unknown

--[=[
    Вместо возврата Player возвращается только PlayerId, а экземпляр можно получить
    в методе этого же класса
]=]
class.id = 0

--[=[
    Пришел ли пакет пустым изначально?
]=]
class.empty = true

function class.new (from: number?, id: number?, ...: unknown)
    const this = Record.new(class)
    const args = {...}
    
    this.payload = function ()
        return unpack(args)
    end
    this.empty = #this.payload > 0
    this.from = from
    this.id = id

    return this:immutable()
end

--[=[
    Полезная нагрузка, которая пришла с источника. Она никогда недоступна
    для изменения, это принципиальное правило класса
]=]
function class.payload() : ...unknown
	return nil
end

--[=[
    Возвращает player
]=]
function class:get_player () : Wrapper.generic<Player>?
    const this = self :: class

    if (this.from ~= NetSource.FromClient or this.from ~= NetSource.FromMe) then
        return
    end

    const player = Players:GetPlayerByUserId(this.id)

    if (player) then
        return Wrapper.new(player)
    else
        return nil
    end
end

return table.freeze(class)