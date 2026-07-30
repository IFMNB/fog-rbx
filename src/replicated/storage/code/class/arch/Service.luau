--!strict

const runtimeobject = require("../../runtimeobject")
const declare = require("../../static/declare")
const namefield = require("../../static/namefield")
const project = require("../../static/project")
const EnumItem = require("./EnumItem")

const class : declare.service = runtimeobject:new({
	type = namefield.service,
	code = EnumItem:new({namefield.service}),
	name = "*no name*",

	log = function (self: declare.service, ...: any) : ()
		project.console_out(string.format("L:%q %s", self.type, tostring(self.code.hashlink)), ...)
	end
})

return class