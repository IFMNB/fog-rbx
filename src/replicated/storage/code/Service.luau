const object = require("@game/ReplicatedStorage/code/object")
const namefield = require("@game/ReplicatedStorage/code/static/namefield")

const class = {__index = object}
setmetatable(class, class)

class.type = namefield.service
class.new = error
class.arch_new = class.new

-- TODO
-- Проверка на Hearbeat: осмотр единой SharedTable сигналов из разных Actor
-- Это когда сотни нпс кидают запросы под определенные енамы серверов
-- с задачей выполнить то или иное зарегистрированное действие
-- Причем неважно где сервис активирован (он может быть активен только в 1 потоке
-- и никогда более, это принципиальное требование), запрос из любого места и потока
-- должен быть обработан
--
-- Результат возвращать не требуется



table.freeze(class)
return class