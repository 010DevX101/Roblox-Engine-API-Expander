local Instances = require(script.Parent.Parent)
local Rig = Instances:Register(workspace.Rig)

for _,attachment in pairs(Rig:GetDescendantsOfClass("Attachment")) do
	print(attachment.Parent)
end