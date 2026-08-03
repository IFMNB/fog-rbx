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
	project.api_interversion_key = "Aftersky-chan" :: string | "Aftersky-chan"

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
end

do --defaults
	--[=[
        Максимальная скорость ограничена 60Hz независимо от желаемого уровня
    ]=]
	project.default_processor_hertz = 1 / 30

	--[=[
        Ивенты все равно могут выполняться как захотят, это лишь стандартное поведение

    	*Возможно об этом будет указано там, где поведение отличается*
    ]=]
	project.default_behavior_is_deferred = false

	--[=[
        Шанс использования default близится к 0, но никогда ему не равен

        На самом деле это практически никогда не используется
    ]=]
	project.default_timer_time_to_wait = 1 :: number | DateTime

	--[=[
        `Timer.class` выполняет шаг каждую секунду, модификатор умножает шаг,
        который сам по себе равен единице
    ]=]
	project.default_timer_time_stepped_modificator = 1

	--[=[
        Стандартное поведение `Config.class`, при котором если значение было overrided,
        то новое обновление всей конфигурации будет касаться этого значения или нет,
        даже если это апдейт касается именно него
    ]=]
	project.default_config_update_override_value = false

	--[=[
        К серверам можно подключиться через синглтон `Browser.class` из этого сервера в другой?

        Это не свойство проекта, потому что сервер в ходе игрового процесса или
        по иным причинам может сам определять хочет ли он дополнительный поток
        игроков или нет
    ]=]
	project.default_browser_joining_from_inside = true

	--[=[
        К этому серверу можно подключиться через синглтон `Browser.class` из другого сервера в этот?

        Это не свойство проекта, потому что сервер в ходе игрового процесса или
        по иным причинам может сам определять хочет ли он дополнительный поток
        игроков или нет
    ]=]
	project.default_browser_joining_from_outside = false

	--[=[
        Ивентам можно выставить задержку на выполнение `Event.class :emit()`
    	Если значение будет отрицательным, то задержки не будет.
    ]=]
	project.default_event_time_before_emit = -1

	--[=[
    	Стандартное количество шагов повторения `Event.class :emit()` вызова

	    Мультиплицированное поле позволяет вызывать ивент столько, сколько
        потребуется
    ]=]
	project.default_event_steps = 1
end

do
	--[=[
		Применяются особые условия
	]=]
	project.develop = false
end

do --debug
	--[=[
        При `true` включается повышенная отладка: любая ошибка выводится как `error()`,
	    никаких `warn()` не позволяется к выполнению, любые потери данных недопустимы
    ]=]
	project.debug = game["Run Service"]:IsStudio() :: boolean

	--[=[
		Выводить ли сообщения в консоль?
	]=]
	project.debug_messages = (project.develop and "strict" or project.debug and "important" or "soft") :: "nope" | "strict" | "soft"|"important"

	--[=[
		Если включен, то хосты будут проверяться на удаление из списка
	]=]
	project.debug_object_hosts = (project.debug and true) :: boolean
end

