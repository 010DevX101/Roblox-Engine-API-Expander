local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Instances = require(ReplicatedStorage.Instances)
local SpawnLocation = Instances:Register(workspace.SpawnLocation)
print(SpawnLocation:IsSiblingOf(workspace.Baseplate))