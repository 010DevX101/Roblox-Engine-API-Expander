local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Instances = require(ReplicatedStorage.Instances)
local Terrain = Instances:Register(workspace.Terrain)
Terrain.SiblingRemoved:Connect(function(sibling)
	print(sibling)
end)
Terrain.SiblingRemoved:Once(function(sibling)
	print(sibling)
end)
repeat task.wait() until Terrain.SiblingRemoved:Wait()
print("A sibling has been removed!")