--!strict
const EnumObject = require("@game/ReplicatedStorage/class/arch/EnumObject")
const Observer = require("@game/ReplicatedStorage/class/arch/Observer")
const ActionNotification = require("@game/ReplicatedStorage/enums/notification/ActionNotification")
const PickupNotification = require("@game/ReplicatedStorage/enums/notification/PickupNotification")
const test = Observer:new()

test:notificate(PickupNotification)
test:notificate(PickupNotification.Dropped)
test:notificate({PickupNotification.Dropped})
test:notificate({PickupNotification})
test:notificate({PickupNotification, PickupNotification.Dropped})

test:notificate(EnumObject)
test:notificate({EnumObject})
test:notificate({ActionNotification})
test:notificate({ActionNotification.Emit})