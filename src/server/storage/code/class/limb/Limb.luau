const Disposable = require("@game/ReplicatedStorage/code/Disposable")
const BoundBox = require("@game/ReplicatedStorage/code/class/boundbox/BoundBox")
const Storage = require("@game/ReplicatedStorage/code/class/storage/Storage")
const Upload = require("@game/ReplicatedStorage/code/class/upload/Upload")
const Wrapper = require("@game/ReplicatedStorage/code/class/wrapper/Wrapper")
const BoundBoxDirection = require("@game/ReplicatedStorage/code/enums/BoundBoxDirection")
const object = require("@game/ReplicatedStorage/code/object")
const namefield = require("@game/ReplicatedStorage/code/static/namefield")
const project = require("@game/ReplicatedStorage/code/static/project")
const LimbType = require("../../enums/LimbType")
const Entity = require("@game/ServerStorage/code/class/entity/Entity")

const private = {}
const class = {__index = Entity}
setmetatable(class, class)

export type class = object.generic<{
    initiate: (self: unknown, as: BasePart) -> (),
    get_instance: (self: unknown) -> BasePart
},typeof(class)>

class.type = namefield.limb
class.classname = "BasePart" :: "BasePart"
class.limb = LimbType.Unknown

function class.new ()
    return Disposable.new(class, true)
end

function class:get_direction(that: number)
    const this = self :: class
    const metadata = private.metadata:fetch(self)
    const boundbox = Upload.fetch(metadata, "boundbox", BoundBox.new)
    return Upload.fetch(metadata, that, function(...)
        const part = this:get_instance()
        boundbox:bound(part)

        const bound_pos = boundbox:get_bound_by_direction(that)
        --const direction = boundbox:get_direction(that)

        const attachment = Instance.new "Attachment"
        attachment.Name = BoundBoxDirection:get_name(that)
        attachment.Parent = part
        attachment.WorldPosition = bound_pos
        --attachment.Orientation = direction

        const wrapper = Wrapper.get_global_wrap(attachment) :: Wrapper.generic<Attachment>
        return wrapper:get_holder() :: Attachment
    end)
end

private.metadata = Storage.new()

return table.freeze(class)