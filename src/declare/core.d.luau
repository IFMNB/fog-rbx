--!strict

--- CORE

export type construct<T = unknown, U = unknown> = T & U

type mt__vs = { read __mode: "vs"}
type mt__ks = { read __mode: "ks"}
type mt__kvs = { read __mode: "kvs" }

type object_identity = unknown | string
type object_type = string

--[==[
    Base object interface for the runtime object system

    Object provides runtime type information, object identity, construction, inheritance inspection, type assertions,
    and access to the object's host context

    Types derived from object inherit these operations
]==]
export type object = {
	read type: object_type,

	read new: <T, U>(self: T, that: U?) -> construct<T, U>,
	read it: (self: object, otype: object_type) -> boolean,
	read is: (self: object, otype: object_type) -> boolean,
    read as: <T>(self: object, otype: object_type) -> object & T,
    read eq: (self: object, to: object) -> boolean,
    read base: <T>(self: object, expected: string | nil) -> (object & T)?,
	read host: <T>(self: object, f: (new: T) -> ()) -> (),
    read that: <T>(self: object, that: unknown, otype: object_type) -> (object & T)?,
    read iden: (self: object) -> object_identity,

    --[string]: unknown?
}

--[==[
   Represents an enumeration and contains its EnumItem values

    An EnumObject defines a named set of related enumeration items
    It provides access to individual EnumItem values and can be used wherever an enumeration as a whole is required

    Each EnumItem exposed by an EnumObject belongs to that enumeration
    EnumObject therefore acts as both the namespace and the owner of its enumeration values.

    Typical usage:
    
    ```luau
    local value = ExampleEnumObject.SomeValue
    local items = ExampleEnumObject:get_enums_list()
    ```
]==]
export type enumobject = construct<{
	read name: string,

	read get_enums_list: (self: enumobject) -> { [unknown]: enumitem },
	read get_enums_count: (self: enumobject) -> number,
	read get_enums_name: (self: enumobject, ...enumitem) -> ...string?,
    read get_hashlink_list: (self: enumobject) -> { string },

    read get_enum_by_name: (self: enumobject, name: string) -> enumitem?,
    read get_enum_by_hashlink: (self: enumobject, hashlink: string) -> enumitem?,

	read is_my_enumitem: (self: enumobject, that: enumitem|string) -> boolean,
}, object>

--[==[
    Represents a single named value belonging to an EnumObject.

    An EnumItem is an immutable enumeration value identified by its parent enumeration and item name. It can be used as a stable descriptor in comparisons, dispatch, subscriptions, and other APIs that operate on enumeration values.

    EnumItem does not represent an arbitrary runtime value. Each item belongs to an EnumObject and is uniquely identified within that enumeration.

    Typical usage:

    ```luau

    local function foo(item: enumitem)
        if item == ExampleEnumObject.SomeValue then
            -- ...
        end

        if item.hashlink == ExampleEnumObject.SomeValue2.hashlink then
            -- ...
        end
    end

    ```
]==]
export type enumitem<T = enumobject?> = construct<{
	read name: string,
	read hashlink: string,
	read enum: T,
}, object>

--[==[
    Base structural type

    A struct provides common operations for working with structured runtime objects
    It can be copied while preserving the concrete object type and can iterate over values of a specified field type

    Every struct-type object is unchangeable and freezed, create a new structure if you need to change something
]==]
export type struct = construct<{
	read clone: <T>(self: T, change: unknown?) -> T,
	read each: <T>(self: struct, type: string, f: (value: T) -> T) -> {[unknown]: T},
}, object>

--[==[
    Represents a typed runtime variable containing a value and the time at which the variable was created
    
    Variable is generic over the stored value type T
]==]
export type variable<T = unknown> = construct<{
	read creation_time: number,
    read get_value: (self: variable<T>) -> T,
    read set_value: (self: variable<T>, to: T) -> (),
    read history: (self: variable<T>) -> {[number]: T}
}, object>

--[==[
    Represents a reference to a value of type T

    A pointer may point to an existing value or represent an unresolved reference
    It supports reading the pointed value, changing the target, and 
    inspecting whether the target currently exists or is held as a hard reference
]==]
export type pointer<T = unknown> = construct<{
	read get_pointed: (self: pointer<T>) -> T,
	read set_point: (self: pointer<T>, to: T, hard: boolean?) -> (),
	read is_pointed_hard: (self: pointer<T>) -> boolean,
	read is_pointed_exists: (self: pointer<T>) -> boolean,
}, object>

--[==[
    Represents a typed path to an object

    A path stores a textual representation of a target and can resolve that path back to an object of type T
]==]
export type path<T = object> = construct<{
	read set_path: (self: path<T>, to: T) -> (),
	read get_path: (self: path<T>) -> string,
	read get_object: (self: path<T>) -> T?,
}, object>

--[==[
    Represents a typed notification observer that manages subscriptions to enumitem and enumobject notifications

    T specifies the notification source type accepted by the observer. By default, T is enumitem | enumobject
    An observer manages subscriptions through pointer objects
    Each subscription may have its own connection mode and additional parameters
]==]
export type observer<T = enumitem | enumobject> = construct<
	{
		deffered_call: boolean,
		deffered_mode: boolean,
		allow_new_connections: boolean,

		read subscribe: (
			self: observer<T>,
			on: observer_on<T>,
			mode: enumitem_connection_variant,
			...observer_var<T>
		) -> ...pointer,
		read unsubscribe: (self: observer<T>, ...pointer) -> (),
		read subscription_set_mode: (self: observer<T>, to: enumitem_connection_variant, ...pointer) -> (),
		read subscription_get_mode: (self: observer<T>, ...pointer) -> ...enumitem_connection_variant,
		read notificate: (self: observer<T>, notification: observer_on<T>, ...unknown) -> (),

        --[==[
            Получить из внутреннего приватного хранилища объекта какое-либо значение по `label`
        ]==]
		read get: <Y>(self: observer<T>, label: any) -> Y,

        --[==[
            Установить во внутреннее приватное хранилище объекта какое-либо значение по `label`
        ]==]
		read set: <Y>(self: observer<T>, label: any, to: Y) -> (),
	},
	object
>

type observer_on <T = enumitem> = T | {T} | enumobject | {enumobject} | {T|enumobject}
type observer_var <T = unknown> = ((...any)->())|thread|observer<T>

--[==[
    Represents an object that performs a single role in the system as a singleton
]==]
export type service = construct<{
    
} & nameable & switchable, object>

--[==[
    Represents an object with an explicit resource-release lifecycle

    A disposable provides a free operation that releases resources owned by the object
    The operation may be performed immediately or deferred
]==]
export type disposable = construct<{
    --[==[
    Releases the resources associated with the disposable object.

    deffered determines whether the release is deferred. When omitted, the implementation uses its default behavior.

    ```luau
    value:free() -- GC will be able to collect this value later
    value:free(true) -- The GC will be able to collect this value at the end of the loop
    ```
    ]==]
    read free: (self: disposable, deffered: boolean?) -> (),

    --[==[
        Returns the state of the object at the current time of the request
    ]==]
    read released: (self: disposable) -> boolean,

    --[==[
        Connects an outside observer to the moment of release
    ]==]
    read watch: <T> (self: disposable, ...(self: disposable) -> ()) -> ()
}, object>






















-- Common

export type event<T = enumitem, U... = ...unknown> = construct<{
    read connect: <T0> (self: event<T,U...>, on: T, f: ((U...) -> ())|thread|observer<T>) -> connection<T,U...>,
    read once: <T0> (self: event<T,U...>, on: T, f: ((U...) -> ())|thread|observer<T>) -> connection<T,U...>,
    read wait: (self: event<T,U...>, on: T) -> U...,
    read invoke: (self: event<T,U...>, on: T, U...) -> (),
} & expected_calltype<T?>, observer<T>> 

