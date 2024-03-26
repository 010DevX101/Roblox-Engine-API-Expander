local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Instances = require(ReplicatedStorage.Instances)
local Rig = Instances:Register(workspace)

local Humanoid = Rig:WaitForChildWhichIsA("Humanoid") -- If timeOut is unspecified it'll default to 5
local BasePart = Rig:WaitForChildWhichIsA("BasePart", 15)
print(Humanoid, BasePart)