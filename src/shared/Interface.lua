--// Dependencies
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SharedSrc = ReplicatedStorage.src
local DebugManager = require(SharedSrc:WaitForChild("DebugManager"))

--// Type definitions
export type Interface = {
	-- Change the debug mode
	ChangeDebugMode: (state: string) -> (),
	-- Listen to a path and set its callback
	Listen: (path: string, callback: () -> ()) -> (),
	-- Close a path
	Close: (path: string) -> (),
	-- Post data to a path
	Post: (path: string, ...any) -> (),
	-- Register a system so it can interact with other systems using the interface as the MITM
	RegisterSystem: (systemName: string) -> (),
	-- Add a method to a system
	RegisterMethod: (systemName: string, methodName: string, callback: () -> ()) -> (),
	-- Try to invoke a system's method
	Invoke: (systemName: string, methodName: string, ...any) -> ()
}

local Interface: Interface = {
	Name = "Interface"
}

--// Private
local data = {
	paths = {},
	systems = {}
}

-- -----------------:: Public ::-----------------

--// Calls
DebugManager:SetDebugState("INFO_WARN", "MODE_NONE")

function Interface.Listen(path, callback)
	assert(path, "You must provide a path to listen to")
	assert(type(path) == "string", "Path must be a string")
	assert(type(callback) == "function", "Callback must be a function")
	assert(callback, "You must provide a callback function for the path: " .. path)
	path = string.gsub(path, "%.", "/")

	if DebugManager:IsActive() then
		if DebugManager:HasFlag("MODE_STRICT") then
			assert(not data["paths"][path], "Path already exists: " .. path)
		elseif DebugManager:HasFlag("INFO_WARN") then
			warn("Path already exists, the callback is being overwritten: " .. path)
		end
	end

	data["paths"][path] = {
		Callback = callback
	}
end

function Interface.Close(path)
	assert(path, "You must provide a path to close")
	local weak = false
	if DebugManager:IsActive() then
		if DebugManager:HasFlag("MODE_STRICT") then
			assert(data["paths"][path], "Path not found: " .. path)
		elseif DebugManager:HasFlag("INFO_WARN") then
			if not data["paths"][path] then
				warn("Path not found: " .. path)
				weak = not weak
			end
		end
	end

	if not weak then
		data["paths"][path] = nil
	end
end

function Interface.Post(path, ...)
	assert(path, "You must provide a path to post to")
	assert(..., "You must provide data to post to the path: " .. path)
	local weak = false
	if DebugManager:IsActive() then
		if DebugManager:HasFlag("MODE_STRICT") then
			assert(data["paths"][path], "Path not found: " .. path)
		elseif DebugManager:HasFlag("INFO_WARN") then
			if not data["paths"][path] then
				warn("Path not found: " .. path)
				weak = not weak
			end
		end
	end

	if not weak then
		data["paths"][path].Callback(...)
	end
end

function Interface.RegisterSystem(systemName)
	assert(systemName, "You must provide a name for the system")
	if DebugManager:IsActive() then
		if DebugManager:HasFlag("MODE_STRICT") then
			assert(not data["systems"][systemName], "System already exists: " .. systemName)
		elseif DebugManager:HasFlag("INFO_WARN") then
			if data["systems"][systemName] then
				warn("System already exists and it's being cleared: " .. systemName)
			end
		end
	end
	data["systems"][systemName] = {}
end

function Interface.RegisterMethod(systemName, methodName, callback)
	assert(type(callback) == "function", "Callback must be a function")
	assert(callback, "You must provide a callback function for the method: " .. methodName)
	if DebugManager:IsActive() then
		if DebugManager:HasFlag("MODE_STRICT") then
			assert(data["systems"][systemName], "Trying to register a method to a system that was not found: " .. systemName)
			assert(data["systems"][systemName][methodName], "Trying to register a method that already exists: " .. methodName)
		elseif DebugManager:HasFlag("INFO_WARN") then
			if data["systems"][systemName][methodName] then
				warn("Overwriting method: " .. methodName)
			end
		end
	end
	data["systems"][systemName][methodName] = callback
end

function Interface.Invoke(systemName, methodName, ...)
	local shouldReturn = data["systems"][systemName] == nil or data["systems"][systemName][methodName] == nil
	if DebugManager:IsActive() then
		if DebugManager:HasFlag("MODE_STRICT") then
			assert(data["systems"][systemName], "Trying to invoke a system that was not found: " .. systemName)
			assert(data["systems"][systemName][methodName], "Trying to invoke a method that was not found: " .. methodName)
		elseif DebugManager:HasFlag("INFO_WARN") then
			if shouldReturn then
				warn("Invoking a system or method of a system that does not exist:\nsystemName: " .. systemName .. " methodName: " .. methodName)
			end
		end
	end
	if shouldReturn then
		return
	end
	data["systems"][systemName][methodName](...)
end

return Interface