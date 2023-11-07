local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SharedSrc = ReplicatedStorage.src
local Interface = require(SharedSrc:WaitForChild("Interface"))

--// Type definitions for IntelliSense
export type ObjectPool = {
	GetPool: (poolName: string) -> {},
	Get: (poolName: string, createFunc: () -> {}) -> {},
	Return: (poolName: string, object: {}) -> ()
}

local ObjectPool: ObjectPool = {
	Name = "ObjectPool"
}
local pools = {}
local objectsTracking = {}
local self = ObjectPool

-- -----------------:: Public Methods ::-----------------

function ObjectPool.GetPool(poolName)
	if not pools[poolName] then
		pools[poolName] = {}
	end
	return pools[poolName]
end

function ObjectPool.Get(poolName, createFunc)
	local pool = self.GetPool(poolName)
	if #pool == 0 then
		local object = createFunc()
		if not object["Name"] then
			error("Object must have a Name property")
		end
		return object
	end
	local lastObjectInPool = table.remove(pool)
	objectsTracking[lastObjectInPool.Name] = nil
	return lastObjectInPool
end

function ObjectPool.Return(poolName, object)
	if not object["Name"] then
		error("Object must have a Name property")
	end
	if objectsTracking[object.Name] then
		error("Object has already been returned to the pool")
	end

	local pool = ObjectPool.GetPool(poolName)
	table.insert(pool, object)
	objectsTracking[object.Name] = true
end

-- -----------------:: Register System and Methods to the Interface ::-----------------

Interface.RegisterSystem("ObjectPool")
Interface.RegisterMethod("ObjectPool", "GetPool", ObjectPool.GetPool)
Interface.RegisterMethod("ObjectPool", "Get", ObjectPool.Get)
Interface.RegisterMethod("ObjectPool", "Return", ObjectPool.Return)

return ObjectPool