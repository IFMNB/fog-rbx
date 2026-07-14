--!strict

const AssetService = game:GetService("AssetService")
const object = require "@game/ReplicatedStorage/code/object"
const Disposable = require("../../Disposable")
const project = require("../../static/project")
const Result = require("../../struct/Result")
const AssetRequireType = require("../../enums/AssetRequireType")
const Storage = require("../storage/Storage")
const namefield = require "@game/ReplicatedStorage/code/static/namefield"

const private = {}
const class = {}
setmetatable(class, {__index = Disposable})

export type class <T = unknown> = object.generic<{
    get_asset: (self: unknown) -> Result.class<T>
}, typeof(class)>

class.type = namefield.asset
class.required = 0
class.cached = Result


function class.new ()
    const this = Disposable.new(class)
    return this
end

function class:set_require_type (asset_require_type: number?)
    private.metadata:fetch(self).require_type = asset_require_type or AssetRequireType.Unknown
end

function class:get_require_type () : number
    return private.metadata:fetch(self).require_type or AssetRequireType.Unknown
end

function class:is_expected_required_type (with: number?) : boolean
    const required_type = self:get_require_type()
    return with and required_type == with or required_type == AssetRequireType.Unknown
end

--[[Конкатенация ID ассета в полноценный URI типа rbxassetid://1234567890]]
@[deprecated {
    use = "Roblox API: Content",
    reason = "Новый API Content унифицирован и определенно может заменить assetid. Некоторые RbxAPI, впрочем, могут его не поддерживать",
}]
function class:get_roblox_uri ()
    return "rbxassetid://"..tostring(self.required)
end

function class:get_asset () : Result.class
    const this = self :: class
    const loader = private.loaders[this:get_require_type()] or private.loaders[AssetRequireType.Unknown]
    
    if (this.required == 0) then
        project.console_output "Asset.class @required == 0, abort"
        return this.cached
    end

    if (this.cached ~= Result) then
        Disposable.queue_free(this.cached)
    end

    this.cached = Result.call_of(loader, this)
    return this.cached
end

private.loaders = table.freeze {
    [AssetRequireType.Animation] = function (this: class)
        const result = Instance.new "Animation"
        result.AnimationContent = Content.fromAssetId(this.required)
        return result
    end,
    [AssetRequireType.Image] = function (this: class)
        const result = Instance.new "ImageLabel"
        result.ImageContent = Content.fromAssetId(this.required)
        return result
    end,
    [AssetRequireType.Mesh] = function (this: class)
        return AssetService:CreateMeshPartAsync(Content.fromAssetId(this.required))
    end,
    [AssetRequireType.Model] = function (this: class)
        return AssetService:LoadAssetAsync(this.required)
    end,
    [AssetRequireType.Module] = function (this: class)
        return require(this:get_roblox_uri()) :: unknown
    end,
    [AssetRequireType.Sound] = function (this: class)
        const result = Instance.new "Sound"
        result.SoundId = this:get_roblox_uri()
        return result        
    end,
    [AssetRequireType.Unknown] = function (this: class)
        return project.console_output "unknown AssetRequireType"
    end
}
private.metadata = Storage.new()

return table.freeze(class)