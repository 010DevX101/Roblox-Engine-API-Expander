local API = {}

local Signal = require(script.GoodSignal)
local Http = require(script.Http)

function GetMembers(instance : Instance)
	return Http:GetMembers(instance)
end

function API:Register(i : Instance)
	local Classes = {}
	local Parent : Instance? = i.Parent
	local Members = GetMembers(i)
	if not Members then
		return Classes
	end
	for _,member in pairs(Members) do
		if member.MemberType == "Function" then
			Classes[member.Name] = function(self, ...)
				return i[member.Name](i, ...)
			end
		elseif member.MemberType == "Property" or member.MemberType == "Event" then
			Classes[member.Name] = i[member.Name]
		end
	end
	for _,child in pairs(i:GetChildren()) do
		Classes[child.Name] = child
	end
	if Parent then
		Classes["SiblingRemoved"] = Signal.new()
		Classes["SiblingAdded"] = Signal.new()
		Classes["Removing"] = Signal.new()
		Parent.ChildAdded:Connect(function(...): {Instance?}
			Classes.SiblingAdded:Fire(...)
		end)
		Parent.ChildRemoved:Connect(function(...): {Instance?}
			Classes.SiblingRemoved:Fire(...)
		end)
	end
	i.AncestryChanged:Connect(function(self, newParent) : {Instance?}
		if newParent == nil then
			Classes.Removing:Fire()
		end
	end)
	function Classes:WaitForChildWhichIsA(className, timeOut) : Instance? | nil
		local defaultTimeOut = 5
		if not timeOut then
			timeOut = defaultTimeOut
		end
		while task.wait(1) do
			if timeOut <= 0 then
				warn(`Infinite yield possible on '{i.Name}:WaitForChildWhichIsA("{className}")'`)
				return nil
			end
			for _,inst in pairs(i:GetChildren()) do
				if inst:IsA(className) then
					return inst
				end
			end
			timeOut -= 1
		end
	end
	function Classes:GetChildrenOfClass(className : string) : {Instance?}
		local instancesOfClass = {}
		for _,child in pairs(i:GetChildren()) do
			if child.ClassName == className then
				table.insert(instancesOfClass, child)
			end
		end
		return instancesOfClass
	end
	function Classes:GetDescendantsOfClass(className : string) : {Instance?}
		local descendantsOfClass = {}
		for _,descendant in pairs(i:GetDescendants()) do
			if descendant.ClassName == className then
				table.insert(descendantsOfClass, descendant)
			end
		end
		return descendantsOfClass
	end
	function Classes:GetChildrenWhichAre(t : string) : {Instance?}
		local instancesWhichAre = {}
		for _,child in pairs(i:GetChildren()) do
			if child:IsA(t) then
				table.insert(instancesWhichAre, child)
			end
		end
		return instancesWhichAre
	end
	function Classes:GetDescendantsWhichAre(t : string) : {Instance?}
		local descendantsWhichAre = {}
		for _,descendant in pairs(i:GetDescendants()) do
			if descendant:IsA(t) then
				table.insert(descendantsWhichAre, descendant)
			end
		end
		return descendantsWhichAre
	end
	function Classes:FindFirstSibling(name: string): Instance?
		return (Parent and Parent:FindFirstChild(name))
	end
	function Classes:FindFirstSiblingOfClass(class: string): Instance?
		return (Parent and Parent:FindFirstChildOfClass(class))
	end
	function Classes:FindFirstSiblingWhichIsA(className: string): Instance?
		return (Parent and Parent:FindFirstChildWhichIsA(className))
	end
	function Classes:GetSiblings(): {Instance}
		return (Parent and Parent:GetChildren())
	end
	function Classes:IsSiblingOf(sibling: Instance): boolean
		return (Parent == sibling.Parent)
	end
	return Classes
end

return API
