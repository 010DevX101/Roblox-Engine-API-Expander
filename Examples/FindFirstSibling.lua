local Instances = require(script.Parent.Parent)
local Camera = Instances:Register(workspace.Camera)
print(Camera:FindFirstSibling("Terrain"))