--!strict
const object = require("@game/ReplicatedStorage/object")

object:host(function(new)
    print("new")
end)

const test = object:new()
const test2 = object:new({
    ah = 45, b = "", f = function () print(234) end
})

