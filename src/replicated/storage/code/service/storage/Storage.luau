--!strict

const object = require("@game/ReplicatedStorage/code/object")
const StorageMode = require("../../enums/StorageMode")
const Service = require("@game/ReplicatedStorage/code/class/service/Service")
const class_names = require "@game/ReplicatedStorage/code/static/class_names"

const private = {}
const class = {__index = Service}
setmetatable(class, class)

export type class = typeof(class)
export type default_stored_type = setmetatable<{[any]: any}, {__mode: string?}>

class.type = class_names.storage

private.stored_lazy_keys = setmetatable({} :: {[object.class]: default_stored_type?}, {__mode = 'ks'})
private.stored_lazy_values = setmetatable({} :: {[object.class]: default_stored_type?}, {__mode = 'ks'})
private.stored_lazy_all = setmetatable({} :: {[object.class]: default_stored_type?}, {__mode = 'ks'})
private.stored_strong = setmetatable({}::{[object.class]: default_stored_type}, {__mode = "ks"})

function class.get_for(this: object.class, mode)
    if (mode == StorageMode.LazyKeys) then
        return private.stored_lazy_keys[this]
    elseif (mode == StorageMode.LazyValues) then
        return private.stored_lazy_values[this]
    elseif (mode == StorageMode.LazyAll) then
        return private.stored_lazy_all[this]
    elseif (mode == StorageMode.Strong) then
        return private.stored_strong[this]
    else
        return error("unexpected StorageMode enum")
    end
end

function class.set_for (this: object.class, mode)
    if (mode == StorageMode.LazyKeys) then
        private.stored_lazy_keys[this] = setmetatable({}, {__mode='ks'})
        return private.stored_lazy_keys[this] :: default_stored_type
    elseif (mode == StorageMode.LazyValues) then
        private.stored_lazy_keys[this] = setmetatable({}, {__mode='vs'})
        return private.stored_lazy_values[this] :: default_stored_type
    elseif (mode == StorageMode.LazyAll) then
        private.stored_lazy_keys[this] = setmetatable({}, {__mode='kvs'})
        return private.stored_lazy_all[this] :: default_stored_type
    elseif (mode == StorageMode.Strong) then
        private.stored_strong[this] = {}
        return private.stored_strong[this] :: default_stored_type
    else
        return error("unexpected StorageMode enum")
    end
end

function class.get_forced (this: object.class, mode) : default_stored_type
    const stored = class.get_for(this, mode)
    if (not stored) then
        return class.set_for(this, mode)
    else
        return stored
    end
end

return table.freeze(class)