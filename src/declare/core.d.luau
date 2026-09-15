--!strict

--- CORE

export type construct<T = unknown, U = unknown> = T & U
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
    read iden: (self: object) -> object_identity
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
	read clone: <T>(self: struct | T) -> T,
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
export type observer<T = enumitem<any> | enumobject> = construct<
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

		read get: <Y>(self: observer<T>, label: unknown) -> Y,
		read set: <Y>(self: observer<T>, label: unknown, to: Y) -> (),
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
}, object>






















-- Common

export type event<T = enumitem<any>, U... = ...unknown> = construct<{
    read connect: <T0> (self: event<T,U...>, on: ((...any)->())|thread|observer<T>, f: ((U...) -> ())|thread|observer<T>) -> connection<T,U...>,
    read once: <T0> (self: event<T,U...>, on: ((...any)->())|thread|observer<T>, f: ((U...) -> ())|thread|observer<T>) -> connection<T,U...>,
    read wait: (self: event<T,U...>, on: ((...any)->())|thread|observer<T>) -> U...,
    read invoke: (self: event<T,U...>, on: ((...any)->())|thread|observer<T>, U...) -> (),
} & expected_calltype<T?>, observer<T>> 

export type connection<T = enumitem<any>, U... = ()> = construct<{
    count: number,

    read get_mode: (self: connection<T, U...>) -> enumitem_connection_variant,
    read set_mode: (self: connection<T, U...>, mode: enumitem_connection_variant) -> (),
    
    read is_connected: (self: connection<T,U...>) -> boolean,
    read disconnect: (self: connection<T,U...>) -> (),
} & invokeable<connection<T,U...>,U...> & expected_calltype<T>,
observer<T|enumitem_connection_variant|enumitem_setup_notification|enumitem_action_notification>>

export type value<T = unknown> = construct<{
    read get_value: (self: value<T>) -> T?,                    
    read set_value: (self: value<T>, new: T?, default: boolean?) -> (),
    read on_operation_event: (self: value<T>) -> event<enumitem_operation_variant>
}, observer<enumitem_operation_variant>>

export type timer = construct<{
    seconds: number,
    previous_stepped: DateTime,

    read schedule: (self: timer) -> (),    
    read get_delta: (self: timer) -> number,
} & iterations<number> & modifier<number> & controllable<timer>, observer<enumitem_action_notification>>

export type reference<T = Instance> = construct<{
    read clear: (self: reference<T>) -> ()
} & instanceable<reference<T>, T>, observer<enumitem_reference_notification>>

export type signal<T... = ...unknown> = construct<{
    read get_signal_event: (self: signal<T...>) -> event<enumitem_action_notification, T...>
}, reference<RBXScriptSignal<T...>>>

export type controller = construct<{
    state: enumitem_controller_state
} & operatable<controller>, observer<enumitem_controller_state>>

export type asset<T = unknown> = construct<{
    read variant: enumitem_asset_type_variant|enumitem_default_variant,
    read rid: number,
    state: enumitem_state,

    read get_asset: (self: asset<T>) -> T?
}, observer<enumitem_state>>

export type tasky<
	current --[=[*based-on-current-realization*]=]
> = construct<{
	read deploy: (self: tasky<current>, path: string) -> (),
	read get_online: (self: tasky<current>) -> { [string]: current },
	read get_offline: (self: tasky<current>) -> { [string]: current },
	read get_existed: (self: tasky<current>, path: string) -> current?,
	read is_exists: (self: tasky<current>, path: string) -> boolean,
} & asyncable, object>

export type stack<T = unknown> = construct<{
	max: number,

	read pick: (self: stack<T>) -> T?,
	read put: (self: stack<T>, value: T) -> (),
	read count: (self: stack<T>) -> number,
}, object>

export type maybe = construct<{
	read extract: <T>(self: maybe, it: unknown, make: () -> T) -> T,
	read erase: (self: maybe, it: unknown) -> (),
	read exist: (self: maybe, it: unknown) -> boolean,
}, object>


-- Component


