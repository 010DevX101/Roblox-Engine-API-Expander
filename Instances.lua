local Signal = require(script.Signal)
local Tree = require(script.Tree)
local Trove = require(script.Trove)

type APIExpanderImpl = {
	__index: APIExpanderImpl,
	new: <T>(instance: T) -> APIExpander & T,
	WaitForChildWhichIsA: (self: APIExpander, className: string, timeOut: number) -> Instance,
	GetChildrenOfClass: (self: APIExpander, className: string) -> { Instance },
	GetDescendantsOfClass: (self: APIExpander, className: string) -> { Instance },
	GetChildrenWhichAre: (self: APIExpander, className: string) -> { Instance },
	GetDescendantsWhichAre: (self: APIExpander, className: string) -> { Instance },
	FindFirstSibling: (self: APIExpander, name: string) -> Instance?,
	FindFirstSiblingOfClass: (self: APIExpander, className: string) -> Instance?,
	FindFirstSiblingWhichIsA: (self: APIExpander, className: string) -> Instance?,
	GetSiblings: (self: APIExpander) -> { Instance },
	GetSiblingsWhichAre: (self: APIExpander, className: string) -> { Instance },
	IsSiblingOf: (self: APIExpander, instance: Instance) -> boolean,
	Find: (self: APIExpander, pathToInstance: string, assertIsA: string) -> Instance?,
	Await: (self: APIExpander, pathToInstance: string, timeOut: number, assertIsA: string) -> Instance,
	Exists: (self: APIExpander, pathToInstance: string, assertIsA: string) -> boolean,
	_destroy: (self: APIExpander) -> nil,
}

type APIExpanderProperties = {
	Instance: Instance,
	_trove: typeof(Trove.new()),
	SiblingAdded: RBXScriptConnection,
	SiblingRemoved: RBXScriptConnection,
}
type APIExpander = typeof(setmetatable({} :: APIExpanderProperties, {} :: APIExpanderImpl))

local Expand: APIExpanderImpl = {} :: APIExpanderImpl
Expand.__index = function(self, key)
	if Expand[key] then
		return Expand[key]
	end

	if not self.Instance[key] then
		error(`Attempt to index {self.Instance} with key {key} that does not exist`)
	end

	if typeof(self.Instance[key]) == "function" then
		return function(self, ...)
			return (self.Instance[key] :: (any) -> ())(self.Instance, ...)
		end
	end
	return self.Instance[key]
end :: any

function Expand.new<T>(instance)
	local self = setmetatable({}, Expand)

	self.Instance = instance
	self._trove = Trove.new()
	self.SiblingAdded = self._trove:Add(Signal.new())
	self.SiblingRemoved = self._trove:Add(Signal.new())
	self.Instance.Destroying:Connect(function()
		self:Destroy()
	end)

	local parent = self.Instance.Parent
	if parent then
		self.SiblingAdded = Signal.new()
		self.SiblingRemoved = Signal.new()

		self._trove:Add(parent.ChildAdded:Connect(function(child)
			self.SiblingAdded:Fire(child)
		end))

		self._trove:Add(parent.ChildRemoved:Connect(function(child)
			self.SiblingRemoved:Fire(child)
		end))
	end

	return self
end

function Expand:WaitForChildWhichIsA(className, timeOut)
	timeOut = timeOut or 5
	while task.wait(1) do
		if timeOut <= 0 then
			warn(
				"Infinite yield possible on "
					.. "'"
					.. self.Instance.Name
					.. ':WaitForChildWhichIsA("'
					.. className
					.. '")'
					.. "'"
			)
			return nil
		end

		for _, instance in self.Instance:GetChildren() do
			if instance:IsA(className) then
				return instance
			end
		end
		timeOut -= 1
	end

	return nil
end

function Expand:GetChildrenOfClass(className)
	local children = {}
	for _, instance in self.Instance:GetChildren() do
		if instance:IsA(className) then
			table.insert(children, instance)
		end
	end
	return children
end

function Expand:GetDescendantsOfClass(className)
	local descendants = {}
	for _, descendant in self.Instance:GetDescendants() do
		if descendant:IsA(className) then
			table.insert(descendants, descendant)
		end
	end
	return descendants
end

function Expand:GetChildrenWhichAre(className)
	local children = {}
	for _, instance in self.Instance:GetChildren() do
		if instance:IsA(className) then
			table.insert(children, instance)
		end
	end
	return children
end

function Expand:GetDescendantsWhichAre(className)
	local descendants = {}
	for _, descendant in self.Instance:GetDescendants() do
		if descendant:IsA(className) then
			table.insert(descendants, descendant)
		end
	end
	return descendants
end

function Expand:GetSiblingsWhichAre(className)
	if not self.Instance.Parent then
		return nil
	end
	local siblings = {}
	for _, sibling in self.Instance.Parent:GetChildren() do
		if sibling:IsA(className) then
			table.insert(siblings, sibling)
		end
	end
	return siblings
end

function Expand:FindFirstSibling(name)
	return (self.Instance.Parent and self.Instance.Parent:FindFirstChild(name)) or nil
end

function Expand:FindFirstSiblingOfClass(className)
	return (self.Instance.Parent and self.Instance.Parent:FindFirstChildOfClass(className)) or nil
end

function Expand:FindFirstSiblingWhichIsA(className)
	return (self.Instance.Parent and self.Instance.Parent:FindFirstChildWhichIsA(className)) or nil
end

function Expand:GetSiblings()
	return (self.Instance.Parent and self.Instance.Parent:GetChildren())
end

function Expand:IsSiblingOf(sibling)
	return (self.Instance.Parent == sibling.Parent)
end

function Expand:Find(pathToInstance, assertIsA)
	return Tree.Find(self.Instance, pathToInstance, assertIsA)
end

function Expand:Await(pathToInstance, timeOut, assertIsA)
	return Tree.Await(self.Instance, pathToInstance, timeOut, assertIsA)
end

function Expand:Exists(pathToInstance, assertIsA)
	return Tree.Exists(self.Instance, pathToInstance, assertIsA)
end

function Expand:_destroy()
	self._trove:Destroy()
	setmetatable(self, nil)
	table.clear(self)
	self = nil
end

return {
	Register = Expand.new
}
