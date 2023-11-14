--// Imports
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SharedSrc = ReplicatedStorage.src
local Interface = require(SharedSrc:WaitForChild("Interface"))

local ModuleGenerator = {
    _Name = "ModuleGenerator"
}

-- -----------------:: Private ::-----------------

--[[local Terrain = workspace.Terrain

-- Define the size of the heightmap
local width = 100
local height = 500

-- Define the scale and other noise parameters
local scale = 100.0
local octaves = 6
local persistence = 0.5
local lacunarity = 2.0
local seed = 100

-- Define the water level and seabed height scale
local waterLevel = 50
local perlinScalar = 350  -- Adjust this to scale the height of the seabed

-- Noise generation function
local function perlinNoise(x, y)
    local total = 0
    local frequency = 1
    local amplitude = 1
    local maxValue = 0  -- Used for normalizing result to 0 - 1

    for i = 1, octaves do
        total = total + math.noise(x * frequency / scale, y * frequency / scale, seed) * amplitude
        
        maxValue = maxValue + amplitude
        amplitude = amplitude * persistence
        frequency = frequency * lacunarity
    end

    -- Normalize the result
    return total / maxValue
end

-- Generate the heightmap
local heightmap = {}
for i = 1, width do
    heightmap[i] = {}
    for j = 1, height do
        heightmap[i][j] = perlinNoise(i, j)
    end
end

-- Function to create the seabed
local function createSeabed(heightmap)
    local regionSize = Vector3.new(4, 1, 4)  -- Size of each terrain cell
    local lastHeight

    for i, row in ipairs(heightmap) do
        for j, heightValue in ipairs(row) do
            -- Convert heightValue to a valid range for your terrain heights
            local height = heightValue * perlinScalar * 0.5

            if not lastHeight then
                lastHeight = height
            end

            local deltaHeight = math.abs(height - lastHeight)

            -- Calculate the position for each terrain cell
            local position = Vector3.new(i * regionSize.X, height, j * regionSize.Z)
            local actualSize = Vector3.new(regionSize.X, deltaHeight, regionSize.Z)
            local regionMin = (position - actualSize)
            local regionMax = (position + actualSize)

            -- Create a terrain cell at the position
            local region = Region3.new(regionMin, regionMax)

            Terrain:FillRegion(region, 1, Enum.Material.Rock)

            lastHeight = height
        end
    end
end

-- Function to fill the world with water
local function fillWithWater(waterLevel, width, height)
    local waterStartPosition = Vector3.new(0, waterLevel, 0)
    local waterEndPosition = Vector3.new(width * 4, waterLevel + 4, height * 4)
    local waterRegion = Region3.new(waterStartPosition, waterEndPosition)
    Terrain:FillRegion(waterRegion, 4, Enum.Material.Water)
end

-- Generate the seabed and fill with water
--createSeabed(heightmap)
--fillWithWater(waterLevel, width, height)]]


function ModuleGenerator:SmoothingKernel(radius, distanceFromCenter)
    return math.max(0, radius - distanceFromCenter)
end


-- -----------------:: Public ::-----------------

return ModuleGenerator