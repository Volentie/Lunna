local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SharedSrc = ReplicatedStorage.src
local Interface = require(SharedSrc:WaitForChild("Interface"))
local Foundation = SharedSrc:WaitForChild("Foundation")

local RoomGenerator = {
    Name = "RoomGenerator"
}

function RoomGenerator.Foo()
    print("hello")
end

Interface.RegisterSystem(RoomGenerator.Name)
Interface.RegisterMethod(RoomGenerator.Name, "Foo", RoomGenerator.Foo)

return RoomGenerator