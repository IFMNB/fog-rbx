const Lori = require("@game/ReplicatedStorage/dependency/Lori")
const instance = Lori.create()

instance:mount(nil, {
    studioOnly = false,
    template = Lori.Templates.Performance
})

return instance