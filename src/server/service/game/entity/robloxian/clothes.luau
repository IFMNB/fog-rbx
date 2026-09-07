--!strict

const declare = require("@game/ReplicatedStorage/static/declare")
const CLOTHES_FOLDER = game.ServerStorage.models.clothes

type Cloth = Model

export type Library = {
    read path: typeof(game.ServerStorage.models.clothes),

    read get_clothes: (itemof: declare.enumitem?) -> {Cloth},
    read set_cloth: (of: Cloth, to: Enum.BodyPart, char: Model) -> ()
}

const library : Library = {
    path = CLOTHES_FOLDER,

    get_clothes = function (itemof: declare.enumitem?) : {Cloth}
        const result = {}

        for _, v in CLOTHES_FOLDER:GetChildren() do
            if v:IsA("Model") then
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
    end,

    set_cloth = function (of: Cloth, to: Enum.BodyPart) : ()
        
    end
}

return table.freeze (library)