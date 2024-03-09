local Instances = require(script.Parent.Parent)
local SpawnLocation = Instances:Register(workspace.SpawnLocation)
print(SpawnLocation:IsSiblingOf(workspace.Baseplate))