export type user<T = enumitem<any>> = construct<{
    read uid: number,

    read get_inlined: (self: user<T>, uid: number) -> user<T>, 
    read get_player: (self: user<T>) -> Player?,
    read get_reference: (self: user<T>) -> reference<Player>,
    read get_configurated: <Y> (self: user<T>, of: enumitem<any>) -> variable<Y>,
    read get_joined_at: (self: user<T>) -> DateTime,
    read get_last_seen_at: (self: user<T>) -> DateTime?,
    read get_last_server_id: (self: user<T>) -> string?,
    read get_permissions: (self: user<T>) -> {enumitem<any>},
    read get_restrictions: (self: user<T>) -> {enumitem<any>},

    read set_configurated: <Y> (self: user<T>, of: enumitem<any>, ...unknown) -> (),
    read set_permissions: (self: user<T>, to: boolean, ...enumitem<any>) -> (),
    read set_restrictions: (self: user<T>, to: boolean, ...enumitem<any>) -> (),
    read set_platform: (self: user<T>, to: boolean, ...enumitem_user_machine_variant) -> (),

    read has_platform: (self: user<T>, ...enumitem_user_machine_variant) -> boolean,
    read has_restricitions: (self: user<T>, ...enumitem<any>) -> ...boolean,
    read has_permissions: (self: user<T>, ...enumitem<any>) -> ...boolean,

    read is_banned: (self: user<T>) -> boolean,
    read is_kicked: (self: user<T>) -> boolean,
    read is_out: (self: user<T>) -> boolean,
    read is_in_place: (self: user<T>) -> boolean,
    read is_in_server: (self: user<T>) -> boolean,
}, observer<enumitem_user_notification>>

export type localuser = construct<{
    read uid: number,
    read get_player: (self: localuser) -> Player,

    read require_get_configuration: (self: localuser, of: enumitem<any>) -> result,
    read require_save_configuration: (self: localuser, of: enumitem<any>, ...unknown) -> (),

    read get_user: (self: localuser) -> user,
}, object>
























-- Hierarchy

export type node<T = Instance, U = enumitem<any>> = construct<{
    auto_free_on_destroying: boolean,

    read get_attribute_list: (self: node<T,U>) -> {[string]: value},
    read get_attribute: (self: node<T,U>, name: string) -> value?,
    read add_attribute: (self: node<T,U>, name: string) -> value,
    read remove_attribute: (self: node<T,U>, name: string) -> (),

    read add_dependent: (self: node<T,U>, t: object) -> (),
    read remove_dependent: (self: node<T,U>, t: object) -> (),
    read get_dependents: (self: node<T,U>, like: object) -> {object}
} & referenceable<node<T,U>,T?> , disposable>

export type graphnode = construct<{
    read get_parent: (self: graphnode) -> Instance?,
    read set_parent: (self: graphnode, parent: Instance|reference|node|graphnode) -> ()
}, disposable>































-- Game

























-- Struct

export type result<T = unknown, U... = ...unknown> = construct<{

    read state: boolean,
    read result: T,

    read unpack: (self: result<T,U...>) -> U...
}, struct>


export type aabbvolume = construct<{
    min: vector,
    max: vector
} & geometry_half &
    geometry_check<aabbvolume, geometry_supported> & 
    geometry_convertation<aabbvolume, geometry_supported>, 
cubevolume<aabbvolume>>

export type obbvolume = construct<geometry_convertation<obbvolume, geometry_supported> &
    geometry_half &
    geometry_check<obbvolume, geometry_supported>,
cubevolume<obbvolume>>

export type spherevolume = construct<{
    radius: number,
} & centerable<spherevolume> & 
    math_operations<spherevolume, spherevolume>, 
struct>

export type trianglevolume = construct<{
    read get_directions: (self: trianglevolume) -> triangle
} & centerable<trianglevolume> & 
    math_operations<trianglevolume, trianglevolume>, 
struct>

export type capsulevolume = construct<geometry_half & 
    centerable<capsulevolume> & 
    math_operations<capsulevolume, capsulevolume> & 
    geometry_check<capsulevolume, geometry_supported> & 
    geometry_convertation<capsulevolume, geometry_supported>, 
