local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SharedSrc = ReplicatedStorage.src
local Foundation = SharedSrc:WaitForChild("Foundation")

--// Foundation
local Interface = require(SharedSrc:WaitForChild("Interface"))
local Systems: Folder = SharedSrc:WaitForChild("Systems")

--! Type definitions
export type Lunna = {
    RequireFoundations: () -> (),
    RequireSystems: () -> (),
    RegisterSystems: () -> (),
    InitializeSystems: () -> (),
    Prepare: () -> (),
    Boot: () -> ()
}

local Lunna: Lunna = {}

--       :: PREPARE METHODS ::--
--// Init Foundational Systems
function Lunna:RequireFoundations()
    for _, foundationalSystem in Foundation:GetChildren() do
        require(foundationalSystem)
    end
end

--// Init Systems
function Lunna:RequireSystems()
    for _, system in Systems:GetChildren() do
        require(system)
    end
end

--// Register Systems to the SystemManager
function Lunna:RegisterSystems()
    for _, system in Systems:GetChildren() do
        Interface.Invoke("SystemManager", "Register", require(system))
    end
end

--// Initialize Systems
function Lunna:InitializeSystems()
    Interface.Invoke("SystemManager", "Initialize")
end

function Lunna:Prepare()
    self:RequireFoundations()
    self:RequireSystems()
    self:RegisterSystems()
end

function Lunna:Boot()
    print("Boot started")

    -- Prepare Lunna
    self:Prepare()

    -- Initialize Systems
    self:InitializeSystems()

    print("Finished booting")
end

return Lunna