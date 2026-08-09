--!strict

const namefield = require("./namefield")

export type construct<T = {}, U = object> = T & U
export type extend<T = {}> = construct<T>
export type prototype<T = {}, U = object> = construct<setmetatable<T, { __index: U }>, U>

type f_action <T... = (), U... = ()> = (T...) -> U...
type writeable_f_action <T... = (), U... = ()> = f_action|f_action<T...>|f_action<T..., U...>
type instanceable<T = {},U = Instance> = {
    read set_instance: (self: T, to: U) -> (),                 
    read get_instance: (self: T) -> U,
    read is_instance_exists: (self: T) -> boolean                      
}
type expected_calltype <T=unknown> = {
    call_on: T
}
type nameable <T=string> = {
    name: T|string
}
type math_operations<T=unknown,U... = ()> = {
    read multiple: (self: T, to: number) -> U...,
    read divide: (self: T, to: number) -> U...,
    read invert: (self: T) -> U...,
    read append: (self: T, to: number) -> U...,
    read substract: (self: T, to: number) -> U...,
    read absolute: (self: T) -> U...,
    read normalize: (self: T) -> U...,

    read null: (self: T) -> U...,
    read infinity: (self: T) -> U...,
}
type vector_operations<T=unknown,U... = ()> = {
    read to_cframe: (self: T) -> CFrame,
    read to_vector3: (self: T) -> Vector3,
    read to_vector2: (self: T) -> Vector2
}
type positioned<T=Vector3> = {
    position: T
}
type normals<T=unknown, U=Vector3> = {
    read get_normal_geometric: (self: T) -> U,
    read get_normal_interpolated: (self: T) -> U,
}
type stream_identity_type = string
type face_default_type = nil
type linkable<T=unknown,U=unknown> = {
    read link: (self: T, that: U) -> (),
    read unlink: (self: T, that: U) -> ()
}
type operatable<T = unknown> = {
    read continue: (self: T) -> (),
    read pause: (self: T) -> (),
    read reset: (self: T) -> ()
}
type controllable<T = unknown> = {
    read get_control: (self: T) -> controller
}
type modifier<T = unknown> = {
    modifier: T
}
type iterations<T = unknown> = {
    iterate: T
}
type loopable<T = unknown> = {
    read get_loop: (self: T) -> timer
}
type referenceable<T = unknown, U = unknown> = {
    read get_reference: (self: T) -> reference<U>,
}

type reloadable<T = unknown> = {
    read reload: (self: T) -> ()
}
type axisable<T = unknown> = {
    right: T,
    up: T,
    front: T
}
type centerable<T = unknown> = {
    read get_center: (self: T) -> Vector3
}
type parallel_identity = unknown
type unit_identity = unknown

export type object = {
    read type: namefield.object,
	read identity: unknown,
    
    read new: <T,U> (self: T, that: U?, ...any) -> construct<T,U>,
    read renew: <T,U> (self: T, that: U?) -> T,

    read equals: (this: unknown, that: any) -> boolean,
    read is: (self: unknown, that: namefield.names | string) -> boolean,
    read base: <T> (self: unknown, expected: namefield.names|string|nil) -> T?,
    read toggle_host: <T> (self: unknown, f: (new: T) -> ()) -> (),
    read require: (identity: unknown) -> object?
}

export type randentity = construct<{
    read type: namefield.randentity,
    input: unknown,
    output: randentity?,

    read get_now: (self: randentity, prebake: boolean?) -> randentity,

    read to_sha256: (self: randentity) -> (),
    read to_blake3: (self: randentity) -> (),
}, object>

export type enumobject = construct<{
    read type: namefield.enumobject,
    read get_enums_list: (self: enumobject) -> {[unknown]: enumitem},                        
    read get_enums_count: (self: enumobject) -> number,
    read get_enums_name: (...enumitem) -> ...string,

    read assert_is_my_enumitem: (self: enumobject, that: unknown) -> boolean,
    read is_my_enumitem: (self: enumobject, that: enumitem) -> boolean,
} & nameable , object>

export type enumitem<T = enumobject?> = construct<{
    read type: namefield.enumitem,
    read hashlink: string,
    read enum: T,

    read child: (self: enumitem, of: enumobject) -> boolean
} & nameable, object>

