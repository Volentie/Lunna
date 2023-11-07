local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SharedSrc = ReplicatedStorage.src
local Interface = require(SharedSrc:WaitForChild("Interface"))

--// Type definitions for IntelliSense
export type SystemManager = {
	Register: (system: {}) -> (),
	Initialize: () -> (),
	Update: ( deltaTime: number? ) -> (),
	Destroy: () -> ()
}

--// Private variables
local SystemManager: SystemManager = {
	Name = "SystemManager"
}
local systems = {}

-- -----------------:: Public Methods ::-----------------

-- Register a system to be either initialized, updated or destroyed
function SystemManager.Register(system, systemName)
	if systemName then
		system.Name = systemName
	end
	assert(system.Name, "System must have a Name property")
	table.insert(systems, system)
end

-- Initialize all systems
function SystemManager.Initialize()
	for _, system in pairs(systems) do
		Interface.Invoke(system.Name, "Initialize")
	end
end

-- Update all systems
function SystemManager.Update(deltaTime)
	for _, system in pairs(systems) do
		Interface.Invoke(system.Name, "Update")
	end
end

-- Destroy all systems
function SystemManager.Destroy()
	for _, system in pairs(systems) do
		Interface.Invoke(system.Name, "Destroy")
	end
end

-- -----------------:: Register System and Methods to the Interface ::-----------------

Interface.RegisterSystem("SystemManager")
Interface.RegisterMethod("SystemManager", "Register", SystemManager.Register)
Interface.RegisterMethod("SystemManager", "Initialize", SystemManager.Initialize)
Interface.RegisterMethod("SystemManager", "Update", SystemManager.Update)
Interface.RegisterMethod("SystemManager", "Destroy", SystemManager.Destroy)

return SystemManager