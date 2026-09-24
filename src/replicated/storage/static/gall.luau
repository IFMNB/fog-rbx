--!strict
-- deprecated

export type fg_G = {
    read name: "fg_G",

    object_require: (identity: unknown, assertion: string?) -> object?
}

const fg_G: fg_G = {
    name = "fg_G"
} :: any

_G.fg_G = fg_G

return fg_G