--!nolint
const declare = require("@game/ReplicatedStorage/static/declare")
const project = {}

warn = warn or print

do --data
	--[=[
    	Используется как ключ доступа в сервисах управления сервером

        Старые api могут иметь отличия от нового, поэтому перемещение меж серверами с 1 версии на другую пока недоступно
        В будущем я займусь этим вопросом, так как это выглядит *очень притягательно*
    ]=]
	project.version = "unreleased"

	--[=[
        Общий ключ, по которому совместимые версии могут соединяться друг с другом
    ]=]
	project.unique = "Aftersky-chan" :: string

	--[[
        Дескриптор, сообщающий о возможной параллельности внутри этого контекта
        выполнения. Проще говоря, если это свойство имеет состояние `true`, то
        значит можно вызывать параллельные методы типа `ConnectParallel` или
        `task.synchronize()`, `task.desynchronize()`

        Поскольку `require()` всегда доступен только в синхронном контексте, это
        значит что никакой поток не потеряется, то есть его текущий контекст не
        изменится, поэтому эта информация полностью безопасна
    ]]
	project.parallel = pcall(function(): ()
		if type(task) ~= declare.table then error "project.parallel unsupported env" return end
		if type(task.desynchronize) ~= declare["function"] then error "project.parallel unsupported env" return end
		if type(task.synchronize) ~= declare["function"] then error "project.parallel unsupported env" return end

		task.desynchronize()
		task.synchronize()
	end)
end

do -- debug
	project.debug = {}

	project.debug.state = true
	project.debug.show_created_objects = false
	project.debug.show_notifications_path = false
	project.debug.show_channel_send_actions = false
	project.debug.show_maids_releasing = false
	project.debug.show_channel_internal = false
	project.debug.show_pickup_internal = false
	project.debug.show_signal_internal = false
end

do -- object

	project.object = {}

	--[==[
		Объекты будут получать метаметод `__index` и будут ссылаться на родителя, даже
		если у них специально занулено требуемое поле

		Включает "Прототипное ООП" вместо обычного "ООП"
	]==]
	project.object.prototypes = false

	--[==[
		Объекты класса `struct` и его наследники будут создаваться всегда замороженными,
		вне зависимости от того что с ними было. Только `struct:host()` функции и переданый
		в `struct:new(arg)` `arg` будут способны менять эти объекты, прежде чем они зафиксируются
	]==]
	project.object.struct_freeze = true
end

do -- enums
	project.enums = {}

	--[==[
		Объекты `enumobject` будут замораживаться после создания и не смогут быть изменены позже

		С настройкой `project.enums.enumitem_freeze` пересоздаст `enumitem`, чтобы корректно установить его имя
	]==]
	project.enums.enumobject_freeze = true

	--[==[
		Объекты `enumitem` будут замораживаться после создания и не смогут быть изменены позже
	]==]
	project.enums.enumitem_freeze = false
end

do --game
	
end

type console_out_type = never

--[=[
	Выводит сообщение об ошибке в консоль

	В разработке появление таких сообщений недопустимо
]=]
function project.console_out_error(...: unknown): console_out_type
	if project.debug then
		warn("error ", debug.traceback(), ...)

		if not coroutine.isyieldable() then
			error "cannot close current coroutine, so we just trying to KILL IT"
		else
			coroutine.yield()
		end
	else
		warn("error ", debug.traceback())
	end

	return nil :: console_out_type
end

function project.assert <T> (var: T, out: string?, error: boolean?) : T
	if error then
		if not var then
			project.console_out_error(out or "project assert failure")
		end
	else
		if not var then
			project.console_out(out or "project soft-assert failure")
		end
	end

	return var
end

--[=[
	Выводит сообщение в консоль

	В разработке появление сообщений такого рода нежелательно, хотя и не критично
]=]
function project.console_out (...): console_out_type
	if project.debug then
		print(...)
	end

	return nil :: console_out_type
end

do
	if project.debug then
		_G.fg_debug = {}
	end
end

return project