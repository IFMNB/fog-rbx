const Disposable = require("@game/ReplicatedStorage/code/Disposable")
const Event = require("@game/ReplicatedStorage/code/class/event/Event")
const Storage = require("@game/ReplicatedStorage/code/class/storage/Storage")
const Upload = require("@game/ReplicatedStorage/code/class/upload/Upload")
const StorageMode = require("@game/ReplicatedStorage/code/enums/StorageMode")
const object = require("@game/ReplicatedStorage/code/object")
const Round = require("@game/ServerStorage/code/class/round/Round")
const WarfareState = require("@game/ServerStorage/code/enums/WarfareState")
const Faction = require("@game/ServerStorage/code/class/faction/Faction")
const namefield = require("@game/ReplicatedStorage/code/static/namefield")
const project = require("@game/ReplicatedStorage/code/static/project")

const private = {}
const class = {}
setmetatable(class, {__index = Disposable})

export type class = object.class<typeof(class)>

class.type = namefield.warfare

class.shots_over_warfare = 0
class.deaths_over_warfare = 0
class.completed_rounds = 0

class.state = WarfareState.ChoiceBattleground
class.round_changed = (nil::any) :: Event.class

function class.new ()
    const this = Disposable.new(class, true)
    return this
end

function class:get_factions ()
    const this = self :: class
    
end

private.metadata = Storage.new()

return table.freeze(class)