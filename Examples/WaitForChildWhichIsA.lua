local Rig = workspace.Rig
local Instances = require(script.Parent.Parent)

local Humanoid = Instances:WaitForChildWhichIsA(Rig, "Humanoid") -- If timeOut is unspecified it'll default to 5
local BasePart = Instances:WaitForChildWhichIsA(Rig, "BasePart", 15)
print(Humanoid, BasePart)