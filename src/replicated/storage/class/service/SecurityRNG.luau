--!strict
const Service = require("@game/ReplicatedStorage/class/arch/Service")
const Cryptography = require("@game/ReplicatedStorage/dependency/Cryptography")
const dservice = require("@game/ReplicatedStorage/static/dservice")

const class : dservice.securityrng = Service:new {
    seed = DateTime.now().UnixTimestampMillis :: unknown, 
    
    get_hash_sha256 = function (self: dservice.securityrng, element: string) : string
        const out = Cryptography.Hashing.SHA2.SHA256(buffer.fromstring(tostring(element)))

        return out
    end,

    get_hash_blake3 = function (self: dservice.securityrng, element: string) : string
	    const out = Cryptography.Hashing.Blake3.Digest(buffer.fromstring(tostring(element)))
        return out
    end,

    get_uid = function (self: dservice.securityrng) : unknown
        return Cryptography.Utilities.RandomString(128, false)
    end
}

return class