--!strict

const DefaultVariant = require("@game/ReplicatedStorage/enums/DefaultVariant")
const object = require("@game/ReplicatedStorage/object")
const declare = require("../../static/declare")
const namefield = require("../../static/namefield")
const EnumObject = require("../arch/EnumObject")

const class: declare.notification = object:new({
	type = namefield.notification,
	pack = {},
	call_on = DefaultVariant.Unknown,

	get_packed = function(self: declare.notification): ...any
		return type(self.pack) == "table" and unpack(self.pack) or nil
	end,
})

return class