export type connection<T = enumitem, U... = ()> = construct<{
    count: number,

    read get_mode: (self: connection<T, U...>) -> enumitem_connection_variant,
    read set_mode: (self: connection<T, U...>, mode: enumitem_connection_variant) -> (),
    
    read is_connected: (self: connection<T,U...>) -> boolean,
    read disconnect: (self: connection<T,U...>) -> (),
} & invokeable<connection<T,U...>,U...> & expected_calltype<T?>,
observer<enumitem_setup_notification>>

export type value<T = unknown> = construct<{
    read get_value: (self: value<T>) -> T?,                    
    read set_value: (self: value<T>, new: T?, default: boolean?) -> (),
}, observer<enumitem_operation_variant>>

export type timer = construct<{
    read get_elapsed: (self: timer) -> number,
    read get_remaining: (self: timer) -> number,
    read get_duration: (self: timer) -> number,
    read get_step: (self: timer) -> number,

    read set_duration: (self: timer, to: number) -> (),
    read set_step: (self: timer, to: number) -> (),

    read is_running: (self: timer) -> boolean,
    read is_finished: (self: timer) -> boolean,
}  & iterations<number> & modifier<number> & controllable<timer>, observer<enumitem_tick_notification>>

--[==[
    Объект, представляющий динамический доступ к требуемому объекту

    Он не гарантирует наличие объекта, безопасность подключения к его сигналам или всего
    остального. Он контроллируется внешними управляющими механизмами
]==]
export type reference<T = Instance> = construct<{
    read clear: (self: reference<T>) -> ()
} & instanceable<reference<T>, T>, observer<enumitem_reference_notification>>

export type signal<T... = ...unknown> = construct<{
    read get_signal_event: (self: signal<T...>) -> event<enumitem_tick_notification, T...>
}, reference<RBXScriptSignal<T...>>>

export type controller = construct<{
    state: enumitem_controller_state
} & operatable<controller>, observer<enumitem_controller_state>>

export type stack<T = unknown> = construct<{
	max: number,

	read pick: (self: stack<T>) -> T?,
	read put: (self: stack<T>, value: T) -> (),
	read count: (self: stack<T>) -> number,
}, object>

export type maid = construct< {
	read add_object: (self: maid, that: any, strong: boolean?) -> (),
	read add_key: <T>(self: maid, of: { [T]: unknown }, key: T) -> (),
	read remove_object: (self: maid, that: any) -> (),
	read remove_key: <T>(self: maid, of: { [T]: unknown }, key: T) -> (),
	read is_supported: (self: maid, that: unknown) -> boolean,
}, disposable>

--[==[
    Объект, представляющий ленивое хранилище
]==]
export type maybe <T = unknown, U = unknown> = construct<{

    --[==[
        Выполяет переданную функцию только 1 раз, далее возвращает кэшированный
        результат работы функции
    ]==]
	read extract: (self: maybe<T,U>, it: U, make: () -> T) -> T,

    --[==[
        Создает наследника переданного объекта, а затем возвращает его как кэшированный
        результат работы
    ]==]
    read enactment: (self: maybe<T,U>, it: U, of: object) -> T,

    --[==[
        Для указанного `it` удаляет значение
    ]==]
    read erase: (self: maybe<T,U>, it: U) -> (),
	
    --[==[
        Проверяет, существует ли значение для указанного `it`
    ]==]
    read exist: (self: maybe<T,U>, it: U) -> boolean,
}, observer<enumitem_operation_variant>>

export type statemachine <T = enumitem> = construct<{
    read get_state: (self: statemachine<T>, ...T) -> boolean,
    read set_state: (self: statemachine<T>, to: boolean?, ...T) -> (),
    
    read blacklist: (self: statemachine<T>, ...T) -> (),
}, observer<enumitem_statemachine_notification>>



























-- Component


export type profile<T = enumitem> = construct<{
    read uid: number,

    read get_inlined: (self: profile<T>, uid: number) -> profile<T>, 
    read get_player: (self: profile<T>) -> Player?,
    read get_reference: (self: profile<T>) -> reference<Player>,
    read get_configurated: <Y> (self: profile<T>, of: enumitem) -> variable<Y>,
    read get_joined_at: (self: profile<T>) -> DateTime,
    read get_last_seen_at: (self: profile<T>) -> DateTime?,
    read get_last_server_id: (self: profile<T>) -> string?,
    read get_permissions: (self: profile<T>) -> {enumitem},
    read get_restrictions: (self: profile<T>) -> {enumitem},

    read set_configurated: <Y> (self: profile<T>, of: enumitem, ...unknown) -> (),
    read set_permissions: (self: profile<T>, to: boolean, ...enumitem) -> (),
    read set_restrictions: (self: profile<T>, to: boolean, ...enumitem) -> (),
    read set_platform: (self: profile<T>, to: boolean, ...enumitem_user_machine_variant) -> (),

    read has_platform: (self: profile<T>, ...enumitem_user_machine_variant) -> boolean,
    read has_restricitions: (self: profile<T>, ...enumitem) -> ...boolean,
    read has_permissions: (self: profile<T>, ...enumitem) -> ...boolean,

    read is_banned: (self: profile<T>) -> boolean,
    read is_kicked: (self: profile<T>) -> boolean,
    read is_out: (self: profile<T>) -> boolean,
    read is_in_place: (self: profile<T>) -> boolean,
    read is_in_server: (self: profile<T>) -> boolean,
}, observer<enumitem_user_notification>>

export type localuser = construct<{
    read uid: number,
    read get_player: (self: localuser) -> Player,

    read require_get_configuration: (self: localuser, of: enumitem) -> result,
    read require_save_configuration: (self: localuser, of: enumitem, ...unknown) -> (),

    read get_user: (self: localuser) -> profile,
}, object>




















--[==[
    Объект, представляющий геометрическое пространство

    В обычном случае такие объекты представляются синглтон-пространствами
    внутри самого физического движка и не представляет собой какие-либо
    объекты. В контексте конкретно этой архитектуры он полезен именно
    как реестр для `geovolume` структур


]==]
export type world = construct<{
    --[==[
        Выполняет операцию рейкаста в мире
    ]==]
    read raycast: (self: world, from: vector, to: vector, info: rayinfo?) -> ...unknown,

    --[==[
        Проверяет, какие другие возможные `volume` могут иметь коллизии с этим
        конкретным объектом
    ]==]
    read volumecast: (self: world, at: unknown) -> ...unknown,

    read insert_volume: (self: world, ...unknown) -> (),
    read remove_volume: (self: world, ...unknown) -> (),
    
    read get_grid: (self: world) -> {[number]: {[number]: {[number]: geometry_check}}},
    read get_grid_size: (self: world) -> number,
    read set_grid_size: (self: world, to: number) -> (),
} & collidable<world>, observer>

--[==[
    Объект, представляющий набор информации для геометрических фигур
]==]
export type rayinfo = construct<{
    --[==[
        Первый попавшийся объект будет возвращен, и только он
    ]==]
    read only_one_output: boolean,
    
    --[==[
        Рейкаст будет создаваться не только в локальном пространстве, но и в
        пространстве игры, в которой работает
    ]==]
    read engine_hit: boolean,

    --[==[
        Попадание будет создавать `world:volumecast()` для всех, в кого
        оно было зарегистрировано. Если `self.only_one_output`, то это
        свойство его игнорирует, - будут возвращены все кто попал в `world:volemucast()`
    ]==]
    read volume_hit: boolean,
    
}, struct>



















