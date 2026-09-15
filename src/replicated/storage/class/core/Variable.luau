--!strict
const object = require("@game/ReplicatedStorage/object")

const private = {}
const class : variable = object:new {
    creation_time = os.clock(),

    get_value = function <T> (self: variable<T>) : T
        return private.space[self][#private.space[self]]
    end,

    set_value = function <T> (self: variable<T>, to: T) : ()
        private.space[self][#private.space[self]] = to
    end,

    history = function <T> (self: variable<T>) : {[number]: T}
        return table.clone(private.space[self])
    end
}

class:host(function(new: variable)
    private.space[new] = {}
end)

do
    private.meta = table.freeze {__mode = "ks"}
    private.space = setmetatable({} :: {[variable]: {[number]: unknown}}, private.meta)
    private.space[class] = {}
end

return class