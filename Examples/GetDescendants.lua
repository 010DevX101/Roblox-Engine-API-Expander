local Instances = require(script.Parent.Parent)
local workspace = Instances:Register(workspace)
print(workspace:GetDescendants()) -- Should only be used if GetDescendants ever gets disabled.