local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Instances = require(ReplicatedStorage.Instances)
local Folder = Instances:Register(workspace.Folder)

for i,v in pairs(Folder:GetChildrenOfClass("IntValue")) do
	print(v.Value)
end