-- Game

type collidable_instance = Model|BasePart
type collidable_ref = reference<collidable>

--[==[
    Объект, представляющий группу коллизий
]==]
export type collision = construct<{
    read get_collision: (self: collision) -> ...reference<Instance>,
    read set_collision: (self: collision, ...collidable_ref|collidable_instance) -> (),
    read rem_collision: (self: collision, ...collidable_ref|collidable_instance) -> (),
    read set_name: (self: collision, to: string) -> (),
    read get_name: (self: collision) -> string,
}, disposable>


--[==[
    Объект, представляющий доменную логику раунда и дающий возможность структурно управлять игрой
]==]
export type round = construct<{
    --[==[
        Возвращает специальную фракцию текущих персонажей в игре,
        она должна исчезнуть вместе с пропажей этого экземпляра
        объекта `round`
    ]==]
    read get_members: (self: round) -> faction,

    --[==[
        Возвращает настоящие зарегистрированные в раунде фракции
    ]==]
    read get_faction: (self: round) -> ...faction,

    --[==[
        Добавляет указанную фракцию в раунд, если ее не было
    ]==]
    read add_faction: (self: round, ...faction) -> (),

    --[==[
        Удаляет указанную фракцию из раунда, если она была в нем
    ]==]
    read rem_faction: (self: round, ...faction) -> (),

    --[==[
        Проверяет, есть ли данная фракция в этом раунде или нет
    ]==]
    read has_faction: (self: round, ...faction) -> boolean,

    --[==[
        Для всех указанных участников возвращаются те фракции, в которых они
        состоят в этом раунде

        Не возвращается фракция members, это техническая фракция
    ]==]
    read find_member: (self: round, ...character) -> {[character]: {faction}?}
} & stateable<round, enumitem_round_state>, timer>

--[==[
    Объект, хранящий в себе список персонажей, которые к этой
    фракции принадлежат на данный момент

    Фракция представляет собой не сколько фракцию, сколько аналог
    объекта `Team`, перенесенного в логику

    Используются объекты `character` как участники, поскольку доменная
    сущность которая управляет `character` независима от них и наоборот:
    `character` может существовать и сам по себе, его не интересует
    кто им управляет и управляет ли
]==]
export type faction = construct<{
    --[==[
        Возвращает всех участников персонажей для этой фракции

        Узнать какой персонаж к какому игроку или машине принадлежит
        можно через сервисы, фракция не занимается этим
    ]==]
    read get_member: (self: faction) -> ...character,

    --[==[
        Добавить нового участника в фракцию, если его нет
    ]==]
    read add_member: (self: faction, ...character) -> (),

    --[==[
        Удалить участника из фракции, если он в ней был
    ]==]
    read rem_member: (self: faction, ...character) -> (),

    --[==[
        Проверить является ли персонаж участником этой фракции
    ]==]
    read is_member: (self: faction, ...character) -> ...boolean
} & nameable, observer<enumitem_faction_notification>>

--[==[
    Объект, представляющий собой логическую сущность "персонаж"

    У этого объекта нет ответа на вопрос как именно этот персонаж работает,
    он отвечает прежде всего на вопрос: "что сейчас делает игра с персонажем"

    Поскольку он не является фактическим состоянием персонажа, его связанность
    с рантаймом почти нулевая и завязана в основе исключительно на том как
    система интерпретирует эту логическую сущность

    Дальнейшие операции и работа с ними производится исключительно
]==]
export type character = construct<{
    --[==[
        Получить текущий токен персонажа

        Токен - специальный ключ, по которому для этого персонажа могут быть
        подобраны подходящие ему предметы, способности, снаряжение или
        модели

        Это используется в сервисах, которым необходимо выдавать релевантные
        данные к этому объекту, при этом не давая ему право обладать этими
        данными
    ]==]
    read get_token: (self: character) -> enumitem,

    --[==[
        Установить новый токен персонажа

        Токен - специальный ключ, по которому для этого персонажа могут быть
        подобраны подходящие ему предметы, способности, снаряжение или
        модели

        Это используется в сервисах, которым необходимо выдавать релевантные
        данные к этому объекту, при этом не давая ему право обладать этими
        данными
    ]==]
    read set_token: (self: character, to: enumitem) -> (),

    --[==[
        У персонажа как такового определенных констант параметров нет, они создаются
        динамически при обращении. В ситуации когда они не были созданы будут предпочитаться
        стандартные данные от `characterinfo`, иначе динамические

        Это создано для того чтобы не определять десятки тысяч параметров персонажа, которых
        у него могут быть чуть ли не бесконечно много

        В этом конструкторе по умолчанию `всегда` создается релевантный по типу `value`
    ]==]
    read get_parameter: (self: character, ...enumitem_character_parameter_variant) -> ...value<number>,

    --[==[
        Был ли данный параметр создан когда-либо для этого персонажа?
    ]==]
    read has_parameter: (self: character, ...enumitem_character_parameter_variant) -> boolean,

    --[==[
        Использует `self.token` для доступа в хранилище способностей,
        после чего самостоятельно выбирает нужный пакет и возвращает его
    ]==]
    read get_abilities: (self: character) -> ...ability,

    --[==[
        Возвращает инвентарь конкретного персонажа и то чем он сейчас
        обладает
    ]==]
    read get_inventory: (self: character) -> unknown, -- TODO

    --[==[
        Возвращает референс на модель персонажа
    ]==]
    read get_model_reference: (self: character) -> reference<Model?>,

    --[==[
        Вовзращает референс на `Humanoid` персонажа
    ]==]
    read get_humanoid_reference: (self: character) -> reference<Humanoid?>
} & informable<character, characterinfo>, observer>

--[==[
    Объект, представляющий логического персонажа R6

    Объект всегда гарантирует существование R6 объектов
    в роблокс иерархии, иначе просто не получится присвоить референс
    на модель, к которой он обращается

    Обладает собственным функционалом для процедурной
    генерации и управлением частями тела R6
]==]
export type char6 = construct<{

    --[==[
        Вернет текущий пресет `leginfo`, который использует IK решатель
    ]==]
    read get_ik_leginfo: (self: char6) -> leginfo,
    --[==[
        Установит текущий пресет `leginfo` на указанный

        Изменения будут приведены в действие мгновенно, со следующего кадра
        решатель будет использовать новую информацию
    ]==]
    read set_ik_leginfo: (self: char6, new: leginfo) -> (),
    
    --[==[
        Вернет текущее состояние IK решателя для ног
    ]==]
    read is_ik_legs_active: (self: char6) -> boolean,

    --[==[
        Установить новое состояние для IK решателя ног
    ]==]
    read set_ik_legs_active: (self: char6, to: boolean) -> (),

    --[==[
        Гарантированно вернет Humanoid
    ]==]
    read get_humanoid: (self: char6) -> Humanoid    
}, character>