do --properties
	--[=[
		Использовать в создании новых экземпляров механизм прототипирования?

		Принципиальная разница в том, что все экземпляры будут создаваться с метатаблицей,
		изначально ссылающейся на родителя этого экземпляра. И в том, и в другом случае
		экземпляр так или иначе копирует все поля родителя
	]=]
	project.prototype_oop = true

	--[=[
	    Выделенный объект при `true` придется освобождать вручную,
	    GarbageCollector больше не сможет его уничтожить из-за
        постоянной сильной ссылки в памяти

        Это может быть полезным поведением, поскольку в некоторых сценариях
        может быть необходимо избавиться от объекта только через некоторое время,
        заранее забыв о его существовании
    ]=]
	project.disposable_gc_collectable = false

	--[[
        Во время парсинга таблиц все обработанные значения после выполнения их подпарсинга
	    будут заменяться на `nil` прямо в таблице, а иначе не будут
	    
        Исключением являются `Disposable` и все его наследники, `Liberator.class` не может
	    удалять их поскольку их нахождение в таблице может использоваться кем-либо
	
        Поэтому весь парсинг идет bottom-up алгоритмом
    ]]
	project.liberator_can_delete_fields_in_table = true

	--[=[
        Освобождение объекта при `true` происходит немедленно, сигналы не смогут работать с ним,
	    иначе все вызовы `:free()` перенаправляются в `:queue_free()`
    ]=]
	project.disposable_free_behavior_is_deferred = true

	--[=[
        Все наблюдатели будут вызываться после физического освобождения `Disposable.class`,
	    иначе они будут вызываться до освобождения
	
        При `project.disposable_free_behavior_is_deferred == true` и значении этого свойства
	    в false, это поведение может быть желаемым и достаточно полезным
    ]=]
	project.disposable_watchers_call_after_destroying = false

	--[=[
        `Liberator.class` при обходе таблиц сможет вызывать хранимые в этой таблице функции

	    Это может быть нежелательным поведением, но я писал код с расчетом на то, что
	    метаданные объектов никогда не содержат функций
    ]=]
	project.liberator_allow_call_functions = false

	--[=[
        (!!!) Весь код написан под сильные соединения, отключение поля может вызывать баги
        
        Если `false`, то соединения без сохранения их `Connection.class` будут уничтожены
        
        Поле конфликтует с `project.disposable_gc_collectable`, потому что object сохраняет
        все в сильную таблицу, а event тоже сохраняет Connection.class и управляет им
    ]=]
	project.face_strong_connections = true

	--[=[ 
        Если `project.default_behavior_is_deferred == true`, то `Event.class` будет использовать
        `RunService.Heartbeat` сигнал при вызове коррутин для `Connection.class`, иначе `task.defer()`
    ]=]
	project.use_signal = true

	--[=[
        Если `true`, то `Event.class` будет запускать `emitter()` через `coroutine` библиотеку,
        иначе через `task.spawn()`

        Подробности читать в `project.event_use_task_spawn`
    ]=]
	project.use_immediately_emitter = false

	--[=[
		Все события информирования будут отложены на следующий кадр.
	]=]
	project.use_deffered_emitter = true

	--[=[
        Вызов всех соединений происходит при помощи `task.spawn()`, вместо `coroutine.resume(coroutine.create(F))`
        
        Поведение у ивентов при этом методе __отличается__:
        
        Коррутины поднятые через `task.spawn()` запускаются в реальной асинхронности (не параллельности),
        то есть работают после текущей коррутины отдельно, не завися от stack той коррутины, где был
        вызван `Event.class:emit():` это может произойти и через N количество других коррутин, но
        всегда будет в этом текущем кадре.
        
        Коррутины поднятые через `coroutine.resume(coroutine.create(F))` не являются реально асинхронными,
        они принадлежат коррутине `Event.class:emit()` и выполняются как обычные функции, только имея
        свой собственный stack: вызов происходит мгновенно и выполняются сразу же все `Connection.class`
    ]=]
	project.use_scheduler = true

	--[=[
        У `Timer.class `есть методы `:get_wait_time()` и `:get_service_wait_time()`
        
        Это нужно для того чтобы таймеры для системных операций (типа ожидания Server)
        не подвисали вместе с игровым временем у `World time_scale`
    ]=]
	project.timer_wait_behavior_is_swapped = false

	--[=[
        Синглтон `Browser.class` запускает все операции для работы с другими серверами
        только при старте и никогда после
        
        Если это свойство `false`, то к серверу даже нельзя будет подключиться откуда-либо телепортом
    ]=]
	project.browser_online = true

	--[=[
        Сохранять информацию игроков в `DataStoreService`? 
    ]=]
	project.data_save = false and not project.debug

	--[=[
        Использовать информацию игроков из `DataStoreService`? 
    ]=]
	project.data_use_saved = false

	--[=[
        TODO
        
        Рекомендуется к включению при `project.disposable_gc_collectable == true`
        `Storage.class` подключает к каждому новому `private.metadata[Storage.class].StorageMode_table[object.class]`
        свою watcher функцию которая автоматически подчищает этот объект из данных `Storage.class`
       
        Поведение по умолчанию отличается только тем, что `Storage.class` доверяет все или самому объекту при моде
        `StorageMode.Strong` или `enum.Unknown`, либо отдает все на попечение GarbageCollector
    ]=]
	project.storage_watching_objects_free_event = false

	--[=[
	    Рекомендуется к включению при `project.disposable_gc_collectable == true`
	
        При состоянии этого свойства `true` все `private.metadata[Storage.class].StorageMode_table[object.class]`
	    будут иметь внутри себя метатаблицу с __index, который будет проверять объект по схеме:
	
        1. Это новый объект?
            Да: добавить watcher на удаление, чтобы уничтожить этот объект из метаданных
        2. Есть ли watcher на free ивент?
            Нет: добавить
    ]=]
	project.storage_watching_objects_free_event_inside_mode_table = false

	--[=[
        Если `true`, то из браузера будет запрещено подключаться к серверам, находящимся в состоянии
        `ServerState.PendingShutdown`.

        `ServerState.PendingShutdown` и так переводит Matchmaking атрибут сервера в высокую стоимость.
        Настройка влияет на возможность из браузера подключиться к другому серверу с таким атрибутом.
    ]=]
	project.browser_allow_joining_to_pending_shutdown = false

	--[=[
        Если `true`, то будет использоваться `project.api_interversion_key` как ключ к общему пулу серверов
        для поиска между разными версиями

        API между разными версиями серверов может отличаться до неузнаваемости.
        Включать только если есть уверенность, что API не изменится долгое время
    ]=]
	project.interversion_searching = false

	--[=[
        Если `true`, то при shutdown сначала сохранится вся информация обо всех текущих игроках,
        и только затем будут кикнуты все, иначе наоборот

        Информация о новых игроках (те кто зашли во время shutdown) не будет сохранена,
        как и информация после начала процесса
    ]=]
	project.shutdown_kicks_players_deferred = false

	--[=[
        Если `true`, то вместо стандартного Animator (скрипт Roblox с изменениями для работы в плейсе)
        будет использоваться сервис `Anime.class`
    ]=]
	project.anime_service = false

	--[=[
        Если `true`, то репликация будет отдана в работу библиотеке Chrono насколько это возможно.
        Возможно может быть добавлена поддержка RobloxServerSimulation*
    ]=]
	project.chrono = false
