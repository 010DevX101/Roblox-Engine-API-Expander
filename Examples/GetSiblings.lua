local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Instances = require(ReplicatedStorage.Instances)
local workspace = Instances:Register(workspace)
print(workspace:GetSiblings())