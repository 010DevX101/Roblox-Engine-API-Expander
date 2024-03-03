local Instances = require(script.Parent.Parent)
local Folder = Instances:Register(workspace.Folder)

for i,v in pairs(Folder:GetChildrenOfClass("IntValue")) do
	print(v.Value)
end