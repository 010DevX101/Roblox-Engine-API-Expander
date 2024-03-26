local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Instances = require(ReplicatedStorage.Instances)
local Terrain = Instances:Register(workspace.Terrain)
print(Terrain:FindFirstSiblingWhichIsA("BasePart"))