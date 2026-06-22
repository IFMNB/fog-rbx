const object = require("@game/ReplicatedStorage/code/object")
const StorageMode = require("../../enums/StorageMode")
const Storage = require("@game/ReplicatedStorage/code/service/storage/Storage")
const class_names = require("@game/ReplicatedStorage/code/static/class_names")

const private = {}
const class = {}
setmetatable(class, {__index = object})

export type class = typeof(class.new())

class.type = class_names.upload

private.metadata = Storage.create_table_with(StorageMode.LazyKeys) :: {[class]: {
    lazy: {[unknown]: unknown}
}}

function class.new ()
    const this = object.new(class, true)
    private.metadata[this] = {
        lazy = {}
    }
    return this
end

function class:is_exists(key)
    const this :class = self
    const metadata = private.metadata[this]
    return metadata.lazy[key] ~= nil
end

function class:get(key)
    const this : class = self
    const metadata = private.metadata[this]
    return metadata.lazy[key]
end

function class:fetch_class <T> (key, class: {new: () -> T}) : T
    const this : class = self
    const metadata= private.metadata[this]
    local lazy_instance = metadata.lazy[key]
    const new = class.new

    if (lazy_instance) then
        return lazy_instance
    else
        const new_instance = new()

        class:watch_free_event(function()
            new_instance:free()
            metadata.lazy_event[key] = nil
        end)

        metadata.lazy_event[key] = new_instance
        return new_instance
    end
end

return table.freeze(class)