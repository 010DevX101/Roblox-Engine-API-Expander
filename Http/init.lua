local Http = {}

local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local Url = "https://raw.githubusercontent.com/MaximumADHD/Roblox-Client-Tracker/roblox/API-Dump.json"
local RemoteFunction = script.RemoteFunction

function GetMembers(instance : Instance, result, members)
	local members = {}
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

function Http:GetMembers(instance : Instance)
	local success, result
	if RunService:IsServer() then
		success, result = pcall(HttpService.GetAsync, HttpService, Url)
	elseif RunService:IsClient() then
		success, result = RemoteFunction:InvokeServer(Url)
	end
	if not success then
		warn("HTTP requests are disabled.")
		return
	end
	result = HttpService:JSONDecode(result)
	return GetMembers(instance, result)
end

return Http
