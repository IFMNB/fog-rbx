--!strict

const declare = require("@game/ReplicatedStorage/static/declare")
const CLOTHES_FOLDER = game.ServerStorage.models.clothes

export type Library = {
    read path: typeof(game.ServerStorage.models.clothes),
    read get_clothes: (itemof: declare.enumitem?) -> {Folder}
}

const library : Library = {
    path = CLOTHES_FOLDER,

    get_clothes = function (itemof: declare.enumitem?) : {Folder}
        const result = {}

        for _, v in CLOTHES_FOLDER:GetChildren() do
            if v:IsA("Folder") then
                if itemof then
                    if v:HasTag(itemof.hashlink) then
                        table.insert(result, v)
                    end
                else
                    table.insert(result, v)
                end
            end
        end

        return result
    end
}

return table.freeze (library)