--[==[
    Объект, представляющий собой игровую способность с возможностью определения
    собственного поведения

    У данного объекта нет публичных методов для настройки кроме легко изменяемой
    информации балансировки. Сам объект не представляет их потому что этим должен
    заниматься код, который создает объект способности: подразумевается, что
    код создаст саму способность и настроит ее, а уже остальной код будет наследоваться
    от этой новосозданной способности и будет являться ее экземплярами

    Для реализации этого принципа используйте то, что способность провайдит собственные
    енамайтемы и сигнализирует о начальной фазе работы, после чего вручную управляйте ее
    конечным автоматом и уведомлениями прямо из функции способности
]==]
export type ability <T... = ...unknown> = construct<{
    --[==[
        Активирует способность от перспективы указанного персонажа

        Перспектива персонажа используется в качестве источника первоначальной информации,
        она отвечает на вопрос: "что мы вообще пытаемся сделать прямо сейчас?"
    ]==]
    read activate: (self: ability<T...>, on: character, T...) -> (),

    --[==[
        Таймер, контроллирующий текущее состояние кулдауна способности
    ]==]
    read cooldown: (self: ability<T...>) -> timer,
    

} & informable<ability<T...>, abilityinfo> &
    collidable<ability<T...>> &
    stateable<ability<T...>, enumitem_round_state>,
observer<enumitem_ability_notification>>










































-- Game Struct



--[==[
    Объект, представляющий балансную информацию о способности

    Его можно менять, создавать новые варианты баланса или редактировать
    на лету, а поскольку способность использует каждый раз те данные,
    что ей доступны на момент вызова, то и применяется это всегда
]==]
export type abilityinfo = construct<{
    
    --[==[
        Имеет ли способность время перезарядки после вызова?
    ]==]
    read has_cooldown: boolean,

    --[==[
        Имеет ли способность стан, в течении которого пораженная сущность не может выполнять
        активные или какие-либо другие действия?
    ]==]
    read has_stun: boolean,

    --[==[
        Есть ли у способности отброс для пораженной сущности, в которую способность попала?

        Может быть отрицательным, тогда пораженная сущность должна полететь в сторону откуда прилетел в нее снаря
    ]==]
    read has_kickback: boolean,

    --[==[
        Есть ли у способности отдача в персонажа, от лица которого она вызывается?
    ]==]
    read has_recoil: boolean,

    --[==[
        Применяется ли к пораженной сущности модификатор замедления передвижения?

        Может быть больше 1, тогда будет ускорять
    ]==]
    read has_slow: boolean,

    --[==[
        В зависимости от состояния полей `can_move_on_...` в указанной фазе способности
        будет применяться модификатор `slow` на персонажа, от лица которого вызвана
        эта способность
    ]==]
    read has_self_slow: boolean,








    --[==[
        Время перезарядки самой способности, в течении которого способность будет недоступна
    ]==]
    read cooldown: number,

    --[==[
        Время стана, в течении которого пораженный персонаж не может передвигаться или
        использовать что-либо, включая свои способности
    ]==]
    read stun: number,

    --[==[
        Сила отдачи, которая применяется на персонажа, от лица которого выполнена эта способность
    ]==]
    read recoil: number,

    --[==[
        Сила отдачи, которая применяется к тому, во что врежется эта способность, будь бы это предмет
        или другой персонаж
    ]==]
    read kickback: number,

    --[==[
        Применяемый модификатор замедления на пораженную цель, если он вообще указан
    ]==]
    read slow: number,

    read can_move_on_prepare_time: boolean,
    read can_move_on_action_time: boolean,
    read can_move_on_post_action_time: boolean,
    
    read prepare_action_time: number,
    read work_action_time: number,
    read post_action_time: number


}, struct>

--[==[
	Объект, предоставляющий информацию для IK решателя `char6`,
	в частности информацию для поведения IK ног.
]==]
export type leginfo = construct<{
	--[[
		Величина смешивания направления движения/ориентации ноги
		с направлением корпуса.

		Используется при вычислении forward-направления ноги:
		`0` — полностью используется направление, в котором должна
		смотреть стопа; `1` — полностью используется локальное
		направление корпуса.
	]]
	read step_use_torso_alpha: number,

	--[[
		Максимальное расстояние вперед от точки постановки ноги,
		на котором проверяется наличие препятствия.

		Если препятствие находится ближе этого расстояния,
		оно может заблокировать обычный шаг.
	]]
	read step_block_distance: number,

	--[[
		Максимальная высота препятствия, которую нога может
		перешагнуть.

		Если найденная верхняя поверхность находится выше
		этого значения относительно основания корпуса,
		обычный шаг считается невозможным.
	]]
	read step_max_height: number,

	--[[
		Высота над основанием ноги, с которой выполняется
		первичный raycast для обнаружения вертикального
		препятствия перед ногой.

		Используется только для проверки блокирующей стены,
		а не для непосредственного поиска поверхности стопы.
	]]
	read step_obstacle_height: number,

	--[[
		Минимальная скорость перемещения стопы во время фазы
		`stepping`.

		Используется как нижняя граница интерполяционной
		скорости при минимальной скорости персонажа.
	]]
	read step_speed_min: number,

	--[[
		Максимальная скорость перемещения стопы во время фазы
		`stepping`.

		Используется как верхняя граница интерполяционной
		скорости при достижении максимальной учитываемой
		горизонтальной скорости персонажа.
	]]
	read step_speed_max: number,

	--[[
		Минимальная горизонтальная скорость персонажа,
		соответствующая `step_speed_min`.

		Скорость ниже этого значения не уменьшает скорость
		шага дальше установленного минимума.
	]]
	read step_velocity_min: number,

	--[[
		Максимальная горизонтальная скорость персонажа,
		соответствующая `step_speed_max`.

		Скорость выше этого значения не увеличивает скорость
		шага дальше установленного максимума.
	]]
	read step_velocity_max: number,

	--[[
		Минимальная скорость интерполяции ноги в фазе
		`settling`.

		Используется при минимальном коэффициенте скорости
		персонажа.
	]]
	read settle_speed_min: number,

	--[[
		Максимальная скорость интерполяции ноги в фазе
		`settling`.

		Используется при максимальном коэффициенте скорости
		персонажа.
	]]
	read settle_speed_max: number,

	--[[
		Скорость, с которой нога продолжает следовать за
		рассчитанной опорной точкой в состоянии `planted`.

		Определяет скорость сглаживания текущего положения
		стопы относительно нового `plant target`.
	]]
	read planted_speed: number,

	--[[
		Базовая скорость следования ноги за целевым положением.

		В текущей реализации значение фактически не участвует
		в конечном расчете `solve_foot`: в каждой фазе значение
		`alpha` переопределяется собственной скоростью
		(`step`, `settle` или `planted`).
	]]
	read leg_follow_speed: number,

	--[[
		Порог скалярного произведения между направлением движения
		и направлением корпуса, после которого ориентация стопы
		переключается обратно на направление корпуса.

		При меньшем значении считается, что персонаж движется
		достаточно сильно в сторону, противоположную направлению
		корпуса, поэтому направление стопы берется от корпуса.

		При значении `0.5` порог соответствует углу примерно 60°.
	]]
	read leg_rotation_inverse_coefficient: number,

	--[[
		Минимальное время предсказания положения основания ноги
		по горизонтальной скорости персонажа.

		Применяется при вычислении предсказанной позиции перед
		raycast для шага.
	]]
	read leg_prediction_time_min: number,

	--[[
		Максимальное время предсказания положения основания ноги
		по горизонтальной скорости персонажа.

		При увеличении скорости персонажа значение стремится
		к этому пределу.
	]]
	read leg_prediction_time_max: number,

	--[[
		Показатель степени кривой интерполяции времени предсказания.

		Коэффициент скорости сначала вычисляется в диапазоне
		`0..1`, после чего возводится в эту степень перед
		интерполяцией между `leg_prediction_time_min` и
		`leg_prediction_time_max`.

		Значение больше `1` смещает рост предсказания в сторону
		более высоких скоростей.
	]]
	read leg_prediction_curve: number,

	--[[
		Расстояние вперед по направлению движения, на которое
		смещается raycast при обычном шаге.

		Используется для поиска новой поверхности постановки стопы.
	]]
	read step_forward: number,

	--[[
		Расстояние вперед, на которое смещается raycast при
		поиске поверхности для установки ноги в состоянии покоя.

		Используется процедурой `stand`.
	]]
	read stand_forward: number,

	--[[
		Расстояние вперед для специального шага в idle-режиме.

		Используется, когда обычный шаг заблокирован препятствием
		и система пытается переставить свободную ногу через
		`begin_idle_step`.

		Значение `0` означает поиск опоры непосредственно под
		ногой без дополнительного смещения вперед.
	]]
	read idle_step_forward: number,

	--[[
		Время отсутствия движения перед переходом в idle-логику.

		После достижения этого времени выполняется обновление
		целевых положений обеих стоящих ног через `stand`.
	]]
	read idle_time: number,

	--[[
		Максимально допустимая угловая ошибка между текущей
		ориентацией стопы и нормалью/ориентацией рассчитанной
		опорной поверхности во время `settling`.

		Когда ошибка становится меньше этого значения,
		фаза `settling` завершается и нога переходит в
		состояние `planted`.
	]]
	read foot_settle_angle: number,
}, struct>

