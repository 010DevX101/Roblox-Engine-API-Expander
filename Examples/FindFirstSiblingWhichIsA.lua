local Instances = require(script.Parent.Parent)
local Terrain = Instances:Register(workspace.Terrain)
print(Terrain:FindFirstSiblingWhichIsA("BasePart"))