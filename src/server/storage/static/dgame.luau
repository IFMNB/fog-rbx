--!strict
const declare = require("@game/ReplicatedStorage/static/declare")

export type soul = declare.construct<{
    read get_unit: (self: soul) -> unit?,
    read set_unit: (self: soul, to: unit?) -> (),


}, declare.user<>>

export type unit = declare.construct<{


    can_equip_items: boolean,

    speed: number,
    health: number,

    read get_volume: (self: unit) -> declare.cubevolume,

    read get_description: (self: unit) -> unitdescription,
    read set_description: (self: unit, to: unitdescription) -> (),

    read get_equipped: (self: unit) -> {item},
    read set_equipped: (self: unit, that: item|{item}, to: boolean?) -> (),
    read is_equipped: (self: unit, that: item|{item}) -> boolean,

    read get_inventory: (self: unit) -> inventory,
    read set_inventory: (self: unit, to: inventory?) -> ()
} & declare.stateable<unit, enumitem_unit_state>, declare.node<PVInstance>>

export type unitdescription = declare.construct<{

    read max_health: number,
    read regeneration: number,
    
    read default_speed: number,
    read run_speed: number,
    read max_speed: number,

    read jump_height: number,
    read max_jump_height: number,
    
    read height: number,
    
}, declare.object>

export type inventory <T = item<declare.enumitem<any>, declare.enumitem<any>>> = declare.construct<{

    owner: declare.object_identity?,

    can_insert_items: boolean,
    can_remove_items: boolean,
 
    read get_items_with_type: <AT0> (self: inventory<T>, type: string) -> {AT0},
    read get_last_added: (self: inventory<T>) -> T?,
    read get_items: (self: inventory<T>) -> {T},
    read insert_item: (self: inventory<T>, that: T) -> (),
    read remove_item: (self: inventory<T>, that: T) -> (),
    read is_in_inventory: (self: inventory<T>, that: T) -> boolean,
    
    read get_owner: (self: inventory<T>) -> unit|nil
}, declare.pickup<enumitem_inventory_notification>>

export type item <T = declare.enumitem<any>, U = declare.enumitem<any>> = declare.construct<{

    owner: declare.object_identity?,
    equipable: boolean,

    read equip: (self: item<T,U>) -> (),
    read unequip: (self: item<T,U>) -> (),
    read is_equipped: (self: item<T,U>) -> boolean,

    read show_item: (self: item<T,U>, set: boolean?) -> (),

    read get_main_grip: (self: item<T,U>) -> declare.reference<PVInstance?>?,
    read set_main_grip: (self: item<T,U>, to: declare.reference<PVInstance?>?) -> (),
    read get_secondary_grip: (self: item<T,U>) -> declare.reference<PVInstance?>?,
    read insert_secondary_grip: (self: item<T,U>, of: declare.reference<PVInstance?>) -> (),
    read remove_secondary_grip: (self: item<T,U>, of: declare.reference<PVInstance?>) -> (),

    read get_owner: (self: item<T,U>) -> inventory<any>|unit|nil
} & declare.stateable<item<T,U>, U>, declare.pickup<enumitem_item_notification>>

export type weapon = declare.construct<{

    ammo: number,

    statistics: weaponstat,
    read muzzle: declare.reference<Attachment>,
    read chamber: declare.reference<Attachment>,


}, item<enumitem_weapon_notification>>

export type enumitem_unit_state = declare.enumitem<enum_unit_state>
export type enum_unit_state = declare.construct<{
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
}, declare.enumobject>


export type enumitem_soul_require = declare.enumitem<enum_item_notification>
export type enum_soul_require = declare.construct<{
    read LoadOut: enumitem_soul_require,
    read LoadClass: enumitem_soul_require,
    read WeaponStat: enumitem_soul_require,
    read WeaponryOpened: enumitem_soul_require,
    read ArmorStat: enumitem_soul_require,
    read ArmoryOpened: enumitem_soul_require,
    read Misc: enumitem_soul_require
}, declare.enumobject>


export type enumitem_item_notification = declare.enumitem<enum_item_notification>
export type enum_item_notification = declare.construct<{
    read Equipped: enumitem_item_notification, -- -> using now
    read Unequipped: enumitem_item_notification, -- -> inventory
}, declare.enumobject>

export type enumitem_weapon_notification = declare.enumitem<enum_weapon_notification>
export type enum_weapon_notification = declare.construct<{
    read Shoot: enumitem_item_notification,
    read Aim: enumitem_item_notification,
    read Special: enumitem_item_notification,
    read Action: enumitem_item_notification
}, declare.enumobject>

export type enumitem_inventory_notification = declare.enumitem<enum_inventory_notification>
export type enum_inventory_notification = declare.construct<{
    read ItemAdded: enumitem_inventory_notification,
    read ItemRemoved: enumitem_inventory_notification,
}, declare.enumobject>

export type enumitem_browser_require = declare.enumitem<enum_browser_require>
export type enum_browser_require = declare.construct<{
    read BrowserList: enumitem_browser_require,
    read BrowserInfo: enumitem_browser_require,
}, declare.enumobject>

export type enumitem_ammo_variant = declare.enumitem<enum_ammo_variant>
export type enum_ammo_variant = declare.construct<{
    read ["5.8x"]: enumitem_ammo_variant,
    read ["6.4x"]: enumitem_ammo_variant,
    read ["14.4x"]: enumitem_ammo_variant,
    read ["9.3x"]: enumitem_ammo_variant,
}, declare.enumobject>

export type enumitem_weapon_variant = declare.enumitem<enum_weapon_variant>
export type enum_weapon_variant = declare.construct<{
    read Ray: enumitem_weapon_variant,
    read Shell: enumitem_weapon_variant,
    read Zone: enumitem_weapon_variant,
}, declare.enumobject>

export type enumitem_subaction_variant = declare.enumitem<enum_subaction_variant>
export type enum_subaction_variant = declare.construct<{

    read PeekLeft: enumitem_subaction_variant,
    read PeekRight: enumitem_subaction_variant,

    read PickInventorySlot: enumitem_subaction_variant,
    read PickToInventoryItemInZone: enumitem_subaction_variant,
    read PickToInventoryItemOnLineOfSight: enumitem_subaction_variant,
    read PickItemInZone: enumitem_subaction_variant,
    read PickItemOnLineOfSight: enumitem_subaction_variant,

    read DoPrimary: enumitem_subaction_variant,
    read DoSecondary: enumitem_subaction_variant,
    read DoSpecial: enumitem_subaction_variant,
    read DoAction: enumitem_subaction_variant,

    read Say: enumitem_subaction_variant,
}, declare.enumobject>

export type weaponstat = declare.construct<{

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
}, declare.record>

return declare