--[==[
    Объект, представляющий собой пул информации о персонаже, который
    встраивается в него каждый раз когда к части рантайма персонажа
    обращается кто-либо, при этом эта часть у персонажа не была активной
    ранее или не была создана в другом моменте

    Эта информация применяется постепенно и может быть передана на разных
    персонажей, а также она не зависит от токенов или любых других данных

    Предоставленная информация может быть проигнорирована в разных случаях,
    поскольку она декларирует поведение относительно стандартного сценария,
    когда не вызываются никакие способности или выполняется что-либо еще
]==]
export type characterinfo = construct<{
    read has_health: boolean,
    read has_stamina: boolean,
    read has_stamina_use: boolean,
    read has_stamina_regen: boolean,
    read has_health_regen: boolean,
    read has_stamina_runspeed_related_mod: boolean,
    read has_health_runspeed_related_mod: boolean,
    read has_jump_cooldown: boolean,
    read has_run_cooldown: boolean,
    
    read can_run: boolean,
    read can_jump: boolean,
    read can_move: boolean,
    read can_die: boolean,
    read can_revived: boolean,

    read health: number,
    read stamina: number,
    read speed: number,
    read runspeed: number,
    read run_cooldown: number,
    read jump_cooldown: number,
    read revives: number,

},struct>
































































-- Struct

--[==[
    Объект, представляющий унифицированный результат выполнения той или иной операции
]==]
export type result<T = unknown, U... = ...unknown> = construct<{

    --[==[
        Статус выполнения этой операции
    ]==]
    read state: boolean,

    --[==[
        Результат, который был получен за эту операцию

        Он не обязан быть корректным, если `self.state` является `false`
    ]==]
    read result: T,

    --[==[
        Применяется строго в случаях, когда значение результа по типу является
        либо `table`, либо `function`, иначе ничего не вернет
    ]==]
    read unpack: (self: result<T,U...>) -> U...
}, struct>



--[==[
    Объект, представляющий кубическую, неповорачиваемую и при этом
    проверяемую область в пространстве

    Специфичный случай `cubevolume`
]==]
export type aabbvolume = construct<{
    --[==[
        Часть куба, которая участвует в определении области пространства,
        которую занимает этот объект. Указывает на крайний угол противположной
        стороны куба
    ]==]
    read min: vector,

    --[==[
        Часть куба, которая участвует в определении области пространства,
        которую занимает этот объект. Указывает на крайний угол противположной
        стороны куба
    ]==]
    read max: vector
} & geometry_half &
    geometry_control<aabbvolume> &
    geometry_check<aabbvolume> & 
    geometry_convertation<aabbvolume, geometry_supported>, 
cubevolume<aabbvolume>>


--[==[
    Объект, представляющий кубическую поворачиваемую и проверяемую
    область в пространстве

    Специфичный случай `cubevolume`
]==]
export type obbvolume = construct<geometry_rotatable &
    geometry_convertation<obbvolume, geometry_supported> &
    geometry_control<obbvolume> &
    geometry_half &
    geometry_check<obbvolume>,
cubevolume<obbvolume>>

--[===[

--[==[
    Объект, представляющий собой сферическую область в пространстве
]==]
export type spherevolume = construct<{
    radius: number,
} & centerable<spherevolume> & 
    math_operations<spherevolume, spherevolume>, 
struct>

--[==[
    Объект, представляющий собой конусную область в пространстве

    Основание этого объекта является окружностью
]==]
export type conevolume = construct<{

    --[==[
        Кончик конуса будет выставлен на указанную точку в пространстве, при этом
        база (платфома, тупая часть конуса, то есть низ) будет повернута в сторону
        куда смотрит кончик конуса

        Переданный дополнительный аргумент смещает основание базы на указанную позицию
    ]==]
    read edge_point: (self: conevolume, to: vector, base: vector?) -> conevolume,

} & centerable<conevolume> & 
    geometry_convertation<conevolume, geometry_supported> &
    geometry_rotatable &
    geometry_control<conevolume> &
    geometry_check<conevolume>,
geovolume<conevolume>>

--[==[
    Объект, представляющий собой капсульную область в пространстве
]==]
export type capsulevolume = construct<{

}
& centerable<capsulevolume> & 
    geometry_convertation<capsulevolume, geometry_supported> &
    geometry_rotatable &
    geometry_control<capsulevolume> &
    geometry_check<capsulevolume>,
geovolume<capsulevolume>>

--[==[
    Объект, представляющий собой область в пространстве с `N` количеством
    опорных вертексов, с которыми проводятся вычисления

    Операции с этим объектом могут быть ресурсозатратными
]==]
export type tetavolume = construct<{

    --[==[
        Возвращает все опорные вертексы этой области
    ]==]
    read get_vertex: (self: tetavolume) -> ...vector,

    --[==[
        Добавляет опорный вертекс к этой области
    ]==]
    read add_vertex: (self: tetavolume, ...vector) -> (),

    --[==[
        Удаляет опорный вертекс из этой области, если он есть

        Если таких векторов несколько, будет удален первый попавшийся
    ]==]
    read rem_vertex: (self: tetavolume, ...vector) -> (),
}
& centerable<tetavolume> & 
    geometry_convertation<tetavolume, geometry_supported> &
    geometry_rotatable &
    geometry_control<tetavolume> &
    geometry_check<tetavolume, geometry_supported>,
geovolume<tetavolume>>

]===]

--[==[
    Объект, представляющий собой треугольник из 3 векторов в пространстве,
    образующий таким образом часть полигона
]==]
export type triangle = construct<{
    --[==[
        Утилитарная функция по созданию стандартного `triangle` объекта,
        фактически ничем не отличающаяся от примера:

        ```luau
        self:new {
            right = right,
            up = up,
            front = front
        }
        ```
    ]==]
    read from_vector: (self: triangle, right: vector?, up: vector?, front: vector?) -> triangle
} & centerable<triangle> & 
    axisable<vector> & 
    normals<triangle>,
geovolume<triangle>>

--[==[
    Объект, представляющий собой полигон из 2 треугольников
]==]
export type quad = construct<{
    --[==[
        Левый треугольник, часть полигона
    ]==]
    read left: triangle,

    --[==[
        Правый треугольник, часть полигона
    ]==]
    read right: triangle,
} & centerable<quad> & 
    normals<quad> & 
    math_operations<quad, quad>, 
struct>

