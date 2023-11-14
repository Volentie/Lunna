--// Type definitions
export type DebugManager = {
    Name: string,
    FLAGS: {
        INFO_NONE: number,
        INFO_BASIC: number,
        INFO_WARN: number,
        MODE_NONE: number,
        MODE_STRICT: number,
    },
    State: number,
    SetDebugState: (self: table, info: number, mode: number) -> (),
    HasFlag: (self: table, flag: number) -> boolean,
    IsActive: (self: table) -> boolean,
}

local DebugManager: DebugManager = {
    _Name = "DebugManager"
}

-- -----------------:: Public Methods ::-----------------

DebugManager.FLAGS = {
    INFO_NONE = 0x0,
    INFO_BASIC = 0x1,
    INFO_WARN = 0x2,
    MODE_NONE = 0x4,
    MODE_STRICT = 0x8,
}

DebugManager.State = bit32.band(DebugManager.FLAGS.INFO_NONE, DebugManager.FLAGS.MODE_NONE)

function DebugManager:SetDebugState(info, mode)
    info = self.FLAGS[info]
    mode = self.FLAGS[mode]
    
    assert(info, "Invalid info flag")
    assert(mode, "Invalid mode flag")
    assert(info ~= mode, "Cannot set the same flag for both info and mode")

    DebugManager.State = bit32.band(info, mode)
end

function DebugManager:HasFlag(flag)
    flag = self.FLAGS[flag]
    assert(flag, "Invalid flag")
    return bit32.bor(self.State, flag) ~= 0
end

function DebugManager:IsActive()
    return self.State ~= bit32.band(self.FLAGS.INFO_NONE, self.FLAGS.MODE_NONE)
end

return DebugManager