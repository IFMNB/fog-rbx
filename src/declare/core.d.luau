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

		read get: <Y>(self: observer<T>, label: any) -> Y,
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

export type maybe <T = unknown, U = unknown> = construct<{
	read extract: (self: maybe<T,U>, it: U, make: () -> T) -> T,
    read enactment: (self: maybe<T,U>, it: U, of: object) -> T,
	read erase: (self: maybe<T,U>, it: U) -> (),
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
























-- Hierarchy




























-- Game

export type round = construct<{
    read get_members: (self: round) -> faction,

    read get_faction: (self: round) -> ...faction,
    read add_faction: (self: round, ...faction) -> (),
    read rem_faction: (self: round, ...faction) -> (),
    read has_faction: (self: round, ...faction) -> boolean
} & stateable<round, enumitem_round_state>, timer>

export type faction = construct<{
    read get_member: (self: faction) -> ...character,
    read add_member: (self: faction, ...character) -> (),
    read rem_member: (self: faction, ...character) -> (),
    read is_member: (self: faction, ...character) -> ...boolean
} & nameable, object>

export type character = construct<{
    read get_aabb: (self: character) -> aabbvolume,
    read get_obb: (self: character) -> obbvolume,


}, observer>































-- Struct

export type result<T = unknown, U... = ...unknown> = construct<{
    read state: boolean,
    read result: T,
    read unpack: (self: result<T,U...>) -> U...
}, struct>



export type aabbvolume = construct<{
    read min: vector,
    read max: vector
} & geometry_half &
    geometry_control<aabbvolume> &
    geometry_check<aabbvolume, geometry_supported> & 
    geometry_convertation<aabbvolume, geometry_supported>, 
cubevolume<aabbvolume>>

export type obbvolume = construct<{
    --[==[
        Поворачивает `obbvolume` относительно его текущего локального поворота,
        путем прибавления или убавления радиан
    ]==]
    read rotate_radian: (self: obbvolume, rad_vector: vector) -> obbvolume,

    --[==[
        Возвращает абсолютный угол поворота по радианам относительно
        мирового стандартного угла
    ]==]
    read get_rotation_radian: (self: obbvolume) -> vector
} &
    geometry_convertation<obbvolume, geometry_supported> &
    geometry_control<obbvolume> &
    geometry_half &
    geometry_check<obbvolume, geometry_supported>,
cubevolume<obbvolume>>

--[===[

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

]===]

export type triangle = construct<{
    read from_vector: (self: triangle, right: vector?, up: vector?, front: vector?) -> triangle
} &centerable<triangle> & 
    axisable<vector> & 
    normals<triangle>,
geovolume<triangle>>

export type quad = construct<{
    read left: triangle,
    read right: triangle,
} & centerable<quad> & 
    normals<quad> & 
    math_operations<quad, quad>, 
struct>

export type directions = construct<vector_operations<directions, directions> & axisable<vector>, geovolume<directions>>


--[==[
    Геометрический аналог CFrame
]==]
export type basis = construct<{
    read orthonormalize: (self: basis) -> basis,
    read euler_angles: (self: basis) -> ...number,
    read components: (self: basis) -> ...number,
} & positioned & rotateable, geovolume<basis>>

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

    read get_profile: (self: charregistry, of: character) -> profile?,
    read set_profile: (self: charregistry, of: character, to: profile?) -> (),

    read get_faction: (self: charregistry, of: character) -> ...faction,
    read set_faction: (self: charregistry, of: character, ...faction) -> (),

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
export type geometry_check <T = unknown, U... = ...unknown> = {

    --[==[
        Переданные данные охвачены диапазоном объекта, из которого вызывается этот метод,
        либо нет, что в итоге приведет к `false`
    ]==]
    read is_inside: (self: T, U...) -> boolean,

    --[==[
        Переданные данные вообще как-либо взаимодействуют с объектом, из которого
        вызван этот метод

        Аналогичен:

        ```luau
            const interacts = self:is_inside(val) and self:is_intersection(val)
        ```
    ]==]
    read is_interacts: (self: T, U...) -> boolean,

    --[==[
        Переданные данные, хотя-бы один из них, пересекается с объектом, из которого
        вызван этот метод. Даже если пересечение совсем небольшое
    ]==]
    read is_intersection: (self: T, U...) -> boolean,
}

export type geometry_half = {
    --[==[
        Полуразмер представляет собой удобный способ проводить вычисления через центр
        и полуоси, через `min | max` или прямые конвертации | сравнения
    ]==]
    half: vector
}

export type geometry_control <T = unknown> = {
    --[==[
        Заставляет геометрическую фигуру направиться лицевой стороной на указанную
        в пространстве точку
    ]==]
    read look_at: (self: T, that: vector, up: vector?) -> T,
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


export type geometry_supported = geometry_volume | Model | BasePart | PVInstance

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