--[==[
    Объект, использующийся для определения осей пространства
]==]
export type directions = construct<vector_operations<directions, directions> & axisable<vector>, geovolume<directions>>

--[==[
    Объект, представляющий собой геометрический аналог координаты

    Хранит в себе информацию о повороте и положении в пространстве
]==]
export type basis = construct<{
    read orthonormalize: (self: basis) -> basis,
    read euler_angles: (self: basis) -> ...number,
    read components: (self: basis) -> ...number,
} & positioned & rotateable, geovolume<basis>>

--[==[
    Объект, представляющий собой область пространства в форме восьмиугольника
]==]
export type cubevolume <T = cubevolume> = construct<{
    --[==[
        Направление `+Y`, эквивалетное как `UpVector`
    ]==]
    read up: vector,

    --[==[
        Направление `-Y`, эквивалетное как `-UpVector`
    ]==]
    read bottom: vector,

    --[==[
        Направление `-X`, эквивалетное как `-RightVector`
    ]==]
    read left: vector,

    --[==[
        Направление `+X`, эквивалетное как `RightVector`
    ]==]
    read right: vector,

    --[==[
        Направление `-Z`, эквивалетное как `LookVector`
    ]==]
    read front: vector,

    --[==[
        Направление `Z`, эквивалентное как `-LookVector`
    ]==]
    read back: vector,

    --[==[
        Возвращает все вершины куба в их абсолютном виде
    ]==]
    read get_corners: (self: cubevolume<T>) -> {vector},

    --[==[
        Возвращает направление согласно полученному `enumitem`
    ]==]
    read get_direction: (self: cubevolume<T>, direction: enumitem_direction_variant) -> vector,

    --[==[
        Вовзращает `XYZ` направления, то есть основные оси по которым распределен этот
        конкретный `cubevolume`
    ]==]
    read get_axises: (self: cubevolume<T>) -> directions,

    --[==[
        Возвращает нормализованные направления, подогнанные для работы `SAT`
    ]==]
    read get_sat_axises: (self: cubevolume<T>) -> {vector},

    --[==[
        Из указанного направления построит `Quad` (фейс) из 2 треугольников на
        основании вершин куба
    ]==]
    read get_quad: (self: cubevolume<T>, direction: enumitem_direction_variant) -> quad,
} & centerable<cubevolume<T>>& 
    vector_operations<cubevolume<T>, T>, 
geovolume<cubevolume<T>>>

--[==[
    Базовый абстрактный класс для части геометрии, использующийся в качестве
    общего математического и утилитарного api

    Его используют все `volume` объекты, представляющие хоть какую-то область
    в пространстве

    Сам по себе не имеет смысла
]==]
export type geovolume<T = any> = construct<math_operations<T, T>, struct>
























-- Service


export type securityrng = construct<{
	read seed: number,

	read get_hash_sha256: (self: securityrng, element: string) -> string,
	read get_hash_blake3: (self: securityrng, element: string) -> string,
	read get_uid: (self: securityrng) -> string,
}, service>

export type charregistry = construct<{
    read get_character: (self: charregistry, of: profile) -> character?,
    read set_character: (self: charregistry, of: profile, to: character?) -> (),

    --[==[
        Профиль игрока связан с персонажем, если конечно это было, поэтому
        получить игрока к которому принадлежит этот персонаж можно при помощи
        этого сервиса
    ]==]
    read get_profile: (self: charregistry, of: character) -> profile?,
    
    --[==[
        Позволяет назначить этого персонажа данному игроку
    ]==]
    read set_profile: (self: charregistry, of: character, to: profile?) -> (),

    --[==[
        Проверяет, является ли указанный объект тем, что принадлежит хотя бы одному персонажу
    ]==]
    read is_character: (self: charregistry, ...Humanoid|Model|BasePart ) -> ...boolean,
}, service>

















































-- Enums

--!strict

export type enumitem_default_variant = enumitem<enum_default_variant>
export type enum_default_variant = construct<{
	read Unknown: enumitem_default_variant,
	read Any: enumitem_default_variant,
}, enumobject>

export type enumitem_tasky_variant = enumitem<enum_tasky_outcode_variant>
export type enum_tasky_outcode_variant = construct<{
	read Reenter: enumitem_tasky_variant,
	read Goto: enumitem_tasky_variant,
	read Error: enumitem_tasky_variant,
}, enumobject>

export type enumitem_input_notification = enumitem<enum_input_notification>
export type enum_input_notification = construct<{
	read CodeAdded: enumitem_input_notification,
	read CodeRemoved: enumitem_input_notification,
	read Pressed: enumitem_input_notification,
	read Clamped: enumitem_input_notification,
	read Stopped: enumitem_input_notification,
	read RelatedChanged: enumitem_input_notification,
	read RelatedNullified: enumitem_input_notification,
	read NetworkEnabled: enumitem_input_notification,
	read NetworkDisabled: enumitem_input_notification,
}, enumobject>

export type enumitem_ability_notification = enumitem<enum_ability_notification>
export type enum_ability_notification = construct<{
	read CastAbility: enumitem_ability_notification,
    read WaitingDataAbility: enumitem_ability_notification,
    read ActiveAbility: enumitem_ability_notification,
    read CancelAbility: enumitem_ability_notification,
    read EndingAbility: enumitem_ability_notification,
    read CooldownAbility: enumitem_ability_notification,
}, enumobject>


export type enumitem_state = enumitem<enum_state>
export type enum_state = construct<{
	read Failure: enumitem_state,
	read Loading: enumitem_state,
	read Successful: enumitem_state,
	read Nothing: enumitem_state,
}, enumobject>

export type enumitem_user_machine_variant = enumitem<enum_user_machine_variant>
export type enum_user_machine_variant = construct<{
	read Computer: enumitem_user_machine_variant,
	read Mobile: enumitem_user_machine_variant,
	read Console: enumitem_user_machine_variant,
	read AnotherDevice: enumitem_user_machine_variant,
}, enumobject>

export type enumitem_controller_state = enumitem<enum_controller_state>
export type enum_controller_state = construct<{
	read Continue: enumitem_controller_state,
	read Pause: enumitem_controller_state,
	read Reset: enumitem_controller_state,
}, enumobject>

export type enumitem_operation_variant = enumitem<enum_operation_variant>
export type enum_operation_variant = construct<{
	read New: enumitem_operation_variant,
	read Change: enumitem_operation_variant,
	read Remove: enumitem_operation_variant,
}, enumobject>

export type enumitem_reference_notification = enumitem<enum_reference_notification>
export type enum_reference_notification = construct<{
	read NewInstance: enumitem_reference_notification,
	read ChangedInstance: enumitem_reference_notification,
	read DestroyedInstance: enumitem_reference_notification,
	read NullifiedInstance: enumitem_reference_notification,
}, enumobject>

export type enumitem_executor_notification = enumitem<enum_executor_notification>
export type enum_executor_notification = construct<{
	read Process: enumitem_executor_notification,
	read Simulation: enumitem_executor_notification,
}, enumobject>

export type enumitem_character_parameter_variant = enumitem<enum_character_parameter_variant>
export type enum_character_parameter_variant = construct<{
	read Health: enumitem_character_parameter_variant,
	read Stamina: enumitem_character_parameter_variant,
	read Speed: enumitem_character_parameter_variant,
	read RunSpeed: enumitem_character_parameter_variant,
	read RunCooldown: enumitem_character_parameter_variant,
	read JumpCooldown: enumitem_character_parameter_variant,
	read Revives: enumitem_character_parameter_variant,
}, enumobject>

