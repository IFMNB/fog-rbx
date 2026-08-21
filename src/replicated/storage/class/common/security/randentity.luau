--!strict
const Cryptography = require("@game/ReplicatedStorage/dependency/Cryptography")
const runtimeobject = require("@game/ReplicatedStorage/runtimeobject")
const declare = require("@game/ReplicatedStorage/static/declare")
const namefield = require("@game/ReplicatedStorage/static/namefield")

const class : declare.randentity = runtimeobject:new {
    type = namefield.randentity,
    input = "" :: unknown,
    output = nil :: declare.randentity?,

    get_now = function (self: declare.randentity, prebake: boolean?) : declare.randentity
        const randentity_new = self:renew()
        randentity_new.input = Cryptography.Verification.EdDSA.CSPRNG.RandomBytes(32)
        
        if prebake then
            randentity_new:to_blake3()
        end

        return randentity_new
    end,

    to_blake3 = function (self: declare.randentity) : ()
    	const converted = (type(self.input) ~= "buffer" and buffer.fromstring(tostring(self.input)) or self.input) :: buffer
        const randentity_new = self:renew({
            input = Cryptography.Hashing.Blake3.Digest(converted)
        })

        self.output = randentity_new
    end,

    to_sha256 = function (self: declare.randentity) : ()
        const converted = (type(self.input) ~= "buffer" and buffer.fromstring(tostring(self.input)) or self.input) :: buffer
        const randentity_new = self:renew({
            input = Cryptography.Hashing.SHA2.SHA256(converted)
        })

        self.output = randentity_new
    end
}

return class