do
    local _CPU_RESOURCES = 10000 ---@type number
    local _TOD_SCALE = 0.8 ---@type number
    local _TOD_START = 21.0 ---@type number

    local function InitEnvironment()
        SetFloatGameState(GAME_STATE_TIME_OF_DAY, _TOD_START)
        SetTerrainFogExBJ(0, 800, 6000, 0.0, 20.0, 40.0, 55.0)
        SetTimeOfDayScale(_TOD_SCALE)
    end

    local function InitPlayerState()
        SetPlayerState(players.player, PLAYER_STATE_RESOURCE_GOLD, 300)
        SetPlayerState(players.green, PLAYER_STATE_RESOURCE_GOLD, _CPU_RESOURCES)
        SetPlayerState(players.orange, PLAYER_STATE_RESOURCE_GOLD, _CPU_RESOURCES)

        SetPlayerState(players.player, PLAYER_STATE_RESOURCE_LUMBER, 100)
        SetPlayerState(players.green, PLAYER_STATE_RESOURCE_LUMBER, _CPU_RESOURCES)
        SetPlayerState(players.orange, PLAYER_STATE_RESOURCE_LUMBER, _CPU_RESOURCES)

        SetPlayerHandicapXP(players.player, 0.5)

        SetPlayerAlliance(players.green, players.neutral_hostile, ALLIANCE_PASSIVE, TRUE)
        SetPlayerAlliance(players.orange, players.neutral_hostile, ALLIANCE_PASSIVE, TRUE)
        SetPlayerAlliance(players.allies, players.neutral_hostile, ALLIANCE_PASSIVE, TRUE)
        SetPlayerAlliance(players.neutral_hostile, players.green, ALLIANCE_PASSIVE, TRUE)
        SetPlayerAlliance(players.neutral_hostile, players.orange, ALLIANCE_PASSIVE, TRUE)
        SetPlayerAlliance(players.neutral_hostile, players.allies, ALLIANCE_PASSIVE, TRUE)
    end

    local function InitUnitState()
        SuspendHeroXP(units.dreadlord, true)
        SuspendHeroXP(units.lich, true)
    end

    OnInit.map(function()
        InitPlayerState()
        InitEnvironment()
        InitUnitState()
    end)
end