export type enumitem_attribute_notification = enumitem<enum_attribute_notification>
export type enum_attribute_notification = construct<{
	read Added: enumitem_attribute_notification,
	read Changed: enumitem_attribute_notification,
	read Removed: enumitem_attribute_notification,
}, enumobject>

export type enumitem_setup_notification = enumitem<enum_setup_notification>
export type enum_setup_notification = construct<{
	read Install: enumitem_setup_notification,
	read Installed: enumitem_setup_notification,
	read Require: enumitem_setup_notification,
	read Disconnected: enumitem_setup_notification,
}, enumobject>

export type enumitem_tick_notification = enumitem<enum_tick_notification>
export type enum_tick_notification = construct<{
    read Started: enumitem_tick_notification,
    read Stepped: enumitem_tick_notification,
    read Paused: enumitem_tick_notification,
    read Resumed: enumitem_tick_notification,
    read Finished: enumitem_tick_notification,
}, enumobject>

export type enumitem_round_state = enumitem<enum_round_state>
export type enum_round_state = construct<{
    read Preparing: enumitem_round_state,
    read Begining: enumitem_round_state,
    read AtWork: enumitem_round_state,
    read Ending: enumitem_round_state,
    read Ended: enumitem_round_state
}, enumobject>


export type enumitem_asset_type_variant = enumitem<enum_asset_type_variant>
export type enum_asset_type_variant = construct<{
	read Model: enumitem_asset_type_variant,
	read Sound: enumitem_asset_type_variant,
	read Image: enumitem_asset_type_variant,
}, enumobject>

export type enumitem_faction_notification = enumitem<enum_faction_notification>
export type enum_faction_notification = construct<{
	read MemberJoined: enumitem_faction_notification,
    read MemberRemoved: enumitem_faction_notification
}, enumobject>

export type enumitem_user_data_require = enumitem<enum_user_data_require>
export type enum_user_data_require = construct<{
	read UserProfile: enumitem_user_data_require,

	read UserLastDataSave: enumitem_user_data_require,
	read UserLastDataRequest: enumitem_user_data_require,
	read UserPlayedTime: enumitem_user_data_require,
	read UserLastEnter: enumitem_user_data_require,
	read UserPreviousKick: enumitem_user_data_require,
	read UserPreviousBan: enumitem_user_data_require,
}, enumobject>

export type enumitem_user_notification = enumitem<enum_user_notification>
export type enum_user_notification = construct<{
	read ServerJoin: enumitem_user_notification,
	read ServerExit: enumitem_user_notification,
	read ServerBan: enumitem_user_notification,
	read ServerKick: enumitem_user_notification,
	read ServerDataRequest: enumitem_user_notification,
}, enumobject>

export type enumitem_action_map_variant = enumitem<enum_action_map_variant>
export type enum_action_map_variant = construct<{
	read MoveForward: enumitem_action_map_variant,
	read MoveBackward: enumitem_action_map_variant,
	read MoveLeft: enumitem_action_map_variant,
	read MoveRight: enumitem_action_map_variant,
	read MoveJump: enumitem_action_map_variant,
	read MoveCrounch: enumitem_action_map_variant,
	read MoveLying: enumitem_action_map_variant,
	read MoveRun: enumitem_action_map_variant,
	read MoveSlow: enumitem_action_map_variant,
}, enumobject>

export type enumitem_statemachine_notification = enumitem<enum_statemachine_notification>
export type enum_statemachine_notification = construct<{
    read ChangedState: enumitem_statemachine_notification,
    read NewState: enumitem_statemachine_notification,

    read BlacklistAdded: enumitem_statemachine_notification,
    read BlacklistRemoved: enumitem_statemachine_notification,
}, enumobject>

export type enumitem_connection_variant = enumitem<enum_connection_variant>
export type enum_connection_variant = construct<
	{
		read Ever: enumitem_connection_variant,
		read Once: enumitem_connection_variant,
		read Hold: enumitem_connection_variant, -- reserved
		read Skip: enumitem_connection_variant, -- -> Once
		read Next: enumitem_connection_variant, -- -> Ever
	},
	enumobject
>

export type enumitem_internal_channel_variant = enumitem<enum_internal_channel_variant>
export type enum_internal_channel_variant = construct<{
	read UserData: enumitem_internal_channel_variant,
}, enumobject>

export type enumitem_physx_mode_variant = enumitem<enum_physx_mode_variant>
export type enum_physx_mode_variant = construct<{
	read Local: enumitem_physx_mode_variant,
	read Global: enumitem_physx_mode_variant,
}, enumobject>

export type enumitem_disposable_notification = enumitem<enum_disposable_notification>
export type enum_disposable_notification = construct<{
	read OnRelease: enumitem_disposable_notification,
	read Released: enumitem_disposable_notification,
}, enumobject>

export type enumitem_direction_variant = enumitem<enum_direction_variant>
export type enum_direction_variant = construct<{
    read Up: enumitem_direction_variant,
    read Bottom: enumitem_direction_variant,
    read Left: enumitem_direction_variant,
    read Right: enumitem_direction_variant,
    read Front: enumitem_direction_variant,
    read Back: enumitem_direction_variant,
}, enumobject>


export type enumitem_collision_variant = enumitem<enum_collision_variant>
export type enum_collision_variant = construct<{
    read DefaultGroup: enumitem_collision_variant,
    read ItemGroup: enumitem_collision_variant,
    read CharacterGroup: enumitem_collision_variant,
    read DebrisGroup: enumitem_collision_variant,
}, enumobject>
























-- Interface


export type instanceable<T = {},U = Instance> = {
    read set_instance: (self: T, to: U) -> (),                 
    read get_instance: (self: T) -> U,
    read is_instance_exists: (self: T) -> boolean                      
}
export type expected_calltype <T=unknown> = {
    on: T
}
export type nameable <T=string> = {
    name: T|string
}
export type operatable<T = unknown> = {
    read continue: (self: T) -> (),
    read pause: (self: T) -> (),
    read reset: (self: T) -> ()
}
export type controllable<T = unknown> = {
    read get_control: (self: T) -> controller
}
export type modifier<T = unknown> = {
    modifier: T
}
export type iterations<T = unknown> = {
    iterate: T
}
export type loopable<T = unknown> = {
    read get_loop: (self: T) -> timer
}
export type referenceable<T = unknown, U = unknown> = {
    read get_reference: (self: T) -> reference<U>,
}
export type reloadable<T = unknown, U... = ()> = {
    read reload: (self: T, U...) -> ()
}

export type switchable = {
    enabled: boolean
}

export type invokeable<T = unknown, U... = (), E... = ()> = {
    read invoke: (self: T, U...) -> E...
}
export type asyncable = {
    time_to_hold: number,
    time_to_response: number,
    attempts: number,
}

export type geometry_volume = aabbvolume  | obbvolume | cubevolume -- TODO | spherevolume | trianglevolume | capsulevolume
export type geometry_primetive = triangle | quad | vector | cubevolume
export type geometry_supported = geometry_volume | Model | BasePart | PVInstance

--[==[
    Интерфейс предоставляет объекту операции геометрических проверок для
    уточнения факта коллизий
]==]
export type geometry_check <T = unknown> = {

    --[==[
        Переданные данные охвачены диапазоном объекта, из которого вызывается этот метод,
        либо нет, что в итоге приведет к `false`
    ]==]
    read is_inside: (self: T, ...unknown) -> boolean,

    --[==[
        Переданные данные вообще как-либо взаимодействуют с объектом, из которого
        вызван этот метод

        Аналогичен:

        ```luau
            const interacts = self:is_inside(val) and self:is_intersection(val)
        ```
    ]==]
    read is_interacts: (self: T, ...unknown) -> boolean,

    --[==[
        Переданные данные, хотя-бы один из них, пересекается с объектом, из которого
        вызван этот метод. Даже если пересечение совсем небольшое
    ]==]
    read is_intersection: (self: T, ...unknown) -> boolean,
}

