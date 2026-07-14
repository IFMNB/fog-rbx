const config_names = {
    browser_list_size = "",
    browser_list_update_time = "",
    browser_environment_update_time = ""
}

export type config_names = keyof<names_dictionary> 
export type names_dictionary = typeof(config_names)

return table.freeze(config_names)