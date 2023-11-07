local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SharedSrc = ReplicatedStorage.src
local Interface = require(SharedSrc:WaitForChild("Interface"))

--// Type definitions for IntelliSense
export type AuthorizationManager = {
	GrantPermission: (system: string, event: string) -> (),
	RevokePermission: (system: string, event:string) -> (),
	HasPermission: (system: string, event: string) -> boolean
}

--// Private variables
local AuthorizationManager: AuthorizationManager = {
	Name = "AuthorizationManager"
}
local permissions = {}

-- -----------------:: Public Methods ::-----------------

function AuthorizationManager.GrantPermission(system, event)
	permissions[system] = permissions[system] or {}
	permissions[system][event] = true
end

function AuthorizationManager.RevokePermission(system, event)
	permissions[system] = permissions[system] or {}
	permissions[system][event] = false
end

function AuthorizationManager.HasPermission(system, event)
	return permissions[system] and permissions[system][event] or false
end

-- -----------------:: Register System and Methods to the Interface ::-----------------

Interface.RegisterSystem("AuthorizationManager")
Interface.RegisterMethod("AuthorizationManager", "GrantPermission", AuthorizationManager.GrantPermission)
Interface.RegisterMethod("AuthorizationManager", "RevokePermission", AuthorizationManager.RevokePermission)
Interface.RegisterMethod("AuthorizationManager", "HasPermission", AuthorizationManager.HasPermission)

return AuthorizationManager