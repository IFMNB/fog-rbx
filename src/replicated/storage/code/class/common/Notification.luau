--!strict

const runtimeobject = require("../../runtimeobject")
const declare = require("../../static/declare")
const namefield = require("../../static/namefield")
const EnumObject = require("../arch/EnumObject")

const class : declare.notification = runtimeobject:new({
    type = namefield.notification,
    pack = {},
    call_on = EnumObject.Unknown :: declare.enumitem|declare.runtimeobject,

    get_packed = function (self: declare.notification) : ...any
        return type(self.pack) == "table" and unpack(self.pack) or nil
    end
});

return class