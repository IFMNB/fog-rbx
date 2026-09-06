--!strict

const EnumItem = require("@game/ReplicatedStorage/class/arch/EnumItem")
const runtimeobject = require("@game/ReplicatedStorage/runtimeobject")
const declare = require("@game/ReplicatedStorage/static/declare")
const project = require("@game/ReplicatedStorage/static/project")

const class: declare.service = runtimeobject:new({
	type = "service",
	code = EnumItem:new({ name = "service" }),
	name = "*no name*",
	enabled = false,

	log = function(self: declare.service, ...: any): ()
		project.console_out(string.format("[%q] ", self.name), ...)
	end,
})

return class
