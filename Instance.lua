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
		timeOut -= 1
		for _,inst in pairs(i:GetChildren()) do
			if inst:IsA(className) then
				return inst
			end
		end
	end
end

function instance:GetChildrenOfClass(i: Instance, className : string)
	local instancesOfClass = {}
	for _,child in pairs(i:GetChildren()) do
		if child:IsA(className) then
			table.insert(instancesOfClass, child)
		end
	end
	return instancesOfClass
end

function instance:GetDescendantsOfClass(i : Instance, className : string)
	local descendantsOfClass = {}
	for _,descendant in pairs(i:GetDescendants()) do
		if descendant:IsA(className) then
			table.insert(descendantsOfClass, descendant)
		end
	end
	return descendantsOfClass
end

function instance:GetDescendants(i : Instance)
	local descendants = {}
	for _,descendant in pairs(i:GetChildren(true)) do
		table.insert(descendants, descendant)
	end
	return descendants
end

return instance