end

do --game
	--[=[
        Если `true`, то сервер будет сохранять статистику S/D (Spawns/Deaths) и предоставлять ее
        клиентам при запросе для конкретного класса.
    ]=]
	project.data_save_classinfo = false

	--[=[
        Если `true`, то сервер будет сохранять статистику K/D/AA (AverageAccuracy) и предоставлять
        ее клиентам при запросе для конкретного оружия
    ]=]
	project.data_save_weaponinfo = false

	--[=[
        Если `true`, то сервер будет сохранять статистику K/D/AA (AverageAccuracy) и предоставлять
        ее клиентам при запросе
    ]=]
	project.data_save_statsinfo = false

	--[=[
        Если `true`, то сервер будет сохранять статистику SR/F/U/AU
        (Success Rate/Failure/Used/AverageUsage) и при запросе предоставлять ее клиентам
        на конкретную способность
    ]=]
	project.data_save_abilityinfo = false

	--[=[
        Если `true`, то позволяет сохранять лоадауты классов (их экипировку/оружие) и автоматически
        подгружать его для каждого клиента

        В состоянии этого свойства `false` будет использоваться стандартный лоадаут класса
    ]=]
	project.data_save_loadout_for_class = false

	--[=[
        Если `true`, то позволяет сохранять выбранные способности классов и автоматически подгружать
        их для каждого клиента

        В состоянии этого свойства `false` будет использоваться стандартный пул способностей класса
    ]=]
	project.data_save_abilities_for_class = false

	--[=[
        Если `true`, то сервер будет разрешать добавлять в список возможных способностей для
        конкретного класса вообще все способности, что у него есть, а не только те, что созданы
        для конкретного класса
    ]=]
	project.allow_global_abilities = false

	--[=[
        Если `true`, то сервер будет разрешать изменять способности класса и будет предоставлять
        лист возможных способностей для конкретного класса
    ]=]
	project.allow_changing_class_abilities = false

	--[=[
        Если `true`, то сервер будет разрешать изменять оружие на классы, иначе все классы будут
        иметь фиксированное оружие, даже если это было переопределено в сохраненной data клиента
        (это будет проигнорировано)

        При состоянии этого свойства `true` и `project.data_save_loadout_for_class == true`
        лоадауты классов не будут перезаписываться
    ]=]
	project.allow_changing_weapons = false

	--[=[
        Если `true`, то сервер будет разрешать выкидывать любое оружие клиента
    ]=]
	project.allow_drop_weapons = false

	--[=[
        Если `true`, то сервер будет разрешать Reset персонажа клиента, если он есть
    ]=]
	project.allow_suicide = false

	--[=[
        Если `true`, то при отсутствии анимации будет проигрываться tpose анимация

        Поведение при `project.debug == true` будет соответствовать как "Отсутствие данных",
        а значит такие анимации будут вызывать `error()`
    ]=]
	project.set_tpose_when_no_animation = false

	--[=[
        Если `true` и это допустимо, вместо IKControl анимаций будут использоваться обычные анимации.
        
        При состоянии этого свойства `true` обычные анимации все равно будут использоваться
    ]=]
	project.allow_ikcontrol = false
