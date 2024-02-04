local Folder = workspace.Folder
local Instances = require(script.Parent.Parent)

for i,v in pairs(Instances:GetChildrenOfClass(Folder, "IntValue")) do
	print(v.Value)
end