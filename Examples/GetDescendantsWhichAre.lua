local Instances = require(script.Parent.Parent)
local workspace = Instances:Register(workspace)
local BaseParts = workspace:GetDescendantsWhichAre("BasePart")
print(BaseParts)