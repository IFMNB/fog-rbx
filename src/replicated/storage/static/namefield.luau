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
export type maybe = literal<"maybe">
export type reference = literal<"reference">
export type controller = literal<"controller">
export type noderuntime = literal<"noderuntime">
export type schedule = literal<"schedule">
export type cube = literal<"cube">
export type directions = literal<"directions">
export type vertex = literal<"vertex">
export type triangle = literal<"triangle">
export type quad = literal<"quad">
export type channel = literal<"channel">
export type peer = literal<"peer">
export type user = literal<"user">
export type unit = literal<"unit">
export type parallelable = literal<"parallelable">
export type luaumachine = literal<"luaumachine">
export type randentity = literal<"randentity">
export type userdata = literal<"userdata">
export type weaponstat = literal<"weaponstat">
export type weaponvfx = literal<"weaponvfx">
export type weaponsfx = literal<"weaponsfx">
export type enumgroup = literal<"enumgroup">
export type mechasfx = literal<"mechasfx">
export type actmapped = literal<"actmapped">
export type observer = literal<"observer">
export type efx = literal<"efx">
export type ifx = literal<"ifx">
export type vfx = literal<"vfx">
export type sfx = literal<"sfx">
export type physx = literal<"physx">
export type emitter = literal<"emitter">
export type tasky = literal<"tasky">
export type package = literal<"package">
export type watcher = literal<"watcher">
export type remote = literal<"remote">
export type statemachine = literal<"statemachine">
export type signal = literal<"signal">

export type classfield = {
	read object: object,
	read runtimeobject: runtimeobject,
	read typeobject: typeobject,
	read enumobject: enumobject,
	read record: record,
	read disposable: disposable,
	read reflection: reflection,
	read node: node,
	read connection: connection,
	read entity: entity,
	read service: service,
	read asset: asset,
	read timer: timer,
	read limb: limb,
	read inventory: inventory,
	read boundbox: boundbox,
	read item: item,
	read weapon: weapon,
	read projectileweapon: projectileweapon,
	read raycastweapon: raycastweapon,
	read regionweapon: regionweapon,
	read armor: armor,
	read loadout: loadout,
	read value: value,
	read attribute: attribute,
	read result: result,
	read httprequest: httprequest,
	read server: server,
	read event: event,
	read browser: browser,
	read config: config,
	read sharednet: sharednet,
	read actmap: actmap,
	read round: round,
	read warfare: warfare,
	read faction: faction,
	read anyt: anyt,
	read enumitem: enumitem,
	read notification: notification,
	read reference: reference,
	read maybe: maybe,
	read controller: controller,
	read noderuntime: noderuntime,
	read cube: cube,
	read directions: directions,
	read vertex: vertex,
	read quad: quad,
	read triangle: triangle,
	read channel: channel,
	read user: user,
	read unit: unit,
	read parallelable: parallelable,
	read luaumachine: luaumachine,
	read randentity: randentity,
	read userdata: userdata,
	read weaponstat: weaponstat,
	read weaponvfx: weaponvfx,
	read weaponsfx: weaponsfx,
	read enumgroup: enumgroup,
	read mechasfx: mechasfx,
	read actmapped: actmapped,
	read observer: observer,
	read efx: efx,
	read ifx: ifx,
	read vfx: vfx,
	read sfx: sfx,
	read physx: physx,
	read emitter: emitter,
	read tasky: tasky,
	read package: package,
	read watcher: watcher,
	read remote: remote,
	read message: message,
	read statemachine: statemachine,
	read signal: signal
}

export type types =
	"nil"
	| "number"
	| "string"
	| "boolean"
	| "table"
	| "vector"
	| "function"
	| "thread"
	| "userdata"
	| "buffer"
	| "AdReward"
	| "Axes"
	| "BrickColor"
	| "CatalogSearchParams"
	| "CFrame"
	| "Color3"
	| "ColorSequence"
	| "ColorSequenceKeypoint"
	| "Content"
	| "DateTime"
	| "DockWidgetPluginGuiInfo"
	| "Enum"
	| "EnumItem"
	| "Enums"
	| "Faces"
	| "FloatCurve"
	| "Font"
	| "Instance"
	| "NumberRange"
	| "NumberSequence"
	| "NumberSequenceKeypoint"
	| "OverlapParams"
	| "Path2DControlPoint"
	| "PathWaypoint"
	| "PhysicalProperties"
	| "Random"
	| "Ray"
	| "RaycastParams"
	| "RaycastResult"
	| "RBXScriptConnection"
	| "RBXScriptSignal"
	| "Rect"
	| "Region3"
	| "Region3int16"
	| "RotationCurveKey"
	| "Secret"
	| "SecurityCapabilities"
	| "SharedTable"
	| "TweenInfo"
	| "UDim"
	| "UDim2"
	| "UserValue"
	| "Vector2"
	| "Vector2int16"
	| "Vector3"
	| "Vector3int16"

export type names = keyof<classfield>

const reflection = newproxy(true)
const meta = getmetatable(reflection)

meta.__index = function(self, indexer)
	return tostring(indexer)
end

meta.__metatable = "reflection"

table.freeze(meta)

return reflection :: classfield
