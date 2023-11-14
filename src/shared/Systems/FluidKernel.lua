--// Imports
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SharedSrc = ReplicatedStorage.src
local Interface = require(SharedSrc:WaitForChild("Interface"))

local FluidKernel = {
    _Name = "FluidKernel"
}

function FluidKernel.Initialize()
    print("opa")
end

-- -----------------:: Public ::-----------------

return FluidKernel