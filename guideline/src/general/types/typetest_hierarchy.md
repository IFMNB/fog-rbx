```luau

    --!strict

    const testobject = {}
    testobject.__index = testobject
    const testbase = {}
    setmetatable(testobject, {__index=testobject})
    const test = {}
    setmetatable(test, {__index=testbase})

    export type testobject_line<T={}, U=typeof(testobject)> = T&U
    export type testbase_line = testobject_line<typeof(testbase)>
    export type test = testobject_line<typeof(test),testbase_line>

    test.to = {} :: {string}
    test.type = "" :: "literal"|string
    test.is = function () return true end

    function test.new <T,U,E> (a0: T, a1: U) : setmetatable<{}, {__index: T}>
        return setmetatable({}, {__index=a0})
    end

    function test.new2<T, U, E>(a0: T, a1: U): testobject_line<T>
        return setmetatable({} :: T, { __index = a0 })
    end



    local self = nil :: unknown

    do
        
        -- we have sealed table here, and this table isn't exists in our type-hierarchy: definitely an instance
            local a0 = test.new(test, "")
            local a00: { string } = a0.to -- OK
            for i, v in a0.to do
            end -- OK
            local this0 = self :: typeof(a0) -- OK
            a0.type = "" -- OK
            a0.is = function() end  -- not OK, '(...any) -> boolean' ~= '(...any) -> ()', so in intersection we got a `never`-error
            a0.f = 4 -- sealed type

        -- we have a sealed table here, so we expect this table cannot be changed and it's exacty a test-compatible type
            local a1 = test.new(test, "") :: test -- not OK -- TypeError: Cannot cast '{ @metatable { __index: { @metatable { __index: testbase }, test } }, {  } }' into 'testbase & { @metatable { __index: testobject }, testobject } & { @metatable { __index: testbase }, test }' because the types are unrelated
            local a01: { string } = a1.to -- OK
            for i, v in a1.to do
            end -- OK
            local this1 = self :: test -- OK
            a1.type = "" -- OK
            a1.is = function() end  -- OK, '(...any) -> boolean' ~= '(...any) -> ()'
            a1.f = 4 -- sealed type


        -- we have a unsealed table here, but our hierarchy does not have a member with that type-declaration, so this table does not exists in test     
            local a2 = test.new(test, "") :: testobject_line<setmetatable<{}, { __index: test }>, testbase_line> -- OK
            local a02: { string } = a2.to -- OK
            for i, v in a2.to do
            end -- OK
            local this1 = self :: test -- OK
            a2.type = "" -- OK
            a2.is = function() end  -- not OK, '(...any) -> boolean' ~= '(...any) -> ()', so in intersection we got a `never`-error
            a2.f = 4 -- unsealed type

        local function test_intersect_3(_: test) end
        local function test_intersect_2(_: testbase_line) end
        local function test_intersect_1(_:testobject_line) end
        
        test_intersect_1(a0) -- not OK, a0 ~= test and a0 ~= child of hierarchy
        test_intersect_1(a1) -- OK, a1 inherits testobject_lnie, a1 == test
        test_intersect_1(a2) -- OK, a2 inherits testobject_line, but a2 ~= test

        test_intersect_2(a0) -- not OK, a0 ~= test and a0 ~= child of hierarchy
        test_intersect_2(a1) -- OK, a1 inherits testbase_line (first inherit)
        test_intersect_2(a2) -- OK, a2 inherits testbase_line (second inherit)

        test_intersect_3(a0) -- not OK, a0 ~= test and a0 ~= child of hierarchy
        test_intersect_3(a1) -- OK, a1 inherits testbase_line
        test_intersect_3(a2) -- FAILED as expected. `a2` is structurally compatible with `test`, but it is a distinct table type with different metatable information.
    end


    do 
        
            local a0 = test.new2(test, "")
            local a00: { string } = a0.to -- OK
            for i, v in a0.to do
            end -- OK
            local this0 = self :: typeof(a0) -- OK
            a0.type = "" -- OK
            a0.is = function() end -- OK, we can't change our type '(...any) -> boolean' to unsupported 
            a0.f = 4 -- sealed type

        -- we have a sealed table here, so we expect this table cannot be changed and it's exacty a test-compatible type
            local a1 = test.new2(test, "") :: test -- now OK, because our testobject_line currently exists
            local a01: { string } = a1.to -- OK
            for i, v in a1.to do
            end -- OK
            local this1 = self :: test -- OK
            a1.type = "" -- OK
            a1.is = function() end -- now OK, we can't change our type '(...any) -> boolean' to unsupported 
            a1.f = 4 -- sealed type


        -- we have a unsealed table here, but our hierarchy does not have a member with that type-declaration, so this table does not exists in test     
            local a2 = test.new(test, "") :: testobject_line<setmetatable<{}, { __index: test }>, testbase_line> -- OK
            local a02: { string } = a2.to -- OK
            for i, v in a2.to do
            end -- OK
            local this1 = self :: test -- OK
            a2.type = "" -- OK
            a2.is = function() end -- not OK, '(...any) -> boolean' ~= '(...any) -> ()', so in intersection we got a `never`-error
            a2.f = 4 -- unsealed type

        local function test_intersect_3(_: test) end
        local function test_intersect_2(_: testbase_line) end
        local function test_intersect_1(_:testobject_line) end
        
        test_intersect_1(a0) -- now OK, a0 extended by testobject_line from testbase_line and exists in hierarchy
        test_intersect_1(a1) -- OK, a1 inherits testobject_lnie, a1 == test
        test_intersect_1(a2) -- OK, a2 inherits testobject_line, but a2 ~= test

        test_intersect_2(a0) -- now OK, a0 extended by testbase_line and exists in hierarchy
        test_intersect_2(a1) -- OK, a1 inherits testbase_line (first inherit)
        test_intersect_2(a2) -- OK, a2 inherits testbase_line (second inherit)

        test_intersect_3(a0) -- now OK, a0 == test
        test_intersect_3(a1) -- OK, a1 inherits testbase_line
        test_intersect_3(a2) -- FAILED as expected. `a2` is structurally compatible with `test`, but it is a distinct table type with different metatable information.
    end



    const base = {}
    base.__index = base
    const class = {}
    setmetatable(class, { __index = base })

    export type line<T = {}, U = typeof(class)> = T & U

    function class.new<T>(a0: T): line<T>
        return setmetatable({} :: T, { __index = a0 })
    end

    function base:is()
        const a = self :: line
    end

    return table.freeze(class)
```