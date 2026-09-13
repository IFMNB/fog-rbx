--!nolint
const project = {}

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
	project.parallel = pcall(function(...)
		task.desynchronize()
		task.synchronize()
	end)

	project.debug = game["Run Service"]:IsStudio() :: boolean
	project.debug_show_created_objects = false
	project.debug_show_notifications_path = false
	project.debug_show_channel_send_actions = false
	project.debug_show_maids_releasing = false
	project.debug_show_channel_internal = false
	project.debug_show_pickup_internal = false
	project.debug_show_signal_internal = false
end

do --properties
	project.proto = true

	project.retry = 5
	project.retry_time = 1
	project.timeout = 30

	project.enumobject_freeze_related_items = true
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
end

return project