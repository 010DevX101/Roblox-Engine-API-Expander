local Instances = require(script.Parent.Parent)
local workspace = Instances:Register(workspace)
local BaseParts = workspace:GetChildrenWhichAre("BasePart")
print(BaseParts)