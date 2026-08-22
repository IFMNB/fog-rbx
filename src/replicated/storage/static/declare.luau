--!strict 
-- #10
const namefield = require("./namefield")




export type construct<T = {}, U = object> = T & U
export type nameof<T = string> = T|string
--export type extend<T = {}> = construct<T>
--export type prototype<T = {}, U = object> = construct<setmetatable<T, { __index: U }>, U>

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
export type math_operations<T=unknown,U... = ()> = {
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
export type vector_operations<T=unknown,U... = ()> = {
    read to_cframe: (self: T) -> CFrame,
    read to_vector: (self: T) -> vector
}
export type positioned<T=vector> = {
    position: T
}
export type normals<T=unknown, U=vector> = {
    read get_normal_geometric: (self: T) -> U,
    read get_normal_interpolated: (self: T) -> U,
}
export type linkable<T=unknown,U=unknown> = {
    read link: (self: T, that: U) -> (),
    read unlink: (self: T, that: U) -> ()
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
export type axisable<T = unknown> = {
    right: T,
    up: T,
    front: T
}
export type centerable<T = unknown> = {
    read get_center: (self: T) -> vector
}
export type switchable<T = unknown> = {
    enabled: boolean
}
export type rotateable<T = unknown> = {
    rotation: directions
}
export type invokeable<T = unknown, U... = (), E... = ()> = {
    read invoke: (self: T, U...) -> E...
}
export type asyncable = {
    time_to_hold: number,
    time_to_response: number,
    attempts: number,
}
export type stateable <T = unknown, U = unknown> = {
    read get_state_machine: (self: T) -> statemachine<U>
}
export type channel_internal_reference = Folder & {
    read send: RemoteEvent,
    read await: RemoteFunction,
    read async: RemoteFunction,
    read build: RemoteFunction
}

export type observer_pack <T = unknown> = ((identity: object_identity)->())|thread|observer<T>|string

export type remote_identity = string
export type parallel_identity = unknown
export type unit_identity = unknown
export type user_identity = unknown
export type object_identity = unknown

export type object = {
    read type: namefield.object,
	read identity: object_identity,
    
    read new: <T,U> (self: T, that: U?) -> construct<T,U>,
    read renew: <T> (self: T, that: --[=[*based-on-base-object*]=] {[string]: unknown}?) -> construct<T, {}>,

    read equals: (this: unknown, that: any) -> boolean,
    read is: (self: unknown, that: namefield.names | string) -> boolean,
    read base: <T> (self: unknown, expected: namefield.names|string|nil) -> T?,
    read host: <T> (self: unknown, f: (new: T) -> ()) -> (),
    read rebuild: <T> (self: T, that: {[string]: unknown}) -> T,
    read require: <T> (identity: object_identity, assert: namefield.names|string?) -> T
}

export type enumobject = construct<{
    read type: namefield.enumobject,
    
    read get_enums_list: (self: enumobject) -> {[unknown]: enumitem},                        
    read get_enums_count: (self: enumobject) -> number,
    read get_enums_name: (...enumitem) -> ...string,
    read get_enumitem_by_hashlink: (hashlink: string) -> enumitem<>,
    read assert_is_my_enumitem: (self: enumobject, that: unknown) -> boolean,
    read is_my_enumitem: (self: enumobject, that: enumitem) -> boolean,
} & nameable , object>

export type enumitem<T = enumobject?> = construct<{
    read type: namefield.enumitem,
    read hashlink: string,
    read enum: T,
} & nameable, object>


export type notification<T = enumitem<any>> = construct<{
    read type: namefield.notification,
} & expected_calltype<T>, object>

export type package<T = enumitem<any>, U = unknown> = construct<{
    read type: namefield.package,
    read pack: {U}, -- #11
}, notification<T>>

export type tasky<current --[=[*based-on-current-realization*]=]> = construct<{
    read type: namefield.tasky,

    read deploy: (self: tasky<current>, path: string) -> (),
    read get_online: (self: tasky<current>) -> {[string]: current},
    read get_offline: (self: tasky<current>) -> {[string]: current},
    read get_existed: (self: tasky<current>, path: string) -> current?,
    read is_exists: (self: tasky<current>, path: string) -> boolean
} & asyncable, object>

export type user = construct<{
    read type: namefield.user,
    read uid: number,
    
    read request_data: <T> (self: user, of: enumitem_user_data_require) -> userdata<result<T>>,
    read get_unit: (self: user) -> unit?,
    read set_unit: (self: user, to: unit?) -> (),


    read get_local_user: (self: user) -> user,
    read get_player: (self: user) -> reference<Player?>
}, object>

export type runtimeobject = construct<{
    read type: namefield.runtimeobject,
    created_at: DateTime,
}, object>

export type maybe = construct<{
    read type: namefield.maybe,

    read extract: <T> (self: maybe, it: unknown, make: () -> T) -> T,
    read erase: (self: maybe, it: unknown) -> (),
    read exist: (self: maybe, it: unknown) -> boolean
}, runtimeobject>

export type userdata<T = unknown> = construct<{
    read type: namefield.userdata,
    read stored: T,
    read datatype: enumitem_user_data_require,
}, runtimeobject>

export type randentity = construct<{
    read type: namefield.randentity,
    input: unknown,
    output: randentity?,

    read get_now: (self: randentity, prebake: boolean?) -> randentity,

    read to_sha256: (self: randentity) -> (),
    read to_blake3: (self: randentity) -> (),
}, runtimeobject>


export type observer<T = enumitem<any>> = construct<{
    read type: namefield.observer,
    
    read subscribe: (self: observer<T>, on: T|enumobject, mode: enumitem_connection_variant, ...observer_pack<T>) -> () -> (),
    read notice: (self: observer<T>, on: package<{T}|T, package<enumitem_connection_variant, observer_pack<T>>>) -> () -> (),
    read notificate: (self: observer<T>, notification: T|{T}|notification<T|{T}>) -> (),
}, runtimeobject>

export type event<T = enumitem<any>, U... = ...unknown> = construct<{
    read type: namefield.event,

    read connect: <T0> (self: event<T,U...>, on: T|enumitem_default_variant, f: ((U...) -> ())|thread|observer<T>) -> connection<T>,
    read once: <T0> (self: event<T,U...>, on: T|enumitem_default_variant, f: ((U...) -> ())|thread|observer<T>) -> connection<T>,
    read wait: (self: event<T,U...>, on: T|enumitem_default_variant) -> U...,
    read invoke: (self: event<T,U...>, on: T|{T}|notification<T|{T}>, U...) -> (),
} & expected_calltype<T?> & linkable<event<T,U...>, connection>, observer<T>> 

export type connection<T = enumitem<any>, U... = ()> = construct<{
    read type: namefield.connection,
    state: enumitem_connection_variant,
    count: number,

    read disconnect: (self: connection<T,U...>) -> (),
} & invokeable<connection<T,U...>,U...> & linkable<connection<T,U...>, event> & expected_calltype<T>,
observer<T|enumitem_connection_variant|enumitem_setup_notification|enumitem_action_notification>>

export type value<T = unknown> = construct<{
    read type: namefield.value,

    read get_value: (self: value<T>) -> T?,                    
    read set_value: (self: value<T>, new: T?, default: boolean?) -> (),
    read on_operation_event: (self: value<T>) -> event<enumitem_operation_variant>
}, observer<enumitem_operation_variant>>

export type timer = construct<{
    read type: namefield.timer,
    seconds: number,
    previous_stepped: DateTime,

    read schedule: (self: timer) -> (),    
    read get_delta: (self: timer) -> number,
} & iterations<number> & modifier<number> & controllable<timer>, observer<enumitem_action_notification>>

export type reference<T = Instance> = construct<{
    read type: namefield.reference
} & instanceable<reference<T>, T>, observer<enumitem_operation_variant>>

export type channel <T = enumitem_network_replication, U... = ...unknown, E... = ...unknown> = construct<{
    read type: namefield.channel,
    read reference: reference<channel_internal_reference?>,
    read event: event<T,E...>,

    echo: boolean,

    read send: (self: channel<T,U...,E...>, to: T, U...) -> (),
    read sync: (self: channel<T,U...,E...>, to: T, U...) -> {[user]: (() -> E...)?},
    read async: (self: channel<T,U...,E...>, to: T, U...) -> {[user]: (() -> E...)?},

    read set_await_response: (self: channel<T,U...,E...>, to: T, f: ((U...) -> E...)? ) -> (),
    read get_await_response: (self: channel<T,U...,E...>, to: T) -> ((U...) -> E...)?,

    read set_async_response: (self: channel<T,U...,E...>, to: T, f: ((U...) -> object)?) -> (),
    read get_async_response: (self: channel<T,U...,E...>, to: T) -> ((U...) -> object)?,

    read get_peer: (self: channel<T,U...,E...>) -> {user},
    read set_peer: (self: channel<T,U...,E...>, of: user, to: boolean?) -> (),
    read is_peer: (self: channel<T,U...,E...>, of: user) -> boolean,
    read request_from: (self: channel<T,U...,E...>) -> user?,

    read get_variant: (self: channel<T,U...,E...>) -> enumitem_network_replication?,
    read set_variant: (self: channel<T,U...,E...>, to: enumitem_network_replication?) -> (),
    read is_variant: (self: channel<T,U..., E...>, of: enumitem_network_replication) -> boolean
} & asyncable & switchable<channel<T,U...,E...>>, observer<enumitem_channel_notification>>

export type signal<T... = ...unknown> = construct<{
    read type: namefield.signal,

    read get_signal_event: (self: signal<T...>) -> event<enumitem_action_notification, T...>
}, reference<RBXScriptSignal<T...>>>

export type controller = construct<{
    read type: namefield.controller,
    state: enumitem_controller_state
} & operatable<controller>, observer<enumitem_controller_state>>

export type asset<T = unknown> = construct<{
    read type: namefield.asset,
    read variant: enumitem_asset_type_variant|enumitem_default_variant,
    read rid: number,
    state: enumitem_state,

    read get_asset: (self: asset<T>) -> T?
}, observer<enumitem_state>>

export type statemachine<T = unknown> = construct<{
    read type: namefield.statemachine,

    read get_state: (self: statemachine<T>, of: T) -> boolean,
    read set_state: (self: statemachine<T>, of: T, to: boolean?) -> (),
    read enable_state: (self: statemachine<T>, of: T, to: boolean) -> ()
}, observer<enumitem_operation_variant>>


export type disposable<T = enumitem<any>> = construct<{
    read type: namefield.disposable,

    read free: (self: disposable<T>) -> (), 
    read queue_free: (self: disposable<T>) -> (),
}, observer<T|enumitem_disposable_notification>> 

export type maid = construct<{
    read type: nameof<"maid">,

    read add_object: (self: maid, that: connection|disposable|RBXScriptConnection) -> (),
    read add_key: <T> (self: maid, of: {[T]: unknown}, key: T) -> (),

    read remove_object: (self: maid, that: connection|disposable) -> (),
    read remove_key: <T> (self: maid, of: {[T]: unknown}, key: T) -> (),
}, disposable>

export type node<T = Instance, U = enumitem<any>> = construct<{
    read type: namefield.node,
    read rid: remote_identity,

    auto_free_on_destroying: boolean,

    read get_attribute_list: (self: node<T,U>) -> {[string]: value},
    read get_attribute: (self: node<T,U>, name: string) -> value?,
    read add_attribute: (self: node<T,U>, name: string) -> value,
    read remove_attribute: (self: node<T,U>, name: string) -> (),
} & referenceable<node<T,U>,T?> , disposable<U>>

export type noderuntime<T = Instance, U = enumitem<any>> = construct<{
    read type: namefield.noderuntime,
    last_delta: number,
    last_emit: number,

    read process: (self: noderuntime<T,U>, delta: number) -> (),
    read simulate: (self: noderuntime<T,U>, delta: number) -> (),
    read get_timer: (self: noderuntime<T,U>) -> timer,
}, node<T,U|enumitem_noderuntime_notification>>

export type attribute<T = unknown, U = Instance> = construct<{
    read type: namefield.attribute,
    sync_params: boolean,

    read get_params: (self: attribute<T,U>) -> value<T>,
    read get_current_value: (self: attribute<T,U>) -> T?
} & nameable<string> & referenceable<attribute<T,U>,U?>, disposable<enumitem_attribute_notification>>

export type input = construct<{
    read type: namefield.input,

    strengh: number,
    duration: number,
    clamped: boolean,
    pressed: boolean,

    read get_code: (self: input) -> {Enum.KeyCode},
    read set_code: (self: input, of: Enum.KeyCode, to: boolean?) -> (),

    read get_related: (self: input) -> enumitem_action_map_variant?,
    read set_related: (self: input, new: enumitem_action_map_variant?) -> (),
}, disposable<enumitem_input_notification>>






export type inventory<T = item> = construct<{
    read type: namefield.inventory,
    read owner: unit,
    read items: {item},

    can_insert_items: boolean,
    can_remove_items: boolean,

    read get_items_with_type: (self: inventory<T>, type: string|namefield.names) -> {T},
    read get_items: (self: inventory<T>) -> {T},
    read insert: (self: inventory<T>, that: T) -> (),
    read remove: (self: inventory<T>, that: T) -> (),
    read is_in_inventory: (self: inventory<T>, that: T) -> boolean,
}, node<Configuration>>

export type item = construct<{
    read type: namefield.item,
    
    equipable: boolean,
    dropable: boolean,
    deliverable: boolean,
} & nameable, node<Model>>

export type weapon = construct<{
    read type: namefield.weapon,
    ammo: number,

    statistics: weaponstat,
    muzzle: reference<Attachment>,
    chamber: reference<Attachment>,

    read fire: (self: weapon) -> boolean,
    read aim: (self: weapon) -> boolean,
    read special: (self: weapon) -> boolean,
    read action: (self: weapon) -> boolean,


}, item>


export type config<T = unknown, U = enumitem_config_require> = construct<{
    read type: namefield.config,
    related: U,
    auto_updateable: boolean,

    read update_to_newest: (self: config<T>) -> ()
}, value<T>>





export type physx = construct<{
    read type: namefield.physx,
    mode: enumitem_physx_mode_variant,
    stats: physics,

} & rotateable<physx> & positioned<physx> & controllable<physx>, noderuntime<PVInstance>>







export type unit = construct<{
    read type: namefield.unit,

    can_equip_items: boolean,
    speed: number,

    read get_description: (self: unit) -> unitdescription,
    read set_description: (self: unit, to: unitdescription) -> (),

    read get_equipped: (self: unit) -> {item},
    read set_equipped: (self: unit, that: item?) -> (),
    read is_equipped: (self: unit, that: item) -> boolean,

    read get_inventory: (self: unit) -> inventory?,
    read set_inventory: (self: unit, to: inventory?) -> ()
} & stateable<unit, enumitem_unit_state>, noderuntime<PVInstance>>

export type unitdescription = construct<{
    read type: nameof<"unitdescription">,

    read max_health: number,
    read regeneration: number,
    
    read speed: number,
    read run_speed: number,
    read max_speed: number,

    read jump_height: number,
    
}, runtimeobject>




export type service<T = enumitem<any>> = construct<{
    read type: namefield.service,
    read code: T,

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

export type result<T = unknown, U... = ...unknown> = construct<{
    read type: namefield.result,
    read state: boolean,
    read result: T,

    read unpack: (self: result<T,U...>) -> U...
}, record>

export type boundbox = construct<{
    read type: namefield.boundbox,
    variant: enumitem_bb_variant,
    half: vector,
    min: vector,
    max: vector,

    read is_inside: (self: boundbox, ...boundbox|BasePart|Model) -> boolean,
    read is_belong: (self: boundbox, ...vertex) -> boolean,
    read is_intersection: (self: boundbox, ...boundbox|BasePart|Model) -> boolean,

    read to_region3: (self: boundbox) -> Region3,
    read to_region3int16: (self: boundbox) -> Region3int16,
    read to_part: (self: boundbox) -> Part,
    read to_aabb: (self: boundbox) -> (vector, vector),
    read to_obb: (self: boundbox) -> (vector, vector, vector, vector, vector, vector),

    read from_region3: (from: Region3) -> boundbox,
    read from_region3int16: (from: Region3int16) -> boundbox,
    read from_aabb: (min: vector, max: vector) -> boundbox,
    read from_middle: (variant: enumitem_bb_variant, ...boundbox|BasePart|Model) -> boundbox,
    read from_invarianted: (variant: enumitem_bb_variant, ...boundbox|BasePart|Model) -> {boundbox},
    read from: (variant: enumitem_bb_variant, ...boundbox|BasePart|Model) -> boundbox,

    read get_cover: (self: boundbox, ...boundbox|BasePart|Model) -> boundbox,
    read get_invariant: (self: boundbox, variant: enumitem_bb_variant?) -> boundbox,
    read get_mininum_translation: (self: boundbox, ...boundbox|BasePart|Model) -> vertex,
    read get_origin_directions: (self: boundbox) -> directions,
    read get_axis: (self: boundbox) -> directions,
    read get_origin_size: (self: boundbox) -> vector,

    read get_recalculated: (self: boundbox) -> boundbox
}, cube>

export type triangle = construct<{
    read type: namefield.triangle,

    read from_vector: (self: triangle, right: vector?, up: vector?, front: vector?) -> triangle
} & centerable<triangle> & axisable<vertex> & normals<triangle> & math_operations<triangle, triangle>, record>

export type quad = construct<{
    read type: namefield.quad,
    left: triangle,
    right: triangle,
} & centerable<quad> & normals<quad> & math_operations<quad, quad>, record>

export type directions = construct<{
    read type: namefield.directions,
} & axisable<vector> & vector_operations<directions, directions> & math_operations<directions, directions>, record>

export type vertex = construct<{
    read type: namefield.vertex,
    normal: vector,
    mtv_min: number,

    read from_global_point: (self: vertex, position: vector?) -> vertex,
    read from_local_point: (self: vertex, local_position: vector?, position: vector?) -> vertex
} & positioned<vector> & math_operations<vertex, vertex>, record>

export type cube = construct<{
    read type: namefield.cube,
    top: vector,
    bottom: vector,
    left: vector,
    right: vector,
    front: vector,
    back: vector,

    read get_corners: (self: boundbox) -> {vertex},
    read get_direction: (self: boundbox, direction: enumitem_direction_variant) -> vector,
    read get_quad: (self: boundbox, direction: enumitem_direction_variant) -> quad,
} & centerable<cube> & math_operations<cube, cube> & vector_operations<cube,cube>, record>

export type weaponstat = construct<{
    read type: namefield.weaponstat,
    ammo_variant: enumitem_ammo_variant,

    has_primary: boolean,
    has_secondary: boolean,
    has_special: boolean,
    has_action: boolean,

    damage: number,
    distance_modificator: number,
    max_ammo: number,
    min_ammo: number,


    reload_speed: number,
    attack_speed: number,

    max_hit_distance: number,


}, record>

export type physics = construct<{
    read type: namefield.physics,
    read locked_rotation: {enumitem_direction_variant},
    read locked_position: {enumitem_direction_variant},

    read is_locked_rotation: (self: physics, variant: enumitem_direction_variant?) -> boolean,
    read is_locked_position: (self: physics, variant: enumitem_direction_variant?) -> boolean,
    read is_locked_both: (self: physics, variant: enumitem_direction_variant?) -> boolean
}, record>


export type enumitem_default_variant = enumitem<enum_default_variant>
export type enum_default_variant = construct<{
    read Unknown: enumitem_default_variant,
    read Any: enumitem_default_variant,
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

export type enumitem_input_notification = enumitem<enum_input_notification>
export type enum_input_notification = construct<{
    read CodeAdded: enumitem_input_notification,
    read CodeRemoved: enumitem_input_notification,
    read Pressed: enumitem_input_notification,
    read Clamped: enumitem_input_notification,
    read Unpressed: enumitem_input_notification,
    read Unclampled: enumitem_input_notification,
    read RelatedChanged: enumitem_input_notification,
    read RelatedNullified: enumitem_input_notification
}, enumobject>

export type enumitem_state = enumitem<enum_state>
export type enum_state = construct<{
    read Failure: enumitem_state,
    read Loading: enumitem_state,
    read Successful: enumitem_state,
    read Nothing: enumitem_state,
}, enumobject>

export type enumitem_controller_state = enumitem<enum_controller_state>
export type enum_controller_state = construct<{
    read Continue: enumitem_controller_state,
    read Pause: enumitem_controller_state,
    read Reset: enumitem_controller_state,
}, enumobject>

export type enumitem_operation_variant = enumitem<enum_operation_variant>
export type enum_operation_variant = construct<{
    read Get: enumitem_operation_variant,
    read Remove: enumitem_operation_variant,
    read New: enumitem_operation_variant,
    read Change: enumitem_operation_variant,
    read Null: enumitem_operation_variant,
}, enumobject>

export type enumitem_noderuntime_notification = enumitem<enum_noderuntime_notification>
export type enum_noderuntime_notification = construct<{
    read Process: enumitem_noderuntime_notification,
    read Simulation: enumitem_noderuntime_notification,
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
    read Installed: enumitem_setup_notification
}, enumobject>

export type enumitem_unit_state = enumitem<enum_unit_state>
export type enum_unit_state = construct<{
    read Ragdolled: enumitem_unit_state,
    read Alive: enumitem_unit_state,
    read Dead: enumitem_unit_state,
    read Moving: enumitem_unit_state,
    read Jumped: enumitem_unit_state,
    read Flying: enumitem_unit_state,
    read Running: enumitem_unit_state,
    read Lying: enumitem_unit_state,
    read Crounching: enumitem_unit_state,
    read Idle: enumitem_unit_state
}, enumobject>

export type enumitem_type_variant = enumitem<enum_type_variant>
export type enum_type_variant  = construct<{
    read Object: enumitem_type_variant,
    read Function: enumitem_type_variant,
    read Thread: enumitem_type_variant,
    read Value: enumitem_type_variant
}, enumobject>

export type enumitem_type_element_variant = enumitem<enum_type_element_variant>
export type enum_type_element_variant  = construct<{
    read Getter: enumitem_type_element_variant,
    read Setter: enumitem_type_element_variant,
    read Toggler: enumitem_type_element_variant,
    read Switcher: enumitem_type_element_variant,

    read LazyEvent: enumitem_type_element_variant,
    read LazyValue: enumitem_type_element_variant,
    read LazyObject: enumitem_type_element_variant,
    read NonElement: enumitem_type_element_variant,
}, enumobject>

export type enumitem_action_notification = enumitem<enum_action_notification>
export type enum_action_notification = construct<{
    read Signal: enumitem_action_notification,
    read Step: enumitem_action_notification,
    read Emit: enumitem_action_notification,
    read Unobservable: enumitem_action_notification,
    read Observable: enumitem_action_notification,
}, enumobject>

export type enumitem_asset_type_variant = enumitem<enum_asset_type_variant>
export type enum_asset_type_variant = construct<{
    read Model: enumitem_asset_type_variant,
	read Sound: enumitem_asset_type_variant,
	read Image: enumitem_asset_type_variant,
}, enumobject>

export type enumitem_operational_variant = enumitem<enum_operational_variant>
export type enum_operational_variant = construct<{
    read Work: enumitem_operational_variant,
	read Pause: enumitem_operational_variant,
	read Corrupt: enumitem_operational_variant,
}, enumobject>

export type enumitem_user_data_require = enumitem<enum_user_data_require>
export type enum_user_data_require = construct<{
    read Weaponry: enumitem_user_data_require,
    read Specialization: enumitem_user_data_require,
    read Profile: enumitem_user_data_require,
    read Perk: enumitem_user_data_require,
    read Loadout: enumitem_user_data_require,
}, enumobject>

export type enumitem_browser_require = enumitem<enum_browser_require>
export type enum_browser_require = construct<{
    read ListOfServers: enumitem_browser_require,
    read ServerInfo: enumitem_browser_require,
}, enumobject>

export type enumitem_config_require = enumitem<enum_config_require>
export type enum_config_require = construct<{
    
}, enumobject>

export type enumitem_channel_notification = enumitem<enum_channel_notification>
export type enum_channel_notification = construct<{
    read AsyncChanged: enumitem_channel_notification,
    read AsyncRemoved: enumitem_channel_notification,
    read AwaitChanged: enumitem_channel_notification,
    read AwaitRemoved: enumitem_channel_notification,
    read PeerAdded: enumitem_channel_notification,
    read PeerRemoved: enumitem_channel_notification,
    read VariantChanged: enumitem_channel_notification
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

    read PeekLeft: enumitem_action_map_variant,
    read PeekRight: enumitem_action_map_variant,

    read PickInventorySlot: enumitem_action_map_variant,
    read PickToInventoryItemInZone: enumitem_action_map_variant,
    read PickToInventoryItemOnLineOfSight: enumitem_action_map_variant,
    read PickItemInZone: enumitem_action_map_variant,
    read PickItemOnLineOfSight: enumitem_action_map_variant,

    read DoPrimary: enumitem_action_map_variant,
    read DoSecondary: enumitem_action_map_variant,
    read DoSpecial: enumitem_action_map_variant,
    read DoAction: enumitem_action_map_variant,

    read Say: enumitem_action_map_variant,
}, enumobject>

export type enumitem_network_replication = enumitem_user_data_require|enumitem_action_map_variant|enumitem_browser_require
export type enum_network_replication = enum_user_data_require|enum_action_map_variant|enum_browser_require

export type enumitem_connection_variant = enumitem<enum_connection_variant>
export type enum_connection_variant = construct<{
    read Ever: enumitem_connection_variant,
    read Once: enumitem_connection_variant,
    read Never: enumitem_connection_variant,
    read Hold: enumitem_connection_variant,
    read Skip: enumitem_connection_variant, -- -> Once 
    read Next: enumitem_connection_variant, -- -> Ever
}, enumobject>

export type enumitem_remote_variant = enumitem<enum_remote_variant>
export type enum_remote_variant = construct<{
    read AwaitResponse: enumitem_remote_variant,
    read SendedEvent: enumitem_remote_variant,
}, enumobject>

export type enumitem_physx_mode_variant = enumitem<enum_physx_mode_variant>
export type enum_physx_mode_variant = construct<{
    read Local: enumitem_physx_mode_variant,
    read Global: enumitem_physx_mode_variant
}, enumobject>

export type enumitem_disposable_notification = enumitem<enum_disposable_notification>
export type enum_disposable_notification = construct<{
    read OnRelease: enumitem_disposable_notification,
    read Released: enumitem_disposable_notification,
}, enumobject>

export type enumitem_ammo_variant = enumitem<enum_ammo_variant>
export type enum_ammo_variant = construct<{
    read ["5.8x"]: enumitem_ammo_variant,
    read ["6.4x"]: enumitem_ammo_variant,
    read ["14.4x"]: enumitem_ammo_variant,
    read ["9.3x"]: enumitem_ammo_variant,
}, enumobject>

export type enumitem_weapon_variant = enumitem<enum_weapon_variant>
export type enum_weapon_variant = construct<{
    read Ray: enumitem_weapon_variant,
    read Shell: enumitem_weapon_variant,
    read Zone: enumitem_weapon_variant,
}, enumobject>

return table.freeze {
    ["nil"] = "nil" :: "nil",
    ["number"] = "number" :: "number",
    ["string"] = "string" :: "string",
    ["boolean"] = "boolean" :: "boolean",
    ["table"] = "table" :: "table",
    ["vector"] = "vector" :: "vector",
    ["function"] = "function" :: "function",
    ["thread"] = "thread" :: "thread",
    ["userdata"] = "userdata" :: "userdata",
    ["buffer"] = "buffer" :: "buffer",

    ["roblox"] = table.freeze {
        ["AdReward"] = "AdReward" :: "AdReward",
        ["Axes"] = "Axes" :: "Axes",
        ["BrickColor"] = "BrickColor" :: "BrickColor",
        ["CatalogSearchParams"] = "CatalogSearchParams" :: "CatalogSearchParams",
        ["CFrame"] = "CFrame" :: "CFrame",
        ["Color3"] = "Color3" :: "Color3",
        ["ColorSequence"] = "ColorSequence" :: "ColorSequence",
        ["ColorSequenceKeypoint"] = "ColorSequenceKeypoint" :: "ColorSequenceKeypoint",
        ["Content"] = "Content" :: "Content",
        ["DateTime"] = "DateTime" :: "DateTime",
        ["DockWidgetPluginGuiInfo"] = "DockWidgetPluginGuiInfo" :: "DockWidgetPluginGuiInfo",
        ["Enum"] = "Enum" :: "Enum",
        ["EnumItem"] = "EnumItem" :: "EnumItem",
        ["Enums"] = "Enums" :: "Enums",
        ["Faces"] = "Faces" :: "Faces",
        ["FloatCurve"] = "FloatCurve" :: "FloatCurve",
        ["Font"] = "Font" :: "Font",
        ["Instance"] = "Instance" :: "Instance",
        ["NumberRange"] = "NumberRange" :: "NumberRange",
        ["NumberSequence"] = "NumberSequence" :: "NumberSequence",
        ["NumberSequenceKeypoint"] = "NumberSequenceKeypoint" :: "NumberSequenceKeypoint",
        ["OverlapParams"] = "OverlapParams" :: "OverlapParams",
        ["Path2DControlPoint"] = "Path2DControlPoint" :: "Path2DControlPoint",
        ["PathWaypoint"] = "PathWaypoint" :: "PathWaypoint",
        ["PhysicalProperties"] = "PhysicalProperties" :: "PhysicalProperties",
        ["Random"] = "Random" :: "Random",
        ["Ray"] = "Ray" :: "Ray",
        ["RaycastParams"] = "RaycastParams" :: "RaycastParams",
        ["RaycastResult"] = "RaycastResult" :: "RaycastResult",
        ["RBXScriptConnection"] = "RBXScriptConnection" :: "RBXScriptConnection",
        ["RBXScriptSignal"] = "RBXScriptSignal" :: "RBXScriptSignal",
        ["Rect"] = "Rect" :: "Rect",
        ["Region3"] = "Region3" :: "Region3",
        ["Region3int16"] = "Region3int16" :: "Region3int16",
        ["RotationCurveKey"] = "RotationCurveKey" :: "RotationCurveKey",
        ["Secret"] = "Secret" :: "Secret",
        ["SecurityCapabilities"] = "SecurityCapabilities" :: "SecurityCapabilities",
        ["SharedTable"] = "SharedTable" :: "SharedTable",
        ["TweenInfo"] = "TweenInfo" :: "TweenInfo",
        ["UDim"] = "UDim" :: "UDim",
        ["UDim2"] = "UDim2" :: "UDim2",
        ["UserValue"] = "UserValue" :: "UserValue",
        ["Vector2"] = "Vector2" :: "Vector2",
        ["Vector2int16"] = "Vector2int16" :: "Vector2int16",
        ["Vector3"] = "Vector3" :: "Vector3",
        ["Vector3int16"] = "Vector3int16" :: "Vector3int16",
    },
}