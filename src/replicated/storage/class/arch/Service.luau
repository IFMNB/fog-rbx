--!strict

const EnumItem = require("@game/ReplicatedStorage/class/arch/EnumItem")
const runtimeobject = require("@game/ReplicatedStorage/runtimeobject")
const declare = require("@game/ReplicatedStorage/static/declare")
const namefield = require("@game/ReplicatedStorage/static/namefield")
const project = require("@game/ReplicatedStorage/static/project")

const class: declare.service = runtimeobject:new({
	type = namefield.service,
	code = EnumItem:new({ name = namefield.service }),
	name = "*no name*",
	enabled = false,

	log = function(self: declare.service, ...: any): ()
		project.console_out(string.format("[%q] ", self.name), ...)
	end,
})

return class
