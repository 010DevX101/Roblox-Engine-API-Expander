local HttpService = game:GetService("HttpService")
local RemoteFunction = script.Parent.RemoteFunction
RemoteFunction.OnServerInvoke = function(Player, Url)
	return pcall(HttpService.GetAsync, HttpService, Url)
end