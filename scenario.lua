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
        InitResources(players.player, 300, 100)
        InitResources(players.green, _CPU_RESOURCES, _CPU_RESOURCES)
        InitResources(players.orange, _CPU_RESOURCES, _CPU_RESOURCES)

        AllyWithNeutral(players.allies, players.green, players.orange)
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

        elseif diff == MAP_DIFFICULTY_NORMAL then

            SetHeroLevel(units.lich, 5, false)
            SetHeroLevel(units.dreadlord, 7, false)
            SetPlayerHandicapXP(players.player, 0.5)

            LearnSkills(units.lich,
                spells.ud.dark_ritual, spells.ud.frost_nova, spells.ud.frost_armor)

            LearnSkills(units.dreadlord,
                spells.ud.aura_vamp, spells.ud.inferno)

            GiveItems(units.lich,
                items.mantle)

            GiveItems(units.dreadlord,
                items.pring1, items.claws3)


        elseif diff == MAP_DIFFICULTY_HARD or
                diff == MAP_DIFFICULTY_INSANE then

            SetResourceAmount(units.mines.player, 10000)
            SetPlayerHandicapXP(players.player, 0.5)
            SetHeroLevel(units.lich, 10, false)
            SetHeroLevel(units.dreadlord, 10, false)

            LearnSkills(units.lich,
                spells.ud.dark_ritual, spells.ud.dark_ritual, spells.ud.dark_ritual,
                spells.ud.frost_nova, spells.ud.frost_nova, spells.ud.frost_armor,
                spells.ud.frost_armor, spells.ud.death_decay
            )

            LearnSkills(units.dreadlord,
                spells.ud.aura_vamp, spells.ud.sleep,
                spells.ud.carrion_swarm, spells.ud.carrion_swarm,
                spells.ud.inferno
            )

            GiveItems(units.lich,
                items.pring1, items.mantle)

            GiveItems(units.dreadlord,
                items.pring3, items.claws9, items.penrg)
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