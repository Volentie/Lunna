local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SharedSrc = ReplicatedStorage.src
local Foundation = SharedSrc:WaitForChild("Foundation")

--// Foundation
local Interface = require(SharedSrc:WaitForChild("Interface"))
local Systems: Folder = SharedSrc:WaitForChild("Systems")

function Boot()
    print("Boot started")

    --// Init Foundation Systems
    local function RequireFoundationSystems()
        for _, foundationSystem in Foundation:GetChildren() do
            require(foundationSystem)
        end
    end

    --// Init Game Systems
    local function RequireGameSystems()
        for _, gameSystem in Systems:GetChildren() do
            require(gameSystem)
        end
    end

    --// Register Game Systems to the SystemManager
    local function RegisterGameSystems()
        for _, gameSystem in Systems:GetChildren() do
            Interface.Invoke("SystemManager", "Register", require(gameSystem))
        end
    end

    --// Initialize Game Systems
    local function InitializeGameSystems()
        Interface.Invoke("SystemManager", "Initialize")
    end

    local function BuildGame()
        RequireFoundationSystems()
        --RequireGameSystems()
        -- SystemManager
        RegisterGameSystems()
        InitializeGameSystems()
    end

    BuildGame()

    print("Finished booting")
end

Boot()