const object = require("../../object")
const class_names = require("../../static/class_names")

const class = {}
setmetatable(class, {__index = object})

export type class = typeof(class.new())
export type generic<T = nil> = class & {
    get_asset: () -> T
}

class.type = class_names.asset

function class.new (of: Instance)
    const this = object.new(class)
    
    this.get_asset = function ()
        return of:Clone()
    end

    return this
end



function class.get_asset ()
    return nil
end

table.freeze(class :: any)
return class