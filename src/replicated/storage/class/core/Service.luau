--!strict

const object = require("@game/ReplicatedStorage/object")
const ctags = require("@game/ReplicatedStorage/static/ctags")
const ctype = require("@game/ReplicatedStorage/static/ctype")

const class: service = object:new({
	type = "service",
	name = "*no name*",
	enabled = false
})

ctype:read(class):write_tag(ctags.core)

return class
