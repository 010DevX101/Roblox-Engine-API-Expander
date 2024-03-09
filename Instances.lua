local API = {}

local Signal = require(script.GoodSignal)
local HttpService = game:GetService("HttpService")
local Url = "https://raw.githubusercontent.com/MaximumADHD/Roblox-Client-Tracker/roblox/API-Dump.json"

function GetMembers(instance : Instance)
	local members = {}
	local success, result = pcall(HttpService.GetAsync, HttpService, Url)
	if not success then
		warn("HTTP requests are disabled.")
		return
	end
	result = HttpService:JSONDecode(result)
	for _,class in pairs(result.Classes) do
		if class.Name ~= instance.ClassName and class.Name ~= "Instance" then
			continue
		end
		for _,member in pairs(class.Members) do
			if typeof(member.Tags) == "table" then
				if table.find(member.Tags, "NotScriptable") or table.find(member.Tags, "Deprecated") then
					continue
				end
			end
			if member.Security == "None" or member.Security.Read == "None" or member.Security.Write == "None" then
				table.insert(members, member)
			end
		end
	end
	return members
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
	Classes["SiblingRemoved"] = Signal.new()
	Classes["SiblingAdded"] = Signal.new()
	Parent.ChildAdded:Connect(function(...): {Instance?}
		Classes.SiblingAdded:Fire(...)
	end)
	Parent.ChildRemoved:Connect(function(...): {Instance?}
		Classes.SiblingRemoved:Fire(...)
	end)
	function Classes:WaitForChildWhichIsA(className, timeOut)
		local defaultTimeOut = 5
		if not timeOut then
			timeOut = defaultTimeOut
		end
		while task.wait(1) do
			if timeOut <= 0 then
				warn("Infinite yield possible on " .. "'" .. i.Name .. ':WaitForChildWhichIsA("' .. className .. '")' .. "'")
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
	function Classes:GetChildrenOfClass(className : string)
		local instancesOfClass = {}
		for _,child in pairs(i:GetChildren()) do
			if child.ClassName == className then
				table.insert(instancesOfClass, child)
			end
		end
		return instancesOfClass
	end
	function Classes:GetDescendantsOfClass(className : string)
		local descendantsOfClass = {}
		for _,descendant in pairs(i:GetDescendants()) do
			if descendant.ClassName == className then
				table.insert(descendantsOfClass, descendant)
			end
		end
		return descendantsOfClass
	end
	function Classes:GetChildrenWhichAre(t : string)
		local instancesWhichAre = {}
		for _,child in pairs(i:GetChildren()) do
			if child:IsA(t) then
				table.insert(instancesWhichAre, child)
			end
		end
		return instancesWhichAre
	end
	function Classes:GetDescendantsWhichAre(t : string)
		local descendantsWhichAre = {}
		for _,descendant in pairs(i:GetDescendants()) do
			if descendant:IsA(t) then
				table.insert(descendantsWhichAre, descendant)
			end
		end
		return descendantsWhichAre
	end
	function Classes:GetDescendants()
		local descendants = {}
		for _,child in pairs(i:GetChildren()) do
			table.insert(descendants, child)
			for _,descendant in pairs(child:GetDescendants()) do
				table.insert(descendants, descendant)
			end
		end
		return descendants
	end
	function Classes:FindFirstDescendant(name : string) : Instance?
		return i:FindFirstChild(name, true)
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
	function Classes:GetSiblings()
		return (Parent and Parent:GetChildren())
	end
	function Classes:IsSiblingOf(sibling: Instance): boolean
		return (Parent == sibling.Parent)
	end
	return Classes
end

return API
