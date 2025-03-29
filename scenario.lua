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

        SetPlayerAlliance(players.green, players.neutral_hostile, ALLIANCE_PASSIVE, TRUE)
        SetPlayerAlliance(players.orange, players.neutral_hostile, ALLIANCE_PASSIVE, TRUE)
        SetPlayerAlliance(players.allies, players.neutral_hostile, ALLIANCE_PASSIVE, TRUE)
        SetPlayerAlliance(players.neutral_hostile, players.green, ALLIANCE_PASSIVE, TRUE)
        SetPlayerAlliance(players.neutral_hostile, players.orange, ALLIANCE_PASSIVE, TRUE)
        SetPlayerAlliance(players.neutral_hostile, players.allies, ALLIANCE_PASSIVE, TRUE)
    end

    local function InitWorkers()
        local trig_worker_dispatch = CreateTrigger()
        IssueTargetOrderBJ(units.tree, cmd_str.entangleinstant, units.mines.player)

        TriggerRegisterTimerEventSingle(trig_worker_dispatch, 0.5)
        TriggerAddAction(trig_worker_dispatch, function()
            DispatchUnits(units.workers.gold, cmd_str.autoharvestgold)
            DispatchUnits(units.workers.lumber, cmd_str.autoharvestlumber)
        end)
    end

    local function InitDifficulty()
        diff = GetGameDifficulty()

        if diff == MAP_DIFFICULTY_EASY then
            SetPlayerHandicap(players.green, 0.8)
            SetPlayerHandicap(players.orange, 0.8)
            SetPlayerHandicapXP(players.player, 0.85)
        end

        if diff == MAP_DIFFICULTY_NORMAL then
            SetHeroLevel(units.lich, 5, false)
            IncUnitAbilityLevel(units.lich, FourCC("AUdr"))
            IncUnitAbilityLevel(units.lich, FourCC("AUfn"))
            IncUnitAbilityLevel(units.lich, FourCC("AUfu"))
            UnitAddItemById(units.lich, FourCC("rin1"))

            SetHeroLevel(units.dreadlord, 7, false)
            IncUnitAbilityLevel(units.dreadlord, FourCC("AUav"))
            IncUnitAbilityLevel(units.dreadlord, FourCC("AUin"))
            UnitAddItemById(units.dreadlord, FourCC("rde0"))
            UnitAddItemById(units.dreadlord, FourCC("rat3"))

            SetPlayerHandicapXP(players.player, 0.5)
        end

        if diff == MAP_DIFFICULTY_HARD or diff == MAP_DIFFICULTY_INSANE then
            SetHeroLevel(units.lich, 10, false)
            IncUnitAbilityLevel(units.lich, FourCC("AUdr"))
            IncUnitAbilityLevel(units.lich, FourCC("AUdr"))
            IncUnitAbilityLevel(units.lich, FourCC("AUdr"))
            IncUnitAbilityLevel(units.lich, FourCC("AUfn"))
            IncUnitAbilityLevel(units.lich, FourCC("AUfn"))
            IncUnitAbilityLevel(units.lich, FourCC("AUfu"))
            IncUnitAbilityLevel(units.lich, FourCC("AUfu"))
            IncUnitAbilityLevel(units.lich, FourCC("AUdd"))
            UnitAddItemById(units.lich, FourCC("rde1"))
            UnitAddItemById(units.lich, FourCC("rin1"))

            SetHeroLevel(units.dreadlord, 10, false)
            IncUnitAbilityLevel(units.dreadlord, FourCC("AUav"))
            IncUnitAbilityLevel(units.dreadlord, FourCC("AUsl"))
            IncUnitAbilityLevel(units.dreadlord, FourCC("AUcs"))
            IncUnitAbilityLevel(units.dreadlord, FourCC("AUcs"))
            IncUnitAbilityLevel(units.dreadlord, FourCC("AUin"))
            UnitAddItemById(units.dreadlord, FourCC("rde2"))
            UnitAddItemById(units.dreadlord, FourCC("rat9"))
            UnitAddItemById(units.dreadlord, FourCC("penr"))

            SetResourceAmount(units.gold.player, 10000)
            SetPlayerHandicapXP(players.player, 0.5)
        end

        SuspendHeroXP(units.dreadlord, true)
        SuspendHeroXP(units.lich, true)
    end

    OnInit.map(function()
        InitPlayerState()
        InitEnvironment()
    end)

    OnInit.final(function()
        InitWorkers()
        InitDifficulty()
    end)
end