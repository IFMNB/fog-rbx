const project = {}

project.NodeProcessHertz = 1 / 60
project.DebugMode = game["Run Service"]:IsStudio()

return table.freeze(project)