const project = {}

project.node_process_hertz = 1 / 60
project.default_event_behavior_is_deferred = false
project.allow_server_searching = true
project.debug_mode = game["Run Service"]:IsStudio()

return table.freeze(project)