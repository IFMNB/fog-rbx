--!strict
const Service = require("@game/ReplicatedStorage/class/core/Service")
const Cryptography = require("@game/ReplicatedStorage/dependency/Cryptography")

const class: securityrng = Service:new {
    seed = os.clock() :: number, 
    
    get_hash_sha256 = function (self: securityrng, element: string) : string
        const out = Cryptography.Hashing.SHA2.SHA256(buffer.fromstring(tostring(element)))

        return out
    end,

    get_hash_blake3 = function (self: securityrng, element: string) : string
	    const out = Cryptography.Hashing.Blake3.Digest(buffer.fromstring(tostring(element)))
        return out
    end,

    get_uid = function (self: securityrng) : string
        return Cryptography.Utilities.RandomString(128, false) :: string
    end
}

return class