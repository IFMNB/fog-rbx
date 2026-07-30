--!strict

local base = setmetatable({}, {})
local alpha = setmetatable({}, {__index = base})
local beta = setmetatable({}, {__index = alpha})

type base = typeof(base)
type alpha = typeof(alpha)
type beta = typeof(beta)
type T = beta & alpha & base
type U = setmetatable<{feta: string},{__index:T}> & T
type E = setmetatable<{geta: number},{__index:U}> & U

base.foo = ""
alpha.bar = false
beta.test = 3

local x : T
x.bar = false -- OK
local y : U
y.feta = "" -- OK
local z : E
z.geta = 4 -- OK

type gamma = {x: (a: number) -> string}
type fat = {x: (...any) -> any}
type Y = gamma & fat

local c : Y
c.x(3)