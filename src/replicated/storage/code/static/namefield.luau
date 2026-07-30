--!strict

export type literal<T = "never"> = T | string

export type object = literal<"object">
export type runtimeobject = literal<"runtimeobject">
export type typeobject = literal<"typeobject">
export type liberator = literal<"liberator">
export type enumobject = literal<"enumobject">
export type record = literal<"record">
export type disposable = literal<"disposable">
export type coordinate = literal<"coordinate">
export type reflection = literal<"reflection">
export type node = literal<"node">
export type event = literal<"event">
export type connection = literal<"connection">
export type entity = literal<"entity">
export type service = literal<"service">
export type raycast = literal<"raycast">
export type lifeform = literal<"lifeform">
export type meta = literal<"meta">
export type asset = literal<"asset">
export type human = literal<"human">
export type physics = literal<"physics">
export type storage = literal<"storage">
export type timer = literal<"timer">
export type world = literal<"world">
export type processor = literal<"processor">
export type limb = literal<"limb">
export type inventory = literal<"inventory">
export type upload = literal<"upload">
export type agent = literal<"agent">
export type boundbox = literal<"boundbox">
export type item = literal<"item">
export type weapon = literal<"weapon">
export type projectileweapon = literal<"projectileweapon">
export type raycastweapon = literal<"raycastweapon">
export type regionweapon = literal<"regionweapon">
export type armor = literal<"armor">
export type loadout = literal<"loadout">
export type value = literal<"value">
export type wrapper = literal<"wrapper">
export type attribute = literal<"attribute">
export type linked = literal<"linked">
export type job = literal<"job">
export type message = literal<"message">
export type content = literal<"content">
export type result = literal<"result">
export type httprequest = literal<"httprequest">
export type server = literal<"server">
export type browser = literal<"browser">
export type config = literal<"config">
export type face = literal<"face">
export type gameloop = literal<"gameloop">
export type anime = literal<"anime">
export type ability = literal<"ability">
export type charclass = literal<"charclass">
export type netpack = literal<"netpack">
export type sharednet = literal<"sharednet">
export type actmap = literal<"actmap">
export type rigdescriptor = literal<"rigdescriptor">
export type ikwalker = literal<"ikwalker">
export type materia = literal<"materia">
export type ikpointer = literal<"ikpointer">
export type round = literal<"round">
export type warfare = literal<"warfare">
export type faction = literal<"faction">
export type mathf = literal<"mathf">
export type anyt = literal<"any">
export type streamnet = literal<"streamnet">
export type enumitem = literal<"enumitem">
export type notification = literal<"notification">

export type classfield = {
	read object: object,
	read runtimeobject: runtimeobject,
	read typeobject: typeobject,
	read liberator: liberator,
	read enumobject: enumobject,
	read record: record,
	read disposable: disposable,
	read coordinate: coordinate,
	read reflection: reflection,
	read node: node,
	read event: event,
	read connection: connection,
	read entity: entity,
	read service: service,
	read raycast: raycast,
	read lifeform: lifeform,
	read meta: meta,
	read asset: asset,
	read human: human,
	read physics: physics,
	read storage: storage,
	read timer: timer,
	read world: world,
	read processor: processor,
	read limb: limb,
	read inventory: inventory,
	read upload: upload,
	read agent: agent,
	read boundbox: boundbox,
	read item: item,
	read weapon: weapon,
	read projectileweapon: projectileweapon,
	read raycastweapon: raycastweapon,
	read regionweapon: regionweapon,
	read armor: armor,
	read loadout: loadout,
	read value: value,
	read wrapper: wrapper,
	read attribute: attribute,
	read linked: linked,
	read job: job,
	read message: message,
	read content: content,
	read result: result,
	read httprequest: httprequest,
	read server: server,
	read browser: browser,
	read config: config,
	read face: face,
	read gameloop: gameloop,
	read anime: anime,
	read ability: ability,
	read charclass: charclass,
	read netpack: netpack,
	read sharednet: sharednet,
	read actmap: actmap,
	read rigdescriptor: rigdescriptor,
	read ikwalker: ikwalker,
	read materia: materia,
	read ikpointer: ikpointer,
	read round: round,
	read warfare: warfare,
	read faction: faction,
	read streamnet: streamnet,
	read anyt: anyt,
	read enumitem: enumitem,
	read notification: notification,
}
export type names = keyof<classfield>

