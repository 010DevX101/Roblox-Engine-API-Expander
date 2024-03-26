local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Instances = require(ReplicatedStorage.Instances)
local workspace = Instances:Register(workspace)
print(workspace:GetDescendants()) -- Should only be used if GetDescendants ever gets disabled.