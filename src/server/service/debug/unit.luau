const Players = game:GetService("Players")
const User = require("@game/ReplicatedStorage/class/local/User")

Players.PlayerAdded:Connect(function(a0: Player)
    const user = User:new({uid = a0.User.Id})
    
    a0.CharacterAdded:Connect(function(a0: Model)

    end)

    
end)

return true