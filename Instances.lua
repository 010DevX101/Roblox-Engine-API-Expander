local instance = {}

function instance:WaitForChildWhichIsA(i : Instance, className : string, timeOut : number)
	local defaultTimeOut = 5
	if not timeOut then
		timeOut = defaultTimeOut
	end
	while task.wait(1) do
		if timeOut <= 0 then
			warn("Infinite yield possible on " .. "'" .. i.Name .. ':WaitForChildWhichIsA("' .. className .. '")' .. "'")
			break
		end
		for _,inst in pairs(i:GetChildren()) do
			if inst:IsA(className) then
				return inst
			end
		end
		timeOut -= 1
	end
end

function instance:GetChildrenOfClass(i: Instance, className : string)
	local instancesOfClass = {}
	for _,child in pairs(i:GetChildren()) do
		if child.ClassName == className then
			table.insert(instancesOfClass, child)
		end
	end
	return instancesOfClass
end

function instance:GetDescendantsOfClass(i : Instance, className : string)
	local descendantsOfClass = {}
	for _,descendant in pairs(i:GetDescendants()) do
		if descendant.ClassName == className then
			table.insert(descendantsOfClass, descendant)
		end
	end
	return descendantsOfClass
end

function instance:GetChildrenWhichAre(i : Instance, t : string)
	local instancesWhichAre = {}
	for _,child in pairs(i:GetChildren()) do
		if child:IsA(t) then
			table.insert(instancesWhichAre, child)
		end
	end
	return instancesWhichAre
end

function instance:GetDescendantsWhichAre(i : Instance, t : string)
	local descendantsWhichAre = {}
	for _,descendant in pairs(i:GetDescendants()) do
		if descendant:IsA(t) then
			table.insert(descendantsWhichAre, descendant)
		end
	end
	return descendantsWhichAre
end

function instance:GetDescendants(i : Instance)
	local descendants = {}
	for _,child in pairs(i:GetChildren()) do
		table.insert(descendants, child)
		for _,descendant in pairs(instance:GetDescendants(child)) do
			table.insert(descendants, descendant)
		end
	end
	return descendants
end

function instance:FindFirstDescendant(i : Instance, name : string)
	return i:FindFirstChild(name, true)
end

return instance
