--!strict
const declare = require("@game/ReplicatedStorage/static/declare")

export type securityrng = declare.construct<{
    seed: unknown,

    read get_hash_sha256: (self: securityrng, element: string) -> string,
	read get_hash_blake3: (self: securityrng, element: string) -> string,
    read get_uid: (self: securityrng) -> unknown,

}, declare.service>

return declare