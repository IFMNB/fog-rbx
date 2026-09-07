--!strict 
-- #10

export type construct<T = {}, U = object> = T & U

--[[
    fflag DebugLuauMagicTypes с true в fflags override LSP добавляет 3 новых типа

    _luau_print<T> where T : any - крашит ТС + выводит json rpc
    _luau_ice - крашит ТС
    _luau_blocked_type - сводит тип к never magic subtype *blocked-type* и игнорирует
    _luau_force_constraint_solving_incomplete - 
]]

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

export type switchable<T = unknown> = {
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
    read type: string,
	read identity: object_identity,
    
    read new: <T,U> (self: T, that: U?) -> construct<T,U>,
    read renew: <T> (self: T, that: --[=[*based-on-base-object*]=] {[unknown]: unknown}?) -> construct<T, {}>,
    read equals: (this: unknown, that: any) -> boolean,
    read is: (self: unknown, that: string) -> boolean,
    read base: <T> (self: unknown, expected: string|nil) -> T?,
    read host: <T> (self: unknown, f: (new: T) -> ()) -> (),
    read rebuild: <T> (self: T, that: {[unknown]: unknown}) -> T,
    read require: <T> (identity: object_identity, assert: string?) -> T
}

export type enumobject = construct<{
    read get_enums_list: (self: enumobject) -> {[unknown]: enumitem},                        
    read get_enums_count: (self: enumobject) -> number,
    read get_enums_name: (...enumitem) -> ...string,
    read get_enumitem_by_hashlink: (hashlink: string) -> enumitem<>,
    read assert_is_my_enumitem: (self: enumobject, that: unknown) -> boolean,
    read is_my_enumitem: (self: enumobject, that: enumitem) -> boolean,
} & nameable , object>

export type enumitem<T = enumobject?> = construct<{
    read hashlink: string,
    read enum: T,
} & nameable, object>

export type variant = construct<{
    read tvalue: string,
    read value: unknown
}, object>




export type runtimeobject = construct<{
    read get_creation_time: (self: runtimeobject) -> DateTime,
    read get_dependencies: (self: runtimeobject) -> {unknown},
    read add_dependency: (self: runtimeobject, obj: unknown) -> (),
    read rem_dependency: (self: runtimeobject, obj: unknown) -> ()
}, object>

export type notification<T = enumitem<any>> = construct<{
    read stored: {unknown}
} & expected_calltype<T>, runtimeobject>

export type pointer = construct<{
    read point: (to: unknown) -> pointer,
    read drop: (self: pointer) -> (),
    read use: (self: pointer) -> (),
}, runtimeobject>

export type observer<T = enumitem<any>> = construct<{
    read subscribe: (self: observer<T>, on: T|{T}|enumobject, mode: enumitem_connection_variant, ...observer_pack<T>) -> (() -> ()),
    read notificate: (self: observer<T>, notification: T|{T}|notification<T|{T}>) -> (),
}, runtimeobject>

export type user<T = enumitem> = construct<{
    read uid: number,

    read get_player: (self: user<T>) -> Player?,
    read get_reference: (self: user<T>) -> reference<Player>,
    read get_configurated: (self: user<T>, of: enumitem) -> variant,
    read set_configurated: (self: user<T>, of: enumitem, to: boolean) -> variant,

    read is_banned: (self: user<T>) -> boolean,
    read is_kicked: (self: user<T>) -> boolean,
    read is_playing: (self: user<T>) -> boolean,
    read is_here: (self: user<T>) -> boolean,
}, observer<enumitem_user_notification>>

export type localuser = construct<{
    read get_player: (self: localuser) -> Player,


}, observer<enumitem_user_notification>>

export type event<T = enumitem<any>, U... = ...unknown> = construct<{
    read connect: <T0> (self: event<T,U...>, on: T|enumitem_default_variant, f: ((U...) -> ())|thread|observer<T>) -> connection<T,U...>,
    read once: <T0> (self: event<T,U...>, on: T|enumitem_default_variant, f: ((U...) -> ())|thread|observer<T>) -> connection<T,U...>,
    read wait: (self: event<T,U...>, on: T|enumitem_default_variant) -> U...,
    read invoke: (self: event<T,U...>, on: T|{T}|notification<T|{T}>, U...) -> (),
    read link: (self: event<T,U...>, that: connection<T,U...>) -> (),
    read unlink: (self: event<T,U...>, that: connection<T, U...>) -> ()
} & expected_calltype<T?>, observer<T>> 