struct>

export type triangle = construct<{
    read from_vector: (self: triangle, right: vector?, up: vector?, front: vector?) -> triangle
} & centerable<triangle> & 
    axisable<vertex> & 
    normals<triangle> & 
    math_operations<triangle, triangle>, 
struct>

export type quad = construct<{
    left: triangle,
    right: triangle,
} & centerable<quad> & 
    normals<quad> & 
    math_operations<quad, quad>, 
struct>

export type directions = construct<axisable<vector> & 
    vector_operations<directions, directions> & 
    math_operations<directions, directions>, 
struct>

export type vertex<T = vertex> = construct<{

    normal: vector,
    mtv_min: number,

    read from_global_point: (self: vertex<T>, position: vector?) -> T,
    read from_local_point: (self: vertex<T>, local_position: vector?, position: vector?) -> T
} & positioned<vector> & 
    math_operations<vertex<T>, T>, 
struct>

export type cubevolume <T = cubevolume> = construct<{
    up: vector,
    bottom: vector,
    left: vector,
    right: vector,
    front: vector,
    back: vector,

    read get_corners: (self: cubevolume<T>) -> {vertex},
    read get_direction: (self: cubevolume<T>, direction: enumitem_direction_variant) -> vector,
    read get_axises: (self: cubevolume<T>) -> {vector},
    read get_sat_axises: (self: cubevolume<T>) -> {vector},
    read get_quad: (self: cubevolume<T>, direction: enumitem_direction_variant) -> quad,
} & centerable<cubevolume<T>> & 
    math_operations<cubevolume<T>, T> & 
    vector_operations<cubevolume<T>, T>, 
struct>

export type physics = construct<{

    read locked_rotation: {enumitem_direction_variant},
    read locked_position: {enumitem_direction_variant},

    read is_locked_rotation: (self: physics, variant: enumitem_direction_variant?) -> boolean,
    read is_locked_position: (self: physics, variant: enumitem_direction_variant?) -> boolean,
    read is_locked_both: (self: physics, variant: enumitem_direction_variant?) -> boolean
}, struct>





































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

export type enumitem_action_notification = enumitem<enum_action_notification>
export type enum_action_notification = construct<{
	read Signal: enumitem_action_notification,
	read Step: enumitem_action_notification,
	read Emit: enumitem_action_notification,
	read Unobservable: enumitem_action_notification,
	read Observer: enumitem_action_notification,
}, enumobject>

export type enumitem_asset_type_variant = enumitem<enum_asset_type_variant>
export type enum_asset_type_variant = construct<{
	read Model: enumitem_asset_type_variant,
	read Sound: enumitem_asset_type_variant,
	read Image: enumitem_asset_type_variant,
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

export type geometry_volume = spherevolume | aabbvolume  | obbvolume | trianglevolume | capsulevolume | cubevolume
export type geometry_primetive = triangle | quad | vertex | vector | cubevolume
export type geometry_check <T = unknown, U... = ...unknown> = {
    read is_inside: (self: T, U...) -> boolean,
    read is_interacts: (self: T, U...) -> boolean,
    read is_intersection: (self: T, U...) -> boolean,
}
export type geometry_half = {
    half: vector
}
export type geometry_convertation <T = unknown, U... = ...unknown> = {
    read from: (self: T, U...) -> T,
    read middle: (self: T, U...) -> T,
    read cover: (self: T, U...) -> T
}
export type geometry_supported = geometry_volume | Model | BasePart | PVInstance
export type geometry_sat <T = unknown, U... = ...unknown> = {
    read mtv: (self: T, U...) -> vertex,    
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
export type axisable<T = unknown> = {
    right: T,
    up: T,
    front: T
}
export type centerable<T = unknown> = {
    read get_center: (self: T) -> vector
}
export type rotateable<T = unknown> = {
    rotation: directions
}
export type normals<T=unknown, U=vector> = {
    read get_normal_geometric: (self: T) -> U,
    read get_normal_interpolated: (self: T) -> U,
}