end

type console_out_type = never

--[=[
	Выводит сообщение об ошибке в консоль

	В разработке появление таких сообщений недопустимо
]=]
function project.console_out_error(write: unknown, ...: unknown): console_out_type
	if project.debug_messages == "nope" then
		return
	end

	write = write ~= nil and write or "*unknown error message*"
	if project.debug_messages == "strict" then
		local line: string = ""

		for i, v in { ... } do
			line = line .. " " .. tostring(v)
		end

		error(tostring(write) .. " " .. line)
	elseif project.debug_messages == "important" then
		warn(string.format("%s\n", debug.traceback()), write, ...)
	elseif project.debug_messages == "soft" then
		print(string.format("%s\n", debug.traceback()), write, ...)
	else
		return
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
		elseif project.use_signal then
			return 4
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

function project.exec (f: ((...any) -> any)|thread|unknown, ...)
		const T = type(f)

	if T == "function" or T == "thread" then
		if project.use_immediately_notifications_emitter then
			coroutine.resume(f :: thread, ...)
		elseif project.use_scheduler then
			if project.use_deffered_emitter then
				task.defer(f :: thread, ...)
			else
				task.spawn(f :: thread, ...)
			end
		else
			task.delay(0, f, ...)
		end

		return true
	end
	
	return false
end


--[=[
	Выводит сообщение в консоль

	В разработке появление сообщений такого рода нежелательно, хотя и не критично
]=]
function project.console_out (write, ...): console_out_type
	if project.debug_messages == "nope" then
		return
	end

	write = write ~= nil and write or "*unknown message*"
	if project.debug_messages == "strict" then
		return warn(string.format("%s\n%s", write, debug.traceback()), ...)
	elseif project.debug_messages == "important" then
		return warn(write, ...)
	else
		return print(string.format("%s\n%s", write, debug.traceback()), ...)
	end
end

--[=[
	Обертка над pcall с реализацией авто-сообщения в консоль при неудаче
]=]
function project.mcall <T...,U...> (f: (T...)->U..., ...: T...) : (boolean, U...)
	const state, out = pcall(f, ...)
	project.out_if(not state, out, ...)
	return state, out
end

--[=[
	Является ли игра тестовым запуском в режиме `server & clients`
]=]
function project.is_test_sc () : boolean	
	for _, v in game:GetService("Players"):GetPlayers() do
		return v.UserId < 0
	end

	return false
end

--[=[
	Универсальный typecheck агрегатор между разными экземплярами.
	
	Проверяет, является ли переданная `table`, `class` и `userdata` видом `object`, `class`
	или `Instance` определенного типа, который указывает аргумент `is`. Если это не объект систем,
	то возвращает совпадение по `typeof()` с `is` 
]=]
function project.this(who: unknown, is: string): boolean
	const T = typeof(who)
	const simple_T = type(who)
	if (T == is) then
		return true
	else
		if (simple_T == "table") then
			if (type(who.is) == "function") then
				return who.is(who, is)
			else
				if (who.type) then
					return who.type == is
				end
			end
		elseif (simple_T == "class") then
			project.console_out_error "class api (from real Luau classes) isn't supported now"
		elseif (simple_T == "userdata") then
			if (T == "Instance") then
				return who:IsA(is) or who.ClassName == is
			end
		end
	end

	return false
end

--[=[
	LEGACY

	По сути выполняет if-elseif-else работу с учетом безопасного контекста

	Не очень подходит для разных вариантов действий, порой проще составить логику вручную, 
	чем делигировать этой функции. Хотя функция и помечена как deprecated, таковой по работе
	кода не является
]=]
@[deprecated {
	reason = "Не очень выразительный api",
	use = "Расписывайте логику проверок вручную"
}]
function project.try(
	that: unknown | () -> ...any,
	do_then: (...any) -> any,
	do_else: ((...any) -> any)?,
	finally: ((...any) -> any)?,
	...: any?
)
	const T = type(that)
	local result: unknown

	if T == "function" then
		const state, out = pcall(that, ...)
		const T_out = type(out)
		if T_out == "table" then
			result = project.try(state, do_then, do_else, finally, table.maxn(out) == 0 and out or table.unpack(out))
		else
			result = project.try(state, do_then, do_else, finally, out)
		end
	elseif T ~= "nil" then
		result = do_then(...)
	else
		if do_else then
			result = do_else(...)
		end
	end

	if finally then
		const endpoint = finally(result)
		result = endpoint ~= nil and endpoint or result
	end

	return result
end

return project