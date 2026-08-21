--!strict

const DefaultVariant = require("@game/ReplicatedStorage/enums/descriptor/DefaultVariant")
const object = require("@game/ReplicatedStorage/object")
const declare = require("@game/ReplicatedStorage/static/declare")
const namefield = require("@game/ReplicatedStorage/static/namefield")

const class: declare.notification = object:new({
	type = namefield.notification,
	on = DefaultVariant.Unknown,
})

return class
