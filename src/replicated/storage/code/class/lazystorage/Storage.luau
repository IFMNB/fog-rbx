--!strict

const object = require("@game/ReplicatedStorage/code/object")
const Disposable = require("../../Disposable")
const project = require("../../static/project") -- TODO
const Liberator = require("../../struct/Liberator")
const StorageMode = require("@game/ReplicatedStorage/code/enums/StorageMode")
const namefield = require "@game/ReplicatedStorage/code/static/namefield"

const private = {}
const class = {}
setmetatable(class, {__index = Disposable})

export type class = Disposable.extend<typeof(class)>
export type extend<T = {}> = object.class<T, class>

export type default_stored_type = setmetatable<{[any]: any}, {__mode: string?}>
type stored = setmetatable<{[expected_type]:default_stored_type?}, typeof(class.metatable_with_mode_ks)>
type metadata = {
    stored_lazy_keys: stored,
    stored_lazy_values: stored,
    stored_lazy_all: stored,
    stored_strong: stored,
    on_create_rule: create_rule_func?
}
type expected_type = any
type create_rule_func = (created: default_stored_type, storage_mode: number) -> ()


--[=[
    `Storage` - основное хранилище приватной информации для любых конструкторов и классов,
    применяющееся в качестве основы работы `Upload.class` и реализующее самоочистку данных
    как для `object.class`, так и для `Disposable.class`
]=]
class.type = namefield.storage

class.metatable_with_mode_ks = table.freeze {__mode = "ks"} :: {__mode: "ks"|string}
class.metatable_with_mode_vs = table.freeze {__mode = "vs"} :: {__mode: "vs"|string}
class.metatable_with_mode_kvs = table.freeze {__mode = "kvs"} :: {__mode: "kvs"|string}
class.metatable_with_mode_s = table.freeze {__mode = "s"} :: {__mode: "s"|string}

private.metadata = setmetatable({}::{[class]: metadata}, class.metatable_with_mode_ks)

function class.new ()
    const this = Disposable.new(class, true)

    private.metadata[this] = {
        stored_lazy_keys = class.create_table_with(StorageMode.LazyKeys),
        stored_lazy_values = class.create_table_with(StorageMode.LazyValues),
        stored_lazy_all = class.create_table_with(StorageMode.LazyAll),
        stored_strong = class.create_table_with(StorageMode.Strong)
    }

    this:watch_free_event(Liberator.new(private.metadata, this, true))

    return this
end

-- Это правило всегда активируется при первом создании таблицы для хранимого объекта.
function class:setup_new_create_rule (func: create_rule_func)
    const this = self :: class
    private.metadata[this].on_create_rule = func
end

private.get = table.freeze {
    [StorageMode.LazyAll] = function (metadata: metadata, target: expected_type)
        return metadata.stored_lazy_all[target]
    end,
    [StorageMode.LazyKeys] = function (metadata: metadata, target: expected_type)
        return metadata.stored_lazy_keys[target]
    end,
    [StorageMode.LazyValues] = function (metadata: metadata, target: expected_type)
        return metadata.stored_lazy_all[target]
    end,
    [StorageMode.Strong] = function (metadata: metadata, target: expected_type)
        return metadata.stored_strong[target]
    end
}

function class:get(target: expected_type, mode: number?)
    const this = self :: class
    const metadata = private.metadata[this]
    return private.get[mode or StorageMode.Strong](metadata, target)
end

private.recreation = table.freeze {
    [StorageMode.LazyAll] = function (metadata: metadata, target: expected_type)
        const new = class.create_table_with(StorageMode.LazyAll)
        metadata.stored_lazy_all[target] = new
        return new
    end,
    [StorageMode.LazyKeys] = function (metadata: metadata, target: expected_type)
        const new = class.create_table_with(StorageMode.LazyKeys)
        metadata.stored_lazy_keys[target] = new
        return new
    end,
    [StorageMode.LazyValues] = function (metadata: metadata, target: expected_type)
        const new = class.create_table_with(StorageMode.LazyValues)
        metadata.stored_lazy_values[target] = new
        return new
    end,
    [StorageMode.Strong] = function (metadata: metadata, target: expected_type)
        const new = {}
        metadata.stored_strong[target] = new
        return new
    end
}

