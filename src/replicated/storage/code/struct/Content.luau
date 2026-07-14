const object = require(".././object")
const namefield = require(".././static/namefield")
const Record = require("../Record")

const class = {__index = Record}
setmetatable(class, class)

export type class<T={[any]: any}> = object.generic<T, typeof(class)>

class.type = namefield.content

function class.new (from: {[any]: any}) 
    return class.arch_new(class, true) :: class
end

function class:insert_from(that: {[unknown]: unknown})
    const this = self :: class
    for i,v in that do
        this[i] = v
    end
end

return table.freeze(class)