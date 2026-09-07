--!strict
const declare = require("./declare")

-- TODO geometry
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


export type aabbvolume = declare.construct<{
    min: vector,
    max: vector
} & geometry_half &
    geometry_check<aabbvolume, geometry_supported> & 
    geometry_convertation<aabbvolume, geometry_supported>, 
cubevolume<aabbvolume>>

export type obbvolume = declare.construct<geometry_convertation<obbvolume, geometry_supported> &
    geometry_half &
    geometry_check<obbvolume, geometry_supported>,
cubevolume<obbvolume>>

export type spherevolume = declare.construct<{
    radius: number,
} & centerable<spherevolume> & 
    math_operations<spherevolume, spherevolume>, 
declare.record>

export type trianglevolume = declare.construct<{
    read get_directions: (self: trianglevolume) -> triangle
} & centerable<trianglevolume> & 
    math_operations<trianglevolume, trianglevolume>, 
declare.record>

export type capsulevolume = declare.construct<geometry_half & 
    centerable<capsulevolume> & 
    math_operations<capsulevolume, capsulevolume> & 
    geometry_check<capsulevolume, geometry_supported> & 
    geometry_convertation<capsulevolume, geometry_supported>, 
declare.record>

export type triangle = declare.construct<{
    read from_vector: (self: triangle, right: vector?, up: vector?, front: vector?) -> triangle
} & centerable<triangle> & 
    axisable<vertex> & 
    normals<triangle> & 
    math_operations<triangle, triangle>, 
declare.record>

export type quad = declare.construct<{
    left: triangle,
    right: triangle,
} & centerable<quad> & 
    normals<quad> & 
    math_operations<quad, quad>, 
declare.record>

export type directions = declare.construct<axisable<vector> & 
    vector_operations<directions, directions> & 
    math_operations<directions, directions>, 
declare.record>

export type vertex<T = vertex> = declare.construct<{

    normal: vector,
    mtv_min: number,

    read from_global_point: (self: vertex<T>, position: vector?) -> T,
    read from_local_point: (self: vertex<T>, local_position: vector?, position: vector?) -> T
} & positioned<vector> & 
    math_operations<vertex<T>, T>, 
declare.record>

export type cubevolume <T = cubevolume> = declare.construct<{
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
declare.record>

export type physics = declare.construct<{

    read locked_rotation: {enumitem_direction_variant},
    read locked_position: {enumitem_direction_variant},

    read is_locked_rotation: (self: physics, variant: enumitem_direction_variant?) -> boolean,
    read is_locked_position: (self: physics, variant: enumitem_direction_variant?) -> boolean,
    read is_locked_both: (self: physics, variant: enumitem_direction_variant?) -> boolean
}, declare.record>

export type enumitem_direction_variant = declare.enumitem<enum_direction_variant>
export type enum_direction_variant = declare.construct<{
    read Up: enumitem_direction_variant,
    read Bottom: enumitem_direction_variant,
    read Left: enumitem_direction_variant,
    read Right: enumitem_direction_variant,
    read Front: enumitem_direction_variant,
    read Back: enumitem_direction_variant,
}, declare.enumobject>


return declare