Подробности о функционале той или иной части кода указывай и читай в `declare.luau`

```luau
    --!strict

    const declare = require("@game/ReplicatedStorage/code/static/declare")
    const namefield = require("@game/ReplicatedStorage/code/static/namefield")

    const private = {}
    const class: declare.Тип_Класса = Родитель:new({
        type = namefield.Имя_Класса,

        get_something = function (self: Тип_Класса) : ()
            
        end
    })

    class:toggle_host(function(new: Тип_Класса)
        
    end)

    do
        type private_type = {

        }

        private.table = {}

        function private.do_something (...: unknown)
            
        end
    end


    return class
```