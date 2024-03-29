local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Instances = require(ReplicatedStorage.Instances)
local Camera = Instances:Register(workspace.Camera)
Camera.SiblingAdded:Connect(function(sibling)
	print(sibling)
end)
Camera.SiblingAdded:Once(function(sibling)
	print(sibling)
end)
repeat task.wait() until Camera.SiblingAdded:Wait()
print("A sibling has been added!")