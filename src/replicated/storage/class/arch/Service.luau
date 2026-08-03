--!strict

const EnumItem = require("@game/ReplicatedStorage/class/arch/EnumItem")
const runtimeobject = require("@game/ReplicatedStorage/runtimeobject")
const declare = require("@game/ReplicatedStorage/static/declare")
const namefield = require("@game/ReplicatedStorage/static/namefield")
const project = require("@game/ReplicatedStorage/static/project")

const class: declare.service = runtimeobject:new({
	type = namefield.service,
	code = EnumItem:new({ namefield.service }),
	name = "*no name*",

	log = function(self: declare.service, ...: any): ()
		project.console_out(string.format("L:%q %s", self.type, tostring(self.code.hashlink)), ...)
	end,
})

return class