export type enumitem_default = enumitem<enum_default>
export type enum_default = construct<{
    read Unknown: enumitem_default,
    read Any: enumitem_default,
}, enumobject>

export type enumitem_bb_variant = enumitem<enum_bb_variant>
export type enum_bb_variant = construct<{
    read AABB: enumitem_bb_variant,
    read OBB: enumitem_bb_variant,
}, enumobject>

export type enumitem_direction_variant = enumitem<enum_direction_variant>
export type enum_direction_variant = construct<{
    read Top: enumitem_direction_variant,
    read Bottom: enumitem_direction_variant,
    read Left: enumitem_direction_variant,
    read Right: enumitem_direction_variant,
    read Front: enumitem_direction_variant,
    read Back: enumitem_direction_variant,
}, enumobject>

export type enumitem_asset_state_variant = enumitem<enum_asset_state_variant>
export type enum_asset_state_variant = construct<{
    read Fail: enumitem_asset_state_variant,
	read Loaded: enumitem_asset_state_variant,
	read Making: enumitem_asset_state_variant,
	read Reload: enumitem_asset_state_variant,
	read Never: enumitem_asset_state_variant,
}, enumobject>

export type enumitem_message_notification_variant = enumitem<enum_message_notification_variant>
export type enum_message_notification_variant = construct<{
    read Invoke: enumitem_message_notification_variant,
    read Await: enumitem_message_notification_variant,
}, enumobject>

export type enumitem_asset_require_notification_variant = enumitem<enum_asset_require_notification_variant>
export type enum_asset_require_notification_variant = construct<{
    read Failure: enumitem_asset_require_notification_variant,
    read Loading: enumitem_asset_require_notification_variant,
    read Successful: enumitem_asset_require_notification_variant,
}, enumobject>

export type enumitem_connection_state_variant = enumitem<enum_connection_state_variant>
export type enum_connection_state_variant = construct<{
    read Normal: enumitem_connection_state_variant,
    read ChangingCallOn: enumitem_connection_state_variant,
}, enumobject>

export type enumitem_controller_notification_variant = enumitem<enum_controller_notification_variant>
export type enum_controller_notification_variant = construct<{
    read Continue: enumitem_controller_notification_variant,
    read Pause: enumitem_controller_notification_variant,
    read Reset: enumitem_controller_notification_variant,
}, enumobject>

export type enumitem_instance_notification_variant = enumitem<enum_instance_notification_variant>
export type enum_instance_notification_variant = construct<{
    read Destroyed: enumitem_instance_notification_variant,
    read Newwie: enumitem_instance_notification_variant,
    read Changed: enumitem_instance_notification_variant,
    read Nullified: enumitem_instance_notification_variant,
}, enumobject>

export type enumitem_node_notification_variant = enumitem<enum_node_notification_variant>
export type enum_node_notification_variant = construct<{
    read ProcessStepped: enumitem_node_notification_variant,
    read SimulationStepped: enumitem_node_notification_variant,
    read AttributeAdded: enumitem_node_notification_variant,
    read AttributeRemoved: enumitem_node_notification_variant,
}, enumobject>

export type enumitem_notification_variant = enumitem<enum_notification_variant>
export type enum_notification_variant = construct<{
    read Signal: enumitem_notification_variant,
    read Initialize: enumitem_notification_variant,
    read Setup: enumitem_notification_variant,
    read PreRelease: enumitem_notification_variant,
    read ConnectionAdded: enumitem_notification_variant,
    read ConnectionRemoved: enumitem_notification_variant,
    read Stepped: enumitem_notification_variant,
    read Emit: enumitem_notification_variant,
}, enumobject>

export type enumitem_value_notification_variant = enumitem<enum_value_notification_variant>
export type enum_value_notification_variant = construct<{
	read LazyValueNew: enumitem_value_notification_variant,
	read LazyValueGet: enumitem_value_notification_variant,
	read LazyValueRemoved: enumitem_value_notification_variant,
	read LazyValueChanged: enumitem_value_notification_variant,
	read ValueNew: enumitem_value_notification_variant,
	read ValueGet: enumitem_value_notification_variant,
	read ValueRemoved: enumitem_value_notification_variant,
	read ValueChanged: enumitem_value_notification_variant,
}, enumobject>

