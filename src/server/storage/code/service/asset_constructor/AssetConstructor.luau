const service = require('@game/ReplicatedStorage/code/class/service/Service')

const private = {}
const class = {__index = service}
setmetatable(class, class)

table.freeze(class :: any)
return class