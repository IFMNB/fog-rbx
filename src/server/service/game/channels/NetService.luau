--!strict
const Service = require("@game/ReplicatedStorage/class/arch/Service")
const Jolt = require("@game/ReplicatedStorage/dependency/Jolt")

const service = Service:new {
    name = script.Name
}

do
    Jolt.Server()
end

return service