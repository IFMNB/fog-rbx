--!strict

const object = require "@game/ReplicatedStorage/code/object"
const runtimeobject = require "@game/ReplicatedStorage/code/runtimeobject"

const class = setmetatable({}, {__index = runtimeobject})

export type class = runtimeobject.extend<setmetatable<{},{__index: typeof(class)}>>
export type extend<T={}> = object.construct<T, class>

class.type = ""
class.a = false

function class:doa ()
    const this = self :: class
    this.a = true
end

return table.freeze(class)