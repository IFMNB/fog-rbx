--!strict

const DefaultVariant = require("@game/ReplicatedStorage/enums/descriptor/DefaultVariant")
const object = require("@game/ReplicatedStorage/object")
const declare = require("@game/ReplicatedStorage/static/declare")

const class: declare.notification = object:new({
	type = "notification",
	on = DefaultVariant.Unknown,
})

return class
