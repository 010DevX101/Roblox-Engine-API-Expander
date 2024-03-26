local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Instances = require(ReplicatedStorage.Instances)
local Rig = Instances:Register(workspace.Rig)

for _,attachment in pairs(Rig:GetDescendantsOfClass("Attachment")) do
	print(attachment.Parent)
end