export type enumitem_asset_variant = enumitem<enum_asset_variant>
export type enum_asset_variant = construct<{
    read Model: enumitem_asset_variant,
	read Sound: enumitem_asset_variant,
	read Image: enumitem_asset_variant,
}, enumobject>

export type enumitem_operational_variant = enumitem<enum_operational_variant>
export type enum_operational_variant = construct<{
    read Working: enumitem_operational_variant,
	read Paused: enumitem_operational_variant,
	read Corrupted: enumitem_operational_variant,
}, enumobject>

export type enumitem_user_data_variant = enumitem<enum_user_data_variant>
export type enum_user_data_variant = construct<{
    
}, enumobject>

export type enumitem_connection_mode_variant = enumitem<enum_connection_mode_variant>
export type enum_connection_mode_variant = construct<{
    read Ever: enumitem_connection_mode_variant,
    read Once: enumitem_connection_mode_variant,
    read Disconnected: enumitem_connection_mode_variant
}, enumobject>

export type enumitem_disposable_state_variant = enumitem<enum_disposable_state_variant>
export type enum_disposable_state_variant = construct<{
    read PreRelease: enumitem_disposable_state_variant,
    read Normal: enumitem_disposable_state_variant,
    read Released: enumitem_disposable_state_variant,
    read New: enumitem_disposable_state_variant,
}, enumobject>





export type notification<T...=...unknown> = construct<{
    read type: namefield.notification,
    pack: {unknown},

    read get_packed: (self: notification<T...>) -> T...
} & expected_calltype<enumitem<any>>, object>



export type runtimeobject = construct<{
    read type: namefield.runtimeobject, 
    created_at: DateTime,
 
    read get_notification_event: (self: runtimeobject) -> face<notification>,
    read toggle_notice: (self: runtimeobject, f: (notification: notification) -> ()|thread|runtimeobject, call_on: enumitem?, mode: enumitem?) -> (),
    read notificate: (self: runtimeobject, notification: notification?) -> (),
}, object>



export type face<T... = ...face_default_type> = construct<{
    read type: namefield.face,

    read connect: (self: face<T...>, f: ((T...) -> ())|thread|runtimeobject, call_on: enumitem?) -> connection,
    read once: (self: face<T...>, f: ((T...) -> ())|thread|runtimeobject, call_on: enumitem?) -> connection,
    read wait: (self: face<T...>, call_on: enumitem?) -> T...,
    read invoke: (self: face<T...>, notification: notification?) -> ()
} & linkable<face<T...>, connection>, runtimeobject> 

export type connection = construct<{
    read type: namefield.connection,
    state: enumitem_connection_mode_variant,

    read disconnect: (self: connection) -> (),
    read reload: (self: connection) -> (),
} & linkable<connection, face> & expected_calltype<enumitem<any>>, runtimeobject>

export type value<T = unknown> = construct<{
    read type: namefield.value,

    read get_value: (self: value<T>) -> T?,                    
    read set_value: (self: value<T>, new: T?) -> (),            
    read get_value_default: (self: value<T>) -> T?,             
    read set_value_default: (self: value<T>, new: T?) -> (),    
}, runtimeobject>

export type timer = construct<{
    read type: namefield.timer,
    seconds: number,
    previous_stepped: DateTime,

    read schedule: (self: timer) -> (),
    read wait: (self: timer) -> (),
    read bind: (self: timer, f: (()->())|thread) -> connection,
    
    read get_delta: (self: timer) -> number,
} & iterations<number> & modifier<number> & controllable<timer>, runtimeobject>

export type maybe = construct<{
    read type: namefield.maybe,

    read extract: <T> (self: maybe, it: unknown, make: () -> T) -> T,
    read erase: (self: maybe, it: unknown) -> (),
    read exist: (self: maybe, it: unknown) -> boolean
}, runtimeobject>

export type reference<T = Instance> = construct<{
    read type: namefield.reference
} & instanceable<reference<T>, T>, runtimeobject>

export type controller = construct<{
    read type: namefield.controller,
    state: enumitem_controller_notification_variant
} & operatable<controller>, runtimeobject>

export type asset<T = unknown> = construct<{
    read type: namefield.asset,
    read variant: enumitem_asset_variant|enumitem_default,
    read rid: number,
    state: enumitem_asset_state_variant,

    read get_asset: (self: asset<T>) -> T?
}, runtimeobject>


