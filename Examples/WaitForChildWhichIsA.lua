local Instances = require(script.Parent.Parent)
local Rig = Instances:Register(workspace.Rig)

local Humanoid = Rig:WaitForChildWhichIsA("Humanoid") -- If timeOut is unspecified it'll default to 5
local BasePart = Rig:WaitForChildWhichIsA("BasePart", 15)
print(Humanoid, BasePart)