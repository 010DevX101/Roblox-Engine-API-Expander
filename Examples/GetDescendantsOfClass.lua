local Rig = workspace.Rig
local Instances = require(script.Parent.Parent)

for _,attachment in pairs(Instances:GetDescendantsOfClass(Rig, "Attachment")) do
	print(attachment.Parent)
end