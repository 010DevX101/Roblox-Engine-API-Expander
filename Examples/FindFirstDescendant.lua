local Instances = require(script.Parent.Parent)
local workspace = Instances:Register(workspace)
print(workspace:FindFirstDescendant("Decal")) -- Should only be used if FindFirstDescendant gets disabled