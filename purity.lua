-- UNIT TYPE CODES --
-- Priestess: E002
-- Tree of Life: etol
-- Dreadlord: Udre
-- Lich: Ulic
-- Gold Mine: ngol


do
    local _CPU_RESOURCES = 10000 ---@type number
    local _TOD_SCALE = 0.8 ---@type number
    local _TOD_START = 21.0 ---@type number


    local _units = {
        priestess = gg_unit_E002_0224,
        dreadlord = gg_unit_Udre_0080,
        lich = gg_unit_Ulic_0067,
        mine_player = gg_unit_ngol_0004,
        tree = gg_unit_etol_0003
    }

    -- Player indices are zero-based
    local _players = {
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
        SetPlayerState(_players.player, PLAYER_STATE_RESOURCE_GOLD, 300)
        SetPlayerState(_players.green, PLAYER_STATE_RESOURCE_GOLD, _CPU_RESOURCES)
        SetPlayerState(_players.orange, PLAYER_STATE_RESOURCE_GOLD, _CPU_RESOURCES)

        SetPlayerState(_players.player, PLAYER_STATE_RESOURCE_LUMBER, 100)
        SetPlayerState(_players.green, PLAYER_STATE_RESOURCE_LUMBER, _CPU_RESOURCES)
        SetPlayerState(_players.orange, PLAYER_STATE_RESOURCE_LUMBER, _CPU_RESOURCES)

        SetPlayerHandicapXP(_players.player, 0.5)

        SetPlayerAlliance(_players.green, _players.neutral_hostile, ALLIANCE_PASSIVE, TRUE)
        SetPlayerAlliance(_players.orange, _players.neutral_hostile, ALLIANCE_PASSIVE, TRUE)
        SetPlayerAlliance(_players.allies, _players.neutral_hostile, ALLIANCE_PASSIVE, TRUE)
        SetPlayerAlliance(_players.neutral_hostile, _players.green, ALLIANCE_PASSIVE, TRUE)
        SetPlayerAlliance(_players.neutral_hostile, _players.orange, ALLIANCE_PASSIVE, TRUE)
        SetPlayerAlliance(_players.neutral_hostile, _players.allies, ALLIANCE_PASSIVE, TRUE)
    end

    function InitUnitState()
        SuspendHeroXP(_units.dreadlord, true)
        SuspendHeroXP(_units.lich, true)
    end


    function Etc()
        location = GetUnitLoc(_units.tree)
        nearest_mine = MeleeFindNearestMine(location, bj_MELEE_MINE_SEARCH_RADIUS)
		IssueTargetOrder(_units.tree, "entangleinstant", _units.mine_player)
    end

    function InitMap()
        trig_UnitState = CreateTrigger()
        trig_etc = CreateTrigger()

        InitEnvironment()
        InitPlayerState()
    	InitUnitState()

        TriggerRegisterTimerEventSingle(trig_etc, 0.1)
        TriggerAddAction(trig_etc, Etc)
    end
end