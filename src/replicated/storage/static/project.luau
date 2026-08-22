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
end

do --properties
	project.proto = true

	project.retry = 5
	project.retry_time = 1
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
		error("prev")
	else
		warn("error ", debug.traceback())
	end
end

function project.run (f: ((...any) -> any)|thread|unknown, ...)
	const T = type(f)

	if T == "function" then
		(f :: (...any) -> ())(...)
		return 3
	elseif T == "thread" then
		if project.use_immediately_notifications_emitter then
			coroutine.resume(f :: thread, ...)
			return 2
		elseif project.use_scheduler then
			if project.use_deffered_emitter then
				task.defer(f :: thread, ...)
			else
				task.spawn(f :: thread, ...)
			end

			return 1
		end
	end
	
	return 0
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