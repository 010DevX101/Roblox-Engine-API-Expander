local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Instances = require(ReplicatedStorage.Instances)
local workspace = Instances:Register(workspace)
print(workspace:FindFirstDescendant("Decal")) -- Should only be used if FindFirstDescendant gets disabled