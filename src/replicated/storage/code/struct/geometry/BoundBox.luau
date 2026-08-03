--!strict

const BoundVariant = require("@game/ReplicatedStorage/code/enums/BoundVariant")
const declare = require("@game/ReplicatedStorage/code/static/declare")
const namefield = require("@game/ReplicatedStorage/code/static/namefield")
const Cube = require("@game/ReplicatedStorage/code/struct/geometry/Cube")

const private = {}
const class : declare.boundbox = Cube:new {
    type = namefield.boundbox,
    variant = BoundVariant.AABB,

    half = Vector3.zero,
    min = Vector3.zero,
    max = Vector3.zero,

    is_inside = function (self: declare.boundbox ,...: declare.boundbox|BasePart|Model) : boolean end,
    is_belong = function (self: declare.boundbox ,...: declare.vertex) : boolean end,
    is_intersection = function (self: declare.boundbox ,...: declare.boundbox|BasePart|Model) : boolean end,

    to_region3 = function (self: declare.boundbox) : Region3 end,
    to_region3int16 = function (self: declare.boundbox) : Region3int16 end,
    to_part = function (self: declare.boundbox) : Part end,
    to_aabb = function (self: declare.boundbox) : (Vector3 ,Vector3) end,
    to_obb = function (self: declare.boundbox) : (Vector3 ,Vector3 ,Vector3 ,Vector3 ,Vector3 ,Vector3) end,

    from_region3 = function (from: Region3) : declare.boundbox end,
    from_region3int16 = function (from: Region3int16) : declare.boundbox end,
    from_aabb = function (min: Vector3 ,max: Vector3) : declare.boundbox end,
    from_middle = function (variant: declare.enumitem ,...: declare.boundbox|BasePart|Model) : declare.boundbox end,
    from_invarianted = function (variant: declare.enumitem ,...: declare.boundbox|BasePart|Model) : {declare.boundbox} end,
    from = function (variant: declare.enumitem ,...: declare.boundbox|BasePart|Model) : declare.boundbox end,

    get_cover = function (self: declare.boundbox ,...: declare.boundbox|BasePart|Model) : declare.boundbox end,
    get_invariant = function (self: declare.boundbox ,variant: declare.enumitem?) : declare.boundbox end,
    get_mininum_translation = function (self: declare.boundbox ,...: declare.boundbox|BasePart|Model) : declare.vertex end,
    get_origin_directions = function (self: declare.boundbox) : declare.directions end,
    get_axis = function (self: declare.boundbox) : declare.directions end,
    get_origin_size = function (self: declare.boundbox) : Vector3 end,
    get_recalculated = function (self: declare.boundbox) : declare.boundbox end
}




do
    private.self = class
    
    function private.recalculate (that: declare.boundbox) : ()
        
    end
end

return class