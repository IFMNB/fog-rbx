const Disposable = require("@game/ReplicatedStorage/code/Disposable")
const Value = require "@game/ReplicatedStorage/code/class/value/Value"
const Processor = require("@game/ReplicatedStorage/code/class/processor/Processor")
const Upload = require("@game/ReplicatedStorage/code/class/upload/Upload")
const StorageMode = require("@game/ReplicatedStorage/code/enums/StorageMode")
const object = require("@game/ReplicatedStorage/code/object")
const storage = require("@game/ReplicatedStorage/code/class/storage/Storage")
const Entity = require("../entity/Entity")
const namefield = require("@game/ReplicatedStorage/code/static/namefield")

const private = {}
const class = {__index = Processor}
setmetatable(class, class)

export type class = typeof(class.new())

class.type = namefield.item
class.description = "default_description"
class.free_on_empty = false
class.max = 1


function class.new ()
    return Disposable.new(class, true)
end

function class:get_count () :  Value.generic<number>
    const this = self :: class
    return Upload.fetch(private.metadata:fetch(this), "count", function ()
        return Value.new("number")
    end)
end

function class:get_stats()
    const this = self :: class
    return Upload.fetch(private.metadata:fetch(this), "entity", Entity)
end

function class:get_()
    const this = self :: class
    
end

private.metadata = storage.new (StorageMode.Strong)

return table.freeze(class)