function class:recreate(target: expected_type, mode: number?)
    const this = self :: class
    const metadata = private.metadata[this]
    const new = private.recreation[mode or StorageMode.Strong](metadata, target) :: default_stored_type
    private.emit_create_func(metadata, new, StorageMode.Strong)
    return new
end

function private.emit_create_func (metadata: metadata, new: default_stored_type, mode: number)
    if (metadata.on_create_rule) then
        metadata.on_create_rule(new, mode)
    end
end

private.remove = table.freeze {
    [StorageMode.LazyAll] = function (metadata: metadata, target: expected_type)
        const needle_table = metadata.stored_lazy_all[target]
        if (needle_table) then
            table.clear(needle_table)
        end
    end,
    [StorageMode.LazyKeys] = function (metadata: metadata, target: expected_type)
        const needle_table = metadata.stored_lazy_keys[target]
        if (needle_table) then
            table.clear(needle_table)
        end
    end,
    [StorageMode.LazyValues] = function (metadata: metadata, target: expected_type)
        const needle_table = metadata.stored_lazy_values[target]
        if (needle_table) then
            table.clear(needle_table)
        end
    end,
    [StorageMode.Strong] = function (metadata: metadata, target: expected_type)
        const needle_table = metadata.stored_strong[target]
        if (needle_table) then
            table.clear(needle_table)
        end
    end
}

function class:remove(target: expected_type, mode: number?)
    const this = self :: class
    private.remove[mode or StorageMode.Strong](private.metadata[this], target)
end

function class:fetch (target: expected_type, mode: number?, if_first_created_then_func: (new: default_stored_type) -> ()?)
    const this = self :: class
    const metadata = private.metadata[this]
    const stored = this:get(target, mode)

    if (not stored) then
        const new = this:recreate(target, mode)
        
        if (object.is(target, "object") and Disposable.is_valid(target)) then
            const object_target = target :: Disposable.class
            const release = private.release[object_target] or {} :: {() -> ()}

            if (#release ~= 0) then
                for i,v in release do
                    object_target:unwatch_free_event(v)
                end
            end

            release[1] = object_target:watch_free_event(Liberator.new(metadata.stored_lazy_all, object_target, true))
            release[2] = object_target:watch_free_event(Liberator.new(metadata.stored_lazy_keys, object_target, true))
            release[3] = object_target:watch_free_event(Liberator.new(metadata.stored_lazy_values, object_target, true))
            release[4] = object_target:watch_free_event(Liberator.new(metadata.stored_strong, object_target, true))

            private.release[object_target] = release
        end

        if (if_first_created_then_func) then
            if_first_created_then_func(new)
        end

        return new
    else
        return stored
    end
end

private.release = setmetatable({} :: {[Disposable.class]: {() -> ()}}, class.metatable_with_mode_ks)
private.creation = table.freeze {
    [StorageMode.LazyAll] = function ()
        const new = setmetatable({}, class.metatable_with_mode_kvs)
        return new :: default_stored_type
    end,
    [StorageMode.LazyKeys] = function ()
        const new = setmetatable({}, class.metatable_with_mode_kvs)
        return new :: default_stored_type
    end,
    [StorageMode.LazyValues] = function ()
        const new = setmetatable({}, class.metatable_with_mode_kvs)
        return new :: default_stored_type
    end,
    [StorageMode.Strong] = function ()
        const new = setmetatable({}, class.metatable_with_mode_s)
        return new :: default_stored_type
    end
}

function class.create_table_with (mode: number?)
    return private.creation[mode or StorageMode.Strong]()
end

function class:get_stored (in_mode: number?) : stored
    const this = self :: class
    return private.stored[in_mode or StorageMode.Strong](private.metadata[this])
end

private.stored = table.freeze {
    [StorageMode.LazyAll] = function (metadata: metadata)
        return table.clone (metadata.stored_lazy_all)
    end,
    [StorageMode.LazyKeys] = function (metadata: metadata)
        return table.clone (metadata.stored_lazy_keys)
    end,
    [StorageMode.LazyValues] = function (metadata: metadata)
        return table.clone(metadata.stored_lazy_all)
    end,
    [StorageMode.Strong] = function (metadata: metadata)
        return table.clone(metadata.stored_strong)
    end
}

return table.freeze(class)