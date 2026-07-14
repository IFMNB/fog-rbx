const object = require "@game/ReplicatedStorage/code/object"
const project = require("../../static/project")
const Disposable = require("../../Disposable")
const namefield = require('@game/ReplicatedStorage/code/static/namefield')
const connection_state = require('../../enums/ConnectionState')

const class = {__index = Disposable}
setmetatable(class,class)

export type class = object.class<typeof(class)>


--[=[
	`Connection` - это класс, представляющий соединение (соглашение)
	между событием (`Event.class`) и наблюдателем этого события, то 
	есть внешним кодом

	`Connection.class` в зависимости от предоставляемых методов `Event.class`
	имеет разную семантику и применение
]=]
class.type = namefield.connection

--[=[
	Описывает текущее состояние этого `Connection.class` объекта
]=]
class.state = connection_state.Dead

--[=[
    `Connection.class` будет активирован только если `Event.class`
    будет проходиться специальным циклом с проверкой `enum` этого
    объекта и только если совпадение будет ожидаемым
]=]
class.expected = connection_state.Unknown

--[=[
	Возвращает стандартный объект `Connection.class`, который нужно
	будет отредактировать в силу того, что его стандартные методы
	не предоставляют api для функционирования с конкретным событием
]=]
function class.new ()
	return class.arch_new(class, true)
end

--[=[
	Согласно стандартному поведению любого `Event.class`, обязывает
	отключить этот `Connection.class`, то есть разорвать подписку
	внешнего наблюдателя на это конкретное событие
]=]
function class:disconnect ()
	return project.console_output "Connection.class @disconnect does not overrided"
end

return table.freeze(class)