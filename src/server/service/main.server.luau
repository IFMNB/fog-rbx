--!strict
const Players = game:GetService("Players")

-- pseudo code template (do not use it)

const ConnectionVariant = require("@game/ReplicatedStorage/enums/descriptor/ConnectionVariant")
const RoundState = require("@game/ReplicatedStorage/enums/state/RoundState")

const root = "@game/ServerScriptService/"

const round : round
const faction : faction

const NEW_ROUND = round:new()
const WHITE_EMPIRE = faction:new()
const RED_UNION = faction:new()

NEW_ROUND:add_faction(WHITE_EMPIRE)
NEW_ROUND:add_faction(RED_UNION)

NEW_ROUND:get_states():subscribe(RoundState.Ending, ConnectionVariant.Ever, function ()
    print "round ending"
end)

NEW_ROUND:get_control():continue()

Players.PlayerAdded:Connect(function(a0: Player)
    a0.CharacterAdded:Connect(function(a0: Model)
        const count_WE = #WHITE_EMPIRE:get_member()
        const count_RU = #RED_UNION:get_member() 

        if count_WE > count_RU then
            RED_UNION:add_member()
        elseif 
            WHITE_EMPIRE:add_member() then
        else
            WHITE_EMPIRE:add_member()
        end
    end)
end)