export type actmapped = construct<{
    read type: namefield.actmapped,
    code: Enum.KeyCode,


} & nameable, runtimeobject>




export type parallelable = construct<{
    read type: namefield.parallelable,
    read pid: parallel_identity,
    version: number,

    read snapshot: (self: parallelable) -> (),
    read get_snapshot: <T> (self: T, version: number?) -> T?
}, runtimeobject>

export type luaumachine = construct<{
    read type: namefield.luaumachine,
    read verification: randentity,

    read require_parallel: (self: luaumachine, pid: parallel_identity) -> parallelable?
}, parallelable>





export type disposable = construct<{
    read type: namefield.disposable,

    read free: (self: disposable) -> (), 
    read queue_free: (self: disposable) -> (),
    read get_state: (self: disposable, state: enumitem) -> boolean,
    read toggle_state: (self: disposable, state: enumitem) -> ()
}, runtimeobject> 

export type attribute<T = unknown, U = Instance> = construct<{
    read type: namefield.attribute,
    sync_params: boolean,

    read get_params: (self: attribute<T,U>) -> value<T>,
    read get_current_value: (self: attribute<T,U>) -> T?
} & nameable<string> & referenceable<attribute<T,U>,U?>, disposable>

export type node<T = Instance> = construct<{
    read type: namefield.node,

    read get_attribute_list: (self: node<T>) -> {value},
    read get_attribute: (self: node<T>, name: string) -> value?,
    read add_attribute: (self: node<T>, name: string) -> value,
    read remove_attribute: (self: node<T>, name: string) -> () 
} & referenceable<node<T>,T?> , disposable>

export type noderuntime<T = Instance> = construct<{
    read type: namefield.noderuntime,
    last_delta: number,
    last_emit: number,

    process: (self: noderuntime<T>, delta: number) -> (),
    simulate: (self: noderuntime<T>, delta: number) -> (),

    read get_runtime: (self: noderuntime<T>) -> timer,
}, node<T>>

export type user = construct<{
    read type: namefield.user,
    unit: unit_identity,
    
    read request_data: <T> (self: user, of: enumitem_user_data_variant) -> userdata<T>,
}, runtimeobject>

export type userdata<T = {}> = construct<{
    read type: namefield.userdata,
    read stored: T,
    read datatype: enumitem_user_data_variant,

    read request_self_new: (self: userdata<T>) -> userdata<T>,
    read request_update: (self: userdata<T>) -> boolean
}, runtimeobject>

export type channel <T = unknown> = construct<{
    read type: namefield.channel,
    peers: {user},


}, node<RemoteEvent>>




export type inventory = construct<{
    read type: namefield.inventory,
    read owner: unit,
    items: {item},

    read get_items_with_type: (self: inventory, type: string|namefield.names) -> {item}
}, node<Configuration>>

export type item = construct<{
    read type: namefield.item,

    equipable: boolean,
    dropable: boolean,
    deliverable: boolean,
} & nameable, node<Model>>

export type weapon = construct<{
    read type: namefield.weapon,

    statistics: weaponstat,
    
    
    muzzle: reference<Attachment>,
    chamber: reference<Attachment>,



}, item>

export type weaponvfx = construct<{
    read type: namefield.weaponvfx



}, record>

type sfx = () -> AudioPlayer

export type weaponsfx = construct<{
    read type: namefield.weaponsfx,

    primary: sfx?,
    secondary: sfx?,
    special: sfx?,
    action: sfx?,

    reload: sfx?,
    check: sfx?,



}, record>

export type mechasfx = construct<{
    read type: namefield.mechasfx,

    pull: {sfx},
    eject: {sfx},
    release: {sfx},
    relax: {sfx},

    read get_random: (self: mechasfx) -> AudioPlayer?,
}, record>

export type weaponstat = construct<{
    read type: namefield.weaponstat,

    has_primary: boolean,
    has_secondary: boolean,
    has_special: boolean,
    has_action: boolean,

    damage: number,



    reload_speed: number,
    attack_speed: number,

    max_hit_distance: number,


}, record>



export type config<T = unknown> = construct<{
    read type: namefield.config,
    updateable: boolean,

    read update_to_newest: (self: config<T>) -> ()
}, value<T>>








export type unit = construct<{
    read type: namefield.unit,
    read uid: unit_identity,

    equipped: {item}
}, node<PVInstance>>








