const assetfield = {}

do --assets
    --[=[

    ]=]

    
end

export type assets = keyof<dictionary>
export type dictionary = typeof(assetfield)

return table.freeze(assetfield)