export type geometry_half = {
    --[==[
        Полуразмер представляет собой удобный способ проводить вычисления через центр
        и полуоси, через `min | max` или прямые конвертации | сравнения
    ]==]
    half: vector
}

--[==[
    Управляющие контроллеры над самой геометрической фигурой типа смотри туда, делай то
    и тому подобного
]==]
export type geometry_control <T = unknown> = {
    --[==[
        Заставляет геометрическую фигуру направиться лицевой стороной на указанную
        в пространстве точку
    ]==]
    read look_at: (self: T, that: vector, up: vector?) -> T,
}

export type geometry_rotatable <T = unknown> = {
    --[==[
        Поворачивает объект относительно его текущего локального поворота,
        путем прибавления или убавления радиан

        В пространстве определяется центр объекта, и относительно него и идет
        поворот объекта
    ]==]
    read rotate_radian: (self: obbvolume, rad_vector: vector) -> obbvolume,

    --[==[
        Возвращает абсолютный угол поворота по радианам относительно
        мирового стандартного угла (0 0 0)
    ]==]
    read get_rotation_radian: (self: obbvolume) -> vector
}

--[==[
    Операции конвертаций геометрических структур из 1 вида в другой, то есть
    трансформация информации
]==]
export type geometry_convertation <T = unknown, U... = ...unknown> = {
    --[==[
        Входящие данные должны быть переведены в тот же тип что и объект, откуда
        вызывается данный метод. При этом сами сконвертированные данные после
        не должны быть как-либо связаны с начальным объектом
    ]==]
    read from: (self: T, U...) -> T,

    --[==[
        Между всеми полученными значениями вычисляется состояние,
        которое охватывает хотя-бы какую-то часть всех переданных элементов
        и сводит все к среднему арифметическому варианту
    ]==]
    read middle: (self: T, U...) -> T,

    --[==[
        Новое значение должно гарантированно захватывать такое состояние,
        которое удовлетворяет условиям всех переданных данных. Результат должен
        захватывать все данные в себе

        Например:

        ```luau
            if volume.size == 49 then -- not OK
                -- ...
            end

            const result = volume:cover(BasePart, BasePart, Model, obbvolume, volume)
            
            if result.size == 595 then -- OK
                -- ...
            end
        ```
    ]==]
    read cover: (self: T, U...) -> T,
}

--[==[
    Объекты с этим интерфейсом обладают легко изменяемой логической реализацией,
    данные которой никак не влияют на саму функцию, которая работает с ними

    Это могут быть объекты баланса, объекты описывающие поведение того или иного
    элемента системы или нечто иное, что только декларирует что можно, что нельзя,
    насколько и по какому принципу
]==]
export type informable<T = unknown, U = unknown> = {
    --[==[
        Возвращает доступный пакет информации о способности
    ]==]
    read get_info: (self: T) -> U,

    --[==[
        Устанавливает новый пакет информации о способности
    ]==]
    read set_info: (self: T, info: U) -> ()
}


export type math_operations<T=unknown,U... = ()> = {
    read multiple: (self: T, to: number) -> U...,
    read divide: (self: T, to: number) -> U...,
    read append: (self: T, to: number) -> U...,
    read substract: (self: T, to: number) -> U...,

    --[==[
        Объект сравнивается с другим объектом на основании допуска, который
        указывает максимальную границу различий между `A` и `B`
    ]==]
    read fuzzy_eq: (self: T, to: T, epsilon: number?) -> boolean,

    --[==[
        Все значения объекта, с учетом `alpha` аргумента, "перетекут" к цели
        насколько это позволяет `alpha` от `0` - начала, до `1` - конечной
    ]==]
    read lerp: (self: T, to: T, alpha: number) -> U...,

    --[==[
        Все значения объекта инвертируют свой знак
    ]==]
    read invert: (self: T) -> U...,

    --[==[
        Все значения объекта сводятся в положительную сторону
    ]==]
    read absolute: (self: T) -> U...,

    --[==[
        Все значения объекта сводятся в отрицательную сторону
    ]==]
    read negation: (self: T) -> U...,

    --[==[
        Все значения объекта сводятся к `-1 | 1` через `clamp()`
    ]==]
    read normalize: (self: T) -> U...,

    --[==[
        Все значения объекта сводятся в `0`
    ]==]
    read null: (self: T) -> U...,

    --[==[
        Все значения объекта сводятся в `math.huge`
    ]==]
    read infinity: (self: T) -> U...,
}
export type vector_operations<T=unknown,U... = ()> = {
    read to_basis: (self: T) -> basis,
    read to_vector: (self: T) -> vector
}
export type positioned<T=vector> = {

    --[==[
        Позиция, представляющая собой центр геомтрического объекта

        Статически известна, либо вычисляется так, что вычислить информацию о ней
        динамически не представляется возможным. Например, для `Vertex`
    ]==]
    position: T
}
export type axisable<T = unknown> = {
    --[==[
        Направление оси по `X`
    ]==]
    right: T,

    --[==[
        Направление оси по `Y`
    ]==]
    up: T,

    --[==[
        Направление оси по `-Z`
    ]==]
    front: T
}

export type centerable<T = unknown> = {
    --[==[
        Вычисляет геометрический центр объекта исходя из доступной информации
    ]==]
    read get_center: (self: T) -> vector
}
export type rotateable<T = unknown> = {
    --[==[
        Определяет локальный поворот объекта относительной мировой сцены, что позволяет
        внезапно менять, например, гравитацию персонажа, если она рассчитывается вручную
        в обход движка, на котором исполняется код
    ]==]
    rotation: directions
}

--[==[
    Тип так или иначе заставляет взаимодействовать с определенными группами коллизий
]==]
export type collidable<T = unknown> = {
    --[==[
        Возвращает все коллизии, с которыми доступно взаимодействие
    ]==]
    read get_collision: (self: T) -> ...collision,

    --[==[
        Добавляет указанные коллизии в список, с которыми доступно взаимодействие
    ]==]
    read add_collision: (self: T, ...collision) -> (),

    --[==[
        Удаляет указанные коллизии из списка доступных взаимодействий
    ]==]
    read rem_collision: (self: T, ...collision) -> ()
}

export type normals<T=unknown, U=vector> = {
    --[==[
        Возвращает геометрическую нормаль

        Геометрическая нормаль получается из геометрии описываемой геометрической фигуры,
        за счет чего обладает свойством повторять ее поверхность и направление относительно
        взгляда этой поверхности

        Это обычная нормаль поверхности
    ]==]
    read get_normal_geometric: (self: T) -> U,

    --[==[
        Возвращает интерполированную (световую) нормаль

        Интерполированная нормаль получается исходя из общей интерполяции геометрической фигуры,
        как если бы доступные нормали участка 1 `Quad`, который представляет из себя острый угол
        под 90 градусов, внезапно усреднили и получили бы 45 градусное направление

        Это световая нормаль поверхности, она используется в основном для сглаженного шейдинга,
        однако подходит и под другие задачи
    ]==]
    read get_normal_interpolated: (self: T) -> U,
}
export type stateable<T = unknown, U = enumitem> = {
    --[==[
        Возвращает автомат состояний у этого объекта, с которым он неразрывно связан

        Используется для внутренней логики через декомпозицию, в основном
    ]==]
    read get_states: (self: T) -> statemachine<U>
}