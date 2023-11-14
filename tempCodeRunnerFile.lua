a = (
    function()
        return 1, 2
    end
)

local b = select(2, a())
print(b)