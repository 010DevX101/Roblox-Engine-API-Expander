local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Instances = require(ReplicatedStorage.Instances)
local Camera = Instances:Register(workspace.Camera)
print(Camera:FindFirstSibling("Terrain"))