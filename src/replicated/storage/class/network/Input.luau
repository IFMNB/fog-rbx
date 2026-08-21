--!strict
const Observable = require("@game/ReplicatedStorage/class/arch/Observable")
const Channel = require("@game/ReplicatedStorage/class/network/Channel")
const ConnectionVariant = require("@game/ReplicatedStorage/enums/descriptor/ConnectionVariant")
const InputNotification = require("@game/ReplicatedStorage/enums/notification/InputNotification")
const declare = require("@game/ReplicatedStorage/static/declare")
const namefield = require("@game/ReplicatedStorage/static/namefield")

const private = {}
const class : declare.input = Observable:new {
    type = namefield.input,
    clamped = false,
    pressed = false,
    strengh = 0.5,
    duration = 0.5,

    get_code = function (self: declare.input) : {Enum.KeyCode}
        return table.clone(private.codes[self])
    end,

    set_code = function (self: declare.input, of: Enum.KeyCode, to: boolean?) : ()
        const codes = private.codes[self]
        const pos = table.find(codes, of)

        if pos then
            if to then return end
            table.remove(codes, pos)
            self:notificate(InputNotification.CodeRemoved)
        else
            if not to then return end
            table.insert(codes, of)
            self:notificate(InputNotification.CodeAdded)
        end
    end,

    get_related = function (self: declare.input) : declare.enumitem_action_map_variant?
        return private.related[self]
    end,

    set_related = function (self: declare.input, new: declare.enumitem_action_map_variant?) : ()
        private.related[self] = new
        if new then
            self:notificate(InputNotification.RelatedChanged)
        else
            self:notificate(InputNotification.RelatedNullified)
        end
    end
}

class:host(function(new: declare.input)
    const channel = Channel:new()
    
    private.codes[new] = {}
    private.channels[new] = channel

    new:subscribe(InputNotification.RelatedChanged, ConnectionVariant.Ever,  function ()
        channel.enabled = true


    end)
    new:subscribe(InputNotification.RelatedNullified, ConnectionVariant.Ever, function ()
        channel.enabled = false
    end)
    
end)

do
    private.meta = table.freeze {__mode = "ks"}
    private.channels = setmetatable({} :: {[declare.input]: declare.channel <declare.enumitem_input_notification>}, private.meta)
    private.codes = setmetatable({} :: {[declare.input]: {Enum.KeyCode}}, private.meta)
    private.related = setmetatable({} :: {[declare.input]: declare.enumitem_action_map_variant?}, private.meta)
end

return class