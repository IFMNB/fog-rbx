--!strict

const object = require("@game/ReplicatedStorage/code/object")
const StorageMode = require("../../enums/StorageMode")
const Service = require("@game/ReplicatedStorage/code/class/service/Service")
const class_names = require "@game/ReplicatedStorage/code/static/class_names"

const private = {}
const class = {__index = Service}
setmetatable(class, class)

class.type = class_names.storage

private.stored_lazy_keys = setmetatable({} :: {[object.class]: setmetatable<{[any]: any}, {__mode:string}>?}, {__mode = 'ks'})
private.stored_lazy_values = setmetatable({} :: {[object.class]: setmetatable<{[any]: any}, {__mode:string}>?}, {__mode = 'ks'})
private.stored_lazy_all = setmetatable({} :: {[object.class]: setmetatable<{[any]: any}, {__mode:string}>?}, {__mode = 'ks'})

function class.get_for(this: object.class, mode)
    if (mode == StorageMode.LazyKeys) then
        return private.stored_lazy_keys[this]
    elseif (mode == StorageMode.LazyValues) then
        return private.stored_lazy_values[this]
    elseif (mode == StorageMode.LazyAll) then
        return private.stored_lazy_all[this]
    else
        return error("unexpected StorageMode enum")
    end
end

function class.set_for (this: object.class, mode)
    if (mode == StorageMode.LazyKeys) then
        private.stored_lazy_keys[this] = setmetatable({}, {__mode='ks'})
        return private.stored_lazy_keys[this] :: setmetatable<{[any]: any}, {__mode:string}>
    elseif (mode == StorageMode.LazyValues) then
        private.stored_lazy_keys[this] = setmetatable({}, {__mode='vs'})
        return private.stored_lazy_values[this] :: setmetatable<{[any]: any}, {__mode:string}>
    elseif (mode == StorageMode.LazyAll) then
        private.stored_lazy_keys[this] = setmetatable({}, {__mode='kvs'})
        return private.stored_lazy_all[this] :: setmetatable<{[any]: any}, {__mode:string}>
    else
        return error("unexpected StorageMode enum")
    end
end

function class.get_forced (this: object.class, mode) : setmetatable<{[any]: any}, {__mode:string}>
    const stored = class.get_for(this, mode)
    if (not stored) then
        return class.set_for(this, mode)
    else
        return stored
    end
end

return table.freeze(class)