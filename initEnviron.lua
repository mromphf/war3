do
    _CPU_RESOURCES = 10000
    _TOD_SCALE = 0.8
    _TOD_START = 21.0

    -- Player indices are zero-based
    _PL = {
        player = Player(1),
        allies = Player(2),
        orange = Player(5),
        green = Player(7),
        neutral_hostile = Player(PLAYER_NEUTRAL_AGGRESSIVE),
        neutral_passive = Player(PLAYER_NEUTRAL_PASSIVE),
    }

    local function InitEnvironment()
        SetFloatGameState(GAME_STATE_TIME_OF_DAY, _TOD_START)
        SetTimeOfDayScale(_TOD_SCALE)
    end

    local function InitPlayerState()
        SetPlayerState(_PL.player, PLAYER_STATE_RESOURCE_GOLD, 300)
        SetPlayerState(_PL.green, PLAYER_STATE_RESOURCE_GOLD, _CPU_RESOURCES)
        SetPlayerState(_PL.orange, PLAYER_STATE_RESOURCE_GOLD, _CPU_RESOURCES)

        SetPlayerState(_PL.player, PLAYER_STATE_RESOURCE_LUMBER, 100)
        SetPlayerState(_PL.green, PLAYER_STATE_RESOURCE_LUMBER, _CPU_RESOURCES)
        SetPlayerState(_PL.orange, PLAYER_STATE_RESOURCE_LUMBER, _CPU_RESOURCES)

        SetPlayerAlliance(_PL.green, _PL.neutral_hostile, ALLIANCE_PASSIVE, TRUE)
        SetPlayerAlliance(_PL.orange, _PL.neutral_hostile, ALLIANCE_PASSIVE, TRUE)
        SetPlayerAlliance(_PL.allies, _PL.neutral_hostile, ALLIANCE_PASSIVE, TRUE)
        SetPlayerAlliance(_PL.neutral_hostile, _PL.green, ALLIANCE_PASSIVE, TRUE)
        SetPlayerAlliance(_PL.neutral_hostile, _PL.orange, ALLIANCE_PASSIVE, TRUE)
        SetPlayerAlliance(_PL.neutral_hostile, _PL.allies, ALLIANCE_PASSIVE, TRUE)
    end

    local function InitUnitState()
        -- TODO: Hero names, xp rate, gold mines, etc
    end

    function InitMap()
        InitEnvironment()
        InitPlayerState()
        InitUnitState()
    end

    InitMap()
end