const namefield : classfield = {
	--[=[
		Декларирует любой тип из classfield
	]=]
	anyt = "any" :: anyt,
	
	--[=[
		Базовый, по умолчанию несоздаваемый класс, который декларирует всю цепочку развития
		для наследования и самые стандартные данные объектов
	]=]
	object = "object" :: object,

	--[=[
		Объект, реализующий RTTI на основе `typeobject` экземпляров, а также некоторые другие
		функции
	]=]
	runtimeobject = "runtimeobject" :: runtimeobject,

	--[=[
		Объект, хранящий метаданные о классе. Используется в качестве способа выражения наследования,
		а также для уточнения метаинформации. По сути, представляет описание класса, и предназначен
		только для класса

		В рантайме Luau существует для RTTI и некоторых других функций
	]=]
	typeobject = "typeobject" :: typeobject,

	--[=[
		Объект информацирования
	]=]
	notification = "notification",

	liberator = "liberator" :: liberator, -- это необходимо для объекта disposable (инструкция по очистке)
	enumobject = "enumobject" :: enumobject, -- просто enumobject (несоздаваемый, создает число из hash-кода)
	record = "record" :: record, -- пусто пока-что (аналог struct)
	disposable = "disposable" :: disposable, -- есть объекты — это типичные Luau-таблицы, а disposable хранится в отдельном массиве, который удаляется только если ты его явно освобождаешь
	coordinate = "coordinate" :: coordinate, -- это из record (описание 3-х векторов x, y, z)

	--[=[
		Объект, предоставляющий описание поля на основе зарегистрированных при
		создании данных, использующийся для автоматизированных систем на основе рефлекции
	]=]
	reflection = "reflection" :: reflection,

	node = "node" :: node, -- как в gadot только ты прикрепляешь объект к instance роблокса (данный класс живет столько сколько instance)
	event = "event" :: event, -- контроллер события сигнала
	connection = "connection" :: connection, -- само соединения (аналог RBXScriptConnection)
	entity = "entity" :: entity, -- наследник node которая описывает здоровье и возможность умереть
	service = "service" :: service, -- от объекта класс исходит, создает обычный сервис который невозможно удалить

	raycast = "raycast" :: raycast, -- от record идет, описывает через result сам рейкаст и результ
	lifeform = "lifeform" :: lifeform, -- это наследник entity описывает характеристики персонажа
	meta = "meta" :: meta, -- это класс который заменяет метатаблицу собой добавляя доп. настройки
	asset = "asset" :: asset, -- штука которая разрешает загружать безопасно данные выдает характеристики
	human = "human" :: human, -- сам аналог humanoid
	physics = "physics" :: physics, -- deprecated (манипулятор)
	storage = "storage" :: storage, -- основная таблица куда классы сохраняют свои приватные данные, очистит при этом свои метаданные при замене
	timer = "timer" :: timer, -- обьект таймер является оберткой на task.wait работает в зависимосте от time scale других классов
	world = "world" :: world, -- singletone нода, описывает характеристики мира (физ параметры мира + взаимодействует с рейкастами и тд.)
	processor = "processor" :: processor, -- это нода которая может выполнятся автоматически есть свой runtime
	limb = "limb" :: limb, -- это наследник entity который хранит в себе характеристики и тип конечностей чарактера
	inventory = "inventory" :: inventory, -- это нода которая позволяет хранить в себе объекты (нереализован)
	upload = "upload" :: upload, -- это основной класс для ленивых подгрузок и таблиц значения
	agent = "agent" :: agent, -- это для паралейной работы, обертка над актором
	boundbox = "boundbox" :: boundbox, -- реализация геометрического объема в пространстве через AABB или OBB
	item = "item" :: item, -- наследуется от ноды представляет собой объект который можно взять в руку
	weapon = "weapon" :: weapon, -- имеет всегда превзянность вводу/выводу игрока (пока что не реализован)
	projectileweapon = "projectileweapon" :: projectileweapon, -- конкретный Weapon выпускает из дула объект
	raycastweapon = "raycastweapon" :: raycastweapon, -- для пуль
	regionweapon = "regionweapon" :: regionweapon, -- для милишек реализован на boundbox

	armor = "armor" :: armor, -- он должен покрывать модель, дефолтный армор
	loadout = "loadout" :: loadout, -- система разбита на то что в игре есть фракции можно использовать либо датастор либо сам лоадоут класс
	value = "value" :: value, -- есть в роблоксе инстансы типа ValueBase наследуется от disposable не завязан на роблоксе имеет ивенты и параметры типа типов в себе
	wrapper = "wrapper" :: wrapper, -- обертка над instance реализован на disposable
	attribute = "attribute" :: attribute, -- реализация аттрибута инстанса в качестве объекта
	linked = "linked" :: linked, -- singletone сервис позволяет привязать обьект к инстансу в не зависимосте от типа объекта
	job = "job" :: job, -- это процессор который постоянно выполняется но он не привязывается к instance
	message = "message" :: message, -- наследие от job добавляет некоторую информацию для общения между серверами либо сервисами
	content = "content" :: content, -- объект который подразумивает в себе наличие любой информации либо у него есть возможность провайдить тип и он будет отображать результ либо хранить информацию по сути массив
	result = "result" :: result, -- обертка над pcall должна была быть но в себе состоит true/false и результат выполнения
	httprequest = "httprequest" :: httprequest, -- это класс который обарачивает HttpService у него есть адресс, последний результат обращения к этому адрессу
	server = "server" :: server, -- это singletone нода которая предоставляет ошибки на сервере и тд, тех инфа по серверу
	browser = "browser" :: browser, -- это singletone сервис который предоставляет возможности игрокам переходить по другим серверам, браузер серверов
	config = "config" :: config, -- типа словарик, универсальный доступ обращяется к массивам/value и изменять их не выключая сервер
	face = "face" :: face, -- интерфейс для взаимодействия с разнообразными ивентами и событиями
	gameloop = "gameloop" :: gameloop, -- объект который предоставляет собой 1 функцию которая описывает как должен идти раунд
	anime = "anime" :: anime, -- замена animation скрипта работает как сервис, в 1 месте предоставляет анимации для всех сразу
	ability = "ability" :: ability, -- у персонажей есть возможность вызывать абилки внутри должен содержать функцию (нереализован)
	charclass = "charclass" :: charclass, -- это описывает текущий класс персонажа содержит loadout и тд.

	--[=[
		Объект, представляющий результат общения между клиентом и сервером.
		Содержит внутри себя настройки, с которыми была совершена передача
		данных, а также полезную нагрузку
	]=]
	netpack = "netpack" :: netpack,

	--[=[
		Сервис-обертка над всем сетевым стеком проекта, представляющий взаимодействие
		между клиентом и сервером с безопасного расстояния между друг другом
	]=]
	sharednet = "sharednet" :: sharednet,

	--[=[
		Синглтон-сервис для реакции на действия клиента. Предполагает,
		что клиент отправляет сигналы об активации того или иного биндинга,
		а иные варианты отбрасывает.

		Это позволяет биндить действия на любые клавиши и не зависеть от инпутов,
		которые исходят с клиента
	]=]
	actmap = "actmap" :: actmap,

	--[=[

	]=]
	streamnet = "streamnet" :: streamnet,

	--[=[
		Экземпляр предмета
	]=]
	enumitem = "enumitem" :: enumitem,

	rigdescriptor = "rigdescriptor" :: rigdescriptor, -- нереализованный на данный момент класс, должен описывать весь rig

	ikwalker = "ikwalker" :: ikwalker, -- этот класс — обертка над IKA Controller, избавляет от необходимости вызывать анимацию ходьбы (управляет ногами)
	materia = "materia" :: materia, -- на инстансы в физическом мире Roblox добавляет тег, по которому можно получить данные физического объекта
	ikpointer = "ikpointer" :: ikpointer, -- обертка над IKA Controller, которая позволяет управлять руками и телом, кроме ног (управляет телом)
	round = "round" :: round, -- описывает текущий раунд (поле боя)
	warfare = "warfare" :: warfare, -- описание всей боевой кампании
	faction = "faction" :: faction, -- это нода, которая оборачивает Team и предоставляет информацию этой фракции
	mathf = "mathf" :: mathf, -- это сервис, который предоставляет математические функции
}

return table.freeze (namefield)