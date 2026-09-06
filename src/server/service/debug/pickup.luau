--!strict
const PickUp = require("@game/ReplicatedStorage/class/game/PickUp")
const ConnectionVariant = require("@game/ReplicatedStorage/enums/descriptor/ConnectionVariant")
const PickupNotification = require("@game/ReplicatedStorage/enums/notification/PickupNotification")

const that = PickUp:new()
const i = Instance.new "Part"
that:get_reference():set_instance(i)
that:show_pickup(true)
that:subscribe(PickupNotification.Touch, ConnectionVariant.Ever, function ()
    print "hi"
end)

i.Position = Vector3.new(5,5,5)
i.Name = "oio"
i.Parent = workspace

return true