--!strict
const UserDataRequire = require("@game/ReplicatedStorage/enums/require/UserDataRequire")
const declare = require("@game/ReplicatedStorage/static/declare")

const Result = require("@game/ReplicatedStorage/struct/common/Result")

const class: declare.userdata = Result:new({
	type = "userdata",
	of = UserDataRequire.Profile,
	result = {},
})

return class
