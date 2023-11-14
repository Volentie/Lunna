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
	_Name = "SystemManager"
}
local systems = {}

-- -----------------:: Public Methods ::-----------------

-- Register a system to be either initialized, updated or destroyed
function SystemManager.Register(system, systemName)
	local errMsg1 = "System's type must be 'table', got: '"..typeof(system).."'"
	local errMsg2 = "\n(!) System is probably not registered to the Interface."
	assert(typeof(system) == "table", errMsg1..errMsg2)
	if systemName then
		system._Name = systemName
	end
	if not system._Name then print(system) end
	assert(system._Name, "System must have a Name property")
	table.insert(systems, system)

	-- Register system to the Interface
	Interface.RegisterSystem(system._Name)
	Interface.RegisterMethod(system._Name, "Initialize", system.Initialize)

	if system["Update"] then
		Interface.RegisterMethod(system._Name, "Update", system.Update)
	end
	
	if system["Destroy"] then
		Interface.RegisterMethod(system._Name, "Destroy", system.Destroy)
	end
end

-- Initialize all systems
function SystemManager.Initialize()
	for _, system in pairs(systems) do
		Interface.Invoke(system._Name, "Initialize")
	end
end

-- Update all systems
function SystemManager.Update(deltaTime)
	for _, system in pairs(systems) do
		Interface.Invoke(system._Name, "Update")
	end
end

-- Destroy all systems
function SystemManager.Destroy()
	for _, system in pairs(systems) do
		Interface.Invoke(system._Name, "Destroy")
	end
end

-- -----------------:: Register System and Methods to the Interface ::-----------------

Interface.RegisterSystem("SystemManager")
Interface.RegisterMethod("SystemManager", "Register", SystemManager.Register)
Interface.RegisterMethod("SystemManager", "Initialize", SystemManager.Initialize)
Interface.RegisterMethod("SystemManager", "Update", SystemManager.Update)
Interface.RegisterMethod("SystemManager", "Destroy", SystemManager.Destroy)

return SystemManager