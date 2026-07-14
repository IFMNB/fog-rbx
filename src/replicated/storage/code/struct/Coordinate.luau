const object = require("../object")
const namefield = require("../static/namefield")
const record = require("../Record")

const struct = {__index = record}
setmetatable(struct, struct)

export type struct = object.class<typeof(struct)>

struct.type = namefield.coordinate
struct.right = Vector3.zero
struct.up = Vector3.zero
struct.front = Vector3.zero

function struct.new (right: Vector3?, up: Vector3?, front: Vector3?)
    const this = object.new(struct)

    this.right = right
    this.up = up
    this.front = front
    
    return this
end

function struct:inverted()
    return struct.new(-self.right, -self.up, -self.front)
end

function struct:multiple(with)
    return struct.new(self.right * with.X, self.up * with.Y, self.front * with.Z)
end

function struct:abs ()
    const this = self :: struct
    return struct.new(this.right:Abs(), this.up:Abs(), this.front:Abs())
end

function struct:unit ()
    return struct.new(self.right.Unit, self.up.Unit, self.front.Unit)
end

function struct:unpack ()
    const this = self :: struct
    return {this.right, this.up, this.front}
end

function struct:to_cframe ()
    const this = self :: struct
    return CFrame.fromMatrix(Vector3.zero, this.right, this.up, this.front)
end

function struct:to_vector3 ()
    const this = self :: struct
    return Vector3.new(this.right, this.up, this.front)
end

function struct:to_vector2 ()
    const this = self :: struct
    return Vector2.new(this.right, this.up)
end

struct.one = struct.new(Vector3.xAxis, Vector3.yAxis, Vector3.zAxis):immutable()

return table.freeze(struct)