--!strict

const namefield = require("./namefield")

export type object = {
    read type: namefield.object,
	read identity: unknown,
    
    read new: <T,U> (self: T, that: U?, ...any) -> construct<T,U>,
    read equals: (this: unknown, that: any) -> boolean,
    read is: (self: unknown, that: namefield.names | string) -> boolean,
    read get_base: <T> (self: unknown, expected: namefield.names|string|nil) -> T?,
    read toggle_host: <T> (self: unknown, f: (new: T) -> ()) -> (),
    read require: (identity: unknown) -> object?
}

export type construct<T = {}, U = object> = T & U
export type extend<T = {}> = construct<T>
export type prototype<T = {}, U = object> = construct<setmetatable<T, { __index: U }>, U>

type f_action <T... = (), U... = ()> = (T...) -> U...
type writeable_f_action <T... = (), U... = ()> = f_action|f_action<T...>|f_action<T..., U...>
type instanceable<T = {},U = Instance> = {
    read set_instance: (self: T, to: U) -> (),                 
    read get_instance: (self: T) -> U,                         
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

export type enumobject<T = enumobject> = construct<{
    read type: namefield.enumobject,
    read Unknown: enumitem,
    read Any: enumitem,

    read get_enums_list: (self: enumobject) -> {enumitem},                        
    read get_enums_count: (self: enumobject) -> number,
    read get_enums_name: (...enumitem) -> ...string,
    read generate_enumitem: (self: enumobject, with_name: string) -> enumitem,
    read is_my_enumitem: (self: enumobject, that: enumitem) -> boolean,
} & nameable<string>, object>

export type enumitem = construct<{
    read type: namefield.enumitem,
    read hashlink: number,
} & nameable<string>, object>

export type notification<T...=...unknown> = construct<{
    read type: namefield.notification,
    pack: {unknown},

    read get_packed: (self: notification<T...>) -> T...
} & expected_calltype<enumitem>, object>


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
    state: enumitem,

    read disconnect: (self: connection) -> (),
    read reload: (self: connection) -> (),
} & linkable<connection, face> & expected_calltype<enumitem>, runtimeobject>

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
    state: enumitem
} & operatable<controller>, runtimeobject>

export type asset<T = unknown> = construct<{
    read type: namefield.asset,
    read variant: enumitem,
    read rid: number,
    state: enumitem,

    read get_asset: (self: asset<T>) -> T?
}, runtimeobject>



export type disposable = construct<{
    read type: namefield.disposable,

    read free: (self: disposable) -> (), 
    read queue_free: (self: disposable) -> (),
    read get_state: (self: disposable, state: enumitem) -> boolean,
    read toggle_state: (self: disposable, state: enumitem) -> ()
}, runtimeobject> 

export type attribute<T = unknown, U = Instance> = construct<{
    read type: namefield.attribute,
    
    read get_params: (self: attribute<T,U>) -> value<T>
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









export type service = construct<{
    read type: namefield.service,
    read code: enumitem,

    read log: (self: service, ...any) -> (),
} & nameable, runtimeobject>

export type sharednet = construct<{
    read type: namefield.sharednet,

    read fetch_net_event: <T>(self: sharednet, event: enumitem, channel_type: enumitem?) -> face<T>,
    read send_net_event: <T>(self: sharednet, event: face<T>, T) -> ()
} & instanceable<sharednet>, service>

export type streamnet = construct<{
    read type: namefield.streamnet,

    read is_line_active: (self: streamnet, line: stream_identity_type) -> boolean,
    read invoke_line: (self: streamnet, line: stream_identity_type, ...unknown) -> boolean,
    read register_line: (self: streamnet, f: f_action) -> stream_identity_type,
    read shutdown_line: (self: streamnet, line: stream_identity_type) -> boolean
}, disposable>









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
    variant: enumitem,
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
    read from_middle: (variant: enumitem, ...boundbox|BasePart|Model) -> boundbox,
    read from_invarianted: (variant: enumitem, ...boundbox|BasePart|Model) -> {boundbox},
    read from: (variant: enumitem, ...boundbox|BasePart|Model) -> boundbox,

    read get_cover: (self: boundbox, ...boundbox|BasePart|Model) -> boundbox,
    read get_invariant: (self: boundbox, variant: enumitem?) -> boundbox,
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
    read get_direction: (self: boundbox, direction: enumitem) -> Vector3,
    read get_quad: (self: boundbox, direction: enumitem) -> quad,
} & centerable<cube> & math_operations<cube, cube> & vector_operations<cube,cube>, record>








--runtype_line
export type typeobject = extend<{

}>

return nil :: never