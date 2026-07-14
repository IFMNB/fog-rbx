const cfgfield = {}

do --configs
    --[=[

    ]=]

    --[=[
        Браузер возвращает список размером в указанное количество единиц
    ]=]
    cfgfield.browser_list_size = ""

    --[=[
        Браузер обновляет список серверов раз в указанное время
    ]=]
    cfgfield.browser_list_update_time = ""
        
    --[=[
        Браузер обновляет данные сервера раз в указанное время

        `Environment` - это окружение сервера, то есть данные о его количестве
        игроков внутри и состоянии на данный момент
    ]=]
    cfgfield.browser_environment_update_time = ""
end

export type names = keyof<dictionary> 
export type dictionary = typeof(cfgfield)

return table.freeze(cfgfield)