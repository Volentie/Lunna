local Particle = {}
Particle.__index = Particle

function Particle.new(position)
    local self = setmetatable({}, Particle)
    self.position = position
    self.velocity = Vector3.new()
    self.interactionRadius = 5 -- Example radius within which particles will interact
    return self
end

return Particle