export type service = construct<{
    read type: namefield.service,
    read code: enumitem,

    read log: (self: service, ...any) -> (),
} & nameable, runtimeobject>









export type record = construct<{
    read type: namefield.record,

    read immutable: (self: record) -> record,
    read is_immutable: (self: record) -> boolean,
    read clone: <T> (self: T) -> T,

    read get_dictionary: (self: record) -> {[string]: number|boolean|string},
    read each: <T> (self: record, type: string, f: (value: T) -> T) -> ()
}, object>

export type result<T = unknown> = construct<{
    read type: namefield.result,
    state: boolean,
    result: T,

    read call_of: <Y,U> (f: (...Y) -> U, ...Y) -> result,       write call_of: (f: (...unknown) -> unknown) -> result
}, record>

export type boundbox = construct<{
    read type: namefield.boundbox,
    variant: enumitem_bb_variant,
    half: Vector3,
    min: Vector3,
    max: Vector3,

    read is_inside: (self: boundbox, ...boundbox|BasePart|Model) -> boolean,
    read is_belong: (self: boundbox, ...vertex) -> boolean,
    read is_intersection: (self: boundbox, ...boundbox|BasePart|Model) -> boolean,

    read to_region3: (self: boundbox) -> Region3,
    read to_region3int16: (self: boundbox) -> Region3int16,
    read to_part: (self: boundbox) -> Part,
    read to_aabb: (self: boundbox) -> (Vector3, Vector3),
    read to_obb: (self: boundbox) -> (Vector3, Vector3, Vector3, Vector3, Vector3, Vector3),

    read from_region3: (from: Region3) -> boundbox,
    read from_region3int16: (from: Region3int16) -> boundbox,
    read from_aabb: (min: Vector3, max: Vector3) -> boundbox,
    read from_middle: (variant: enumitem_bb_variant, ...boundbox|BasePart|Model) -> boundbox,
    read from_invarianted: (variant: enumitem_bb_variant, ...boundbox|BasePart|Model) -> {boundbox},
    read from: (variant: enumitem_bb_variant, ...boundbox|BasePart|Model) -> boundbox,

    read get_cover: (self: boundbox, ...boundbox|BasePart|Model) -> boundbox,
    read get_invariant: (self: boundbox, variant: enumitem_bb_variant?) -> boundbox,
    read get_mininum_translation: (self: boundbox, ...boundbox|BasePart|Model) -> vertex,
    read get_origin_directions: (self: boundbox) -> directions,
    read get_axis: (self: boundbox) -> directions,
    read get_origin_size: (self: boundbox) -> Vector3,

    read get_recalculated: (self: boundbox) -> boundbox
}, cube>

export type triangle = construct<{
    read type: namefield.triangle,

    read from_vector3: (self: triangle, right: Vector3?, up: Vector3?, front: Vector3?) -> triangle
} & centerable<triangle> & axisable<vertex> & normals<triangle> & math_operations<triangle, triangle>, record>

export type quad = construct<{
    read type: namefield.quad,
    left: triangle,
    right: triangle,
} & centerable<quad> & normals<quad> & math_operations<quad, quad>, record>

export type directions = construct<{
    read type: namefield.directions,
} & axisable<Vector3> & vector_operations<directions, directions> & math_operations<directions, directions>, record>

export type vertex = construct<{
    read type: namefield.vertex,
    normal: Vector3,
    mtv_min: number,

    read from_global_point: (self: vertex, position: Vector3?) -> vertex,
    read from_local_point: (self: vertex, local_position: Vector3?, position: Vector3?) -> vertex
} & positioned<Vector3> & math_operations<vertex, vertex>, record>

export type cube = construct<{
    read type: namefield.cube,
    top: Vector3,
    bottom: Vector3,
    left: Vector3,
    right: Vector3,
    front: Vector3,
    back: Vector3,

    read get_corners: (self: boundbox) -> {vertex},
    read get_direction: (self: boundbox, direction: enumitem_direction_variant) -> Vector3,
    read get_quad: (self: boundbox, direction: enumitem_direction_variant) -> quad,
} & centerable<cube> & math_operations<cube, cube> & vector_operations<cube,cube>, record>








--runtype_line
export type typeobject = extend<{

}>

return nil :: never