export type connection<T = enumitem<any>, U... = ()> = construct<{
    state: enumitem_connection_variant,
    count: number,

    read disconnect: (self: connection<T,U...>) -> (),
    read link: (self: connection<T,U...>, that: event<T,U...>) -> (),
    read unlink: (self: connection<T,U...>, that: event<T, U...>) -> ()
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

export type channel <T = enumitem_network_replication, U... = ...unknown, E... = ...unknown> = construct<{
    read reference: reference<channel_internal_reference?>,
    read event: event<T,E...>,

    everyone: boolean,
    echo: boolean,

    read send: (self: channel<T,U...,E...>, to: T, U...) -> (),
    read sync: (self: channel<T,U...,E...>, to: T, U...) -> {[user]: (() -> E...)?},
    read async: (self: channel<T,U...,E...>, to: T, U...) -> {[user]: (() -> E...)?},

    read set_sync_response: (self: channel<T,U...,E...>, to: T, f: ((U...) -> E...)? ) -> (),
    read get_sync_response: (self: channel<T,U...,E...>, to: T) -> ((U...) -> E...)?,

    read set_async_response: (self: channel<T,U...,E...>, to: T, f: ((U...) -> object)?) -> (),
    read get_async_response: (self: channel<T,U...,E...>, to: T) -> ((U...) -> object)?,

    read get_peer: (self: channel<T,U...,E...>) -> {user},
    read set_peer: (self: channel<T,U...,E...>, of: user, to: boolean?) -> (),
    read is_peer: (self: channel<T,U...,E...>, of: user) -> boolean,
    read request_from: (self: channel<T,U...,E...>) -> user?,

    read get_transport: (self: channel<T,U...,E...>) -> enumitem_network_replication?,
    read set_transport: (self: channel<T,U...,E...>, to: enumitem_network_replication?) -> (),
    read is_transport: (self: channel<T,U..., E...>, of: enumitem_network_replication) -> boolean
} & asyncable & switchable<channel<T,U...,E...>>, observer<enumitem_channel_notification>>

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

export type statemachine<T = unknown> = construct<{
    can_only_allowed: boolean,

    read get_last_state: (self: statemachine<T>) -> T?,
    read get_state: (self: statemachine<T>, of: T) -> boolean,
    read set_state: (self: statemachine<T>, of: T, to: boolean?) -> (),
    read allow_state: (self: statemachine<T>, of: T, to: boolean?) -> ()
}, observer<enumitem_operation_variant>>


export type disposable<T = enumitem<any>> = construct<{
    read free: (self: disposable<T>) -> (), 
    read queue_free: (self: disposable<T>) -> (),
}, observer<T|enumitem_disposable_notification>> 

export type maid = construct<{
    read add_object: (self: maid, that: unknown, strong: boolean?) -> (), -- #12
    read add_key: <T> (self: maid, of: {[T]: unknown}, key: T) -> (),
    read remove_object: (self: maid, that: unknown) -> (), -- #12
    read remove_key: <T> (self: maid, of: {[T]: unknown}, key: T) -> (),
    read is_supported: (self: maid, that: unknown) -> boolean
}, disposable>

export type node<T = Instance, U = enumitem<any>> = construct<{
    auto_free_on_destroying: boolean,

    read get_attribute_list: (self: node<T,U>) -> {[string]: value},
    read get_attribute: (self: node<T,U>, name: string) -> value?,
    read add_attribute: (self: node<T,U>, name: string) -> value,
    read remove_attribute: (self: node<T,U>, name: string) -> (),

    read add_dependent: (self: node<T,U>, t: object) -> (),
    read remove_dependent: (self: node<T,U>, t: object) -> (),
    read get_dependents: (self: node<T,U>, like: object) -> {object}
} & referenceable<node<T,U>,T?> , disposable<U>>



export type executor<T = enumitem<any>> = construct<{
    last_delta: number,
    last_emit: number,

    read process: (self: executor<T>, delta: number) -> (),
    read simulate: (self: executor<T>, delta: number) -> (),
    read get_timer: (self: executor<T>) -> timer,
}, disposable<T|enumitem_executor_notification>>

export type attribute<T = unknown, U = Instance> = construct<{
    sync_params: boolean,

    read get_params: (self: attribute<T,U>) -> value<T>,
    read get_current_value: (self: attribute<T,U>) -> T?
} & nameable<string> & referenceable<attribute<T,U>,U?>, disposable<enumitem_attribute_notification>>

export type input<T = enumitem<any>> = construct<{
    duration: number,
    clamped: boolean,
    pressed: boolean,

    read get_code: (self: input<T>) -> {Enum.KeyCode},
    read set_code: (self: input<T>, of: Enum.KeyCode, to: boolean?) -> (),
    read get_related: (self: input<T>) -> enumitem_action_map_variant|T?,
    read set_related: (self: input<T>, new: enumitem_action_map_variant|T?) -> (),
    read set_network: (self: input<T>, to: boolean) -> (),
    read is_network_active: (self: input<T>) -> boolean
} & switchable<input<T>> & invokeable<input<T>>, disposable<enumitem_input_notification>>




export type pickup <T = enumitem<any>> = construct<{

    dropable: boolean,
    pickable: boolean,
    read time: value<number>,
    read distance: value<number>,

    read show_pickup: (self: pickup<T>, set: boolean?) -> (),
    
    read get_last_interacted: (self: pickup<T>) -> object? -- unit
}, node<PVInstance, T|enumitem_pickup_notification>>

export type config<T = unknown, U = enumitem> = construct<{

    related: U,
    auto_updateable: boolean,

    read update_to_newest: (self: config<T>) -> ()
}, value<T>>

export type service<T = enumitem<any>> = construct<{

    read code: T,

    read log: (self: service, ...any) -> (),
} & switchable<service<T>> & nameable, runtimeobject>

export type record = construct<{


    read immutable: (self: record) -> record,
    read is_immutable: (self: record) -> boolean,
    read clone: <T> (self: T) -> T,

    read get_dictionary: (self: record) -> {[string]: number|boolean|string},
    read each: <T> (self: record, type: string, f: (value: T) -> T) -> ()
}, object>

export type result<T = unknown, U... = ...unknown> = construct<{

    read state: boolean,
    read result: T,

    read unpack: (self: result<T,U...>) -> U...
}, record>

export type enumitem_default_variant = enumitem<enum_default_variant>
export type enum_default_variant = construct<{
    read Unknown: enumitem_default_variant,
    read Any: enumitem_default_variant,
}, enumobject>

export type enumitem_tasky_variant =  enumitem<enum_tasky_outcode_variant>
export type enum_tasky_outcode_variant = construct<{
    read Reenter: enumitem_tasky_variant,
    read Goto: enumitem_tasky_variant,
    read Error: enumitem_tasky_variant
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
    read Installed: enumitem_setup_notification
}, enumobject>

export type enumitem_pickup_notification = enumitem<enum_pickup_notification>
export type enum_pickup_notification = construct<{
    read PickedUp: enumitem_pickup_notification,
    read Dropped: enumitem_pickup_notification,
    read Shown: enumitem_pickup_notification,
    read Hidden: enumitem_pickup_notification,
    read Touch: enumitem_pickup_notification,
}, enumobject>

export type enumitem_collision_variant = enumitem<enum_collision_variant>
export type enum_collision_variant = construct<{
    read DefaultGroup: enumitem_collision_variant,
    read ItemGroup: enumitem_collision_variant,
    read CharacterGroup: enumitem_collision_variant,
    read DebrisGroup: enumitem_collision_variant,
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

export type enumitem_user_data_require = enumitem<enum_user_data_require>
export type enum_user_data_require = construct<{
    read UserProfile: enumitem_user_data_require,

    read UserLastDataSave: enumitem_user_data_require,
    read UserLastDataRequest: enumitem_user_data_require,
    read UserPlayedTime: enumitem_user_data_require,
    read UserLastEnter: enumitem_user_data_require,
    read UserPreviousKick: enumitem_user_data_require,
    read UserPreviousBan: enumitem_user_data_require
}, enumobject>


export type enumitem_user_notification = enumitem<enum_user_notification>
export type enum_user_notification = construct<{
    read ServerJoin: enumitem_user_notification,
    read ServerExit: enumitem_user_notification,
    read ServerBan: enumitem_user_notification,
    read ServerKick: enumitem_user_notification,
    read ServerDataRequest: enumitem_user_notification, 
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
}, enumobject>

export type enumitem_network_replication = enumitem<any>
export type enum_network_replication = enumobject

export type enumitem_connection_variant = enumitem<enum_connection_variant>
export type enum_connection_variant = construct<{
    read Ever: enumitem_connection_variant,
    read Once: enumitem_connection_variant,
    read Never: enumitem_connection_variant,
    read Hold: enumitem_connection_variant,
    read Skip: enumitem_connection_variant, -- -> Once 
    read Next: enumitem_connection_variant, -- -> Ever
}, enumobject>

export type enumitem_internal_channel_variant = enumitem<enum_internal_channel_variant>
export type enum_internal_channel_variant = construct<{
    read UserData: enumitem_internal_channel_variant
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