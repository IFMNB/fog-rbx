--!strict

const EnumObject = require("../class/arch/EnumObject")
const EnumItem = require("../class/arch/EnumItem")
const declare = require("../static/declare")

const class = EnumObject:new({
	name = "AgentEventType",

    --[=[
        Агент получает одноразовый сигнал, который предлагает
        ему запустить выполнение той или иной задачи

        Это сигнал к действию
    ]=]
    Send = EnumItem:new({
        name = "Send"
    }),

    --[=[
        Агент получает событие, которое обязывает его запустить
        выполнение того или иного действия
    ]=]
    Order = EnumItem:new({
        name = "Order"
    })
})

return class
