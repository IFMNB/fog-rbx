const Disposable = require("../../Disposable")
const StorageMode = require("../../enums/StorageMode")
const object = require("../../object")
const namefield = require("../../static/namefield")
const project = require("../../static/project")
const Storage = require("../storage/Storage")
const Upload = require("../upload/Upload")

const private = {}
const class = {}
setmetatable(class, {__index = Disposable})

export type class = object.class<typeof(class)>
export type generic<T = Instance> = object.generic<{
    hold: (self: unknown, that: T) -> (),
    get_holder: (self: unknown) -> T?
    -- NOTE: T ~= T? || T -> T?
},typeof(class)>

class.type = namefield.wrapper

function class.new (wrap: Instance?)
    const this = Disposable.new(class, true)
    if (wrap) then
        this:hold(wrap)
    end

    this:watch_free_event(function()
        private.linked_to[this] = nil
        const instance = this:get_holder()
        if (instance) then
            const metadata = private.holders:fetch(instance)
            table.remove(metadata, table.find (metadata, this))
        end
    end)
    return this
end

function class:hold(that: Instance)
    const this = self :: class

    if (table.isfrozen(this)) then
        project.console_output("cannot change frozen wrapper")
        return
    end

    const metadata_for_that_instance = private.holders:fetch(that, StorageMode.LazyValues, function(new)
        that.Destroying:Once(function()
            for i: number,v in private.holders:fetch(that) :: {class} do
                v:queue_free()
            end
            private.holders:remove(that)
        end)
    end)
    const previous_holder = private.linked_to[this]

    if (previous_holder) then
        const metadata_for_previous_instance = private.holders:fetch(previous_holder)
        table.remove(metadata_for_previous_instance, table.find (metadata_for_previous_instance, this))
    end

    private.linked_to[this] = that
    if (not table.find(metadata_for_that_instance, this)) then
        table.insert(metadata_for_that_instance, this)
    end
end

function class:get_holder()
    const this = self :: class
    return private.linked_to[this]
end

function class.find_wrapper_that_holds_that(instance: Instance, at: {[unknown]: unknown}) : class?
    for i,v in at do
        if (object.is(v, class.type)) then
            const wrap = v :: class
            if (wrap:get_holder() == at) then
                return wrap
            end
        end
    end

    return nil
end

function class.get_global_wrap (to: Instance)
    return private.global_likns:fetch(to, class.new, function(new: class)
        new:hold(to)
        table.freeze(new)

        to.Destroying:Once(function()
            private.global_likns:clear(to)
        end)
        new:watch_free_event(function()
            private.global_likns:clear(to)
        end)
    end)
end

private.global_likns = Upload.new() -- {[instance]: class}
private.holders = Storage.new() -- {[gc_linkable]: {class}}
private.linked_to = Storage.create_table_with(StorageMode.LazyKeys) :: {[class]: Instance?}

return table.freeze(class)