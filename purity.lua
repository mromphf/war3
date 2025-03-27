-- UNIT TYPE CODES --
-- Priestess: E002
-- Tree of Life: etol
-- Dreadlord: Udre
-- Lich: Ulic
-- Gold Mine: ngol


do
    _CPU_RESOURCES = 10000 ---@type number
    _TOD_SCALE = 0.8 ---@type number
    _TOD_START = 21.0 ---@type number
    _ALL_PLAYERS = bj_FORCE_ALL_PLAYERS ---@type force

    _QST = {}

    _UN = {
        priestess = gg_unit_E002_0224,
        dreadlord = gg_unit_Udre_0080,
        lich = gg_unit_Ulic_0067,
        mine_player = gg_unit_ngol_0004,
        tree = gg_unit_etol_0003
    }

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

        SetPlayerHandicapXP(_PL.player, 0.5)

        SetPlayerAlliance(_PL.green, _PL.neutral_hostile, ALLIANCE_PASSIVE, TRUE)
        SetPlayerAlliance(_PL.orange, _PL.neutral_hostile, ALLIANCE_PASSIVE, TRUE)
        SetPlayerAlliance(_PL.allies, _PL.neutral_hostile, ALLIANCE_PASSIVE, TRUE)
        SetPlayerAlliance(_PL.neutral_hostile, _PL.green, ALLIANCE_PASSIVE, TRUE)
        SetPlayerAlliance(_PL.neutral_hostile, _PL.orange, ALLIANCE_PASSIVE, TRUE)
        SetPlayerAlliance(_PL.neutral_hostile, _PL.allies, ALLIANCE_PASSIVE, TRUE)
    end

    function InitUnitState()
        SuspendHeroXP(_UN.dreadlord, true)
        SuspendHeroXP(_UN.lich, true)
    end

    function InitQuests()
        mainQuest = CreateQuest()
        item = QuestCreateItem(mainQuest)

        QuestSetDiscovered(mainQuest, false)
        QuestSetTitle(mainQuest, "Purity")
        QuestSetDescription(mainQuest, "The Scourge has brought its blight to Ashenvale under the leadership of the dreadlord Terrordar. Priestess Mira Whitemane leads the night elves on an offensive to drive away the demon's undead army.")
        QuestSetIconPath(mainQuest, "ReplaceableTextures\\CommandButtons\\BTNHeroDreadLord.blp")

        QuestItemSetDescription(item, "Destroy Terrordar's green Undead base")

        _QST.main = mainQuest
    end


    function AssignMainQuest()
        if _QST.main then
            QuestMessageBJ(_ALL_PLAYERS, bj_QUESTMESSAGE_DISCOVERED, "|cffffcc00MAIN QUEST|r\nPurity - Destroy Terrordar's green Undead base")
            QuestSetDiscovered(_QST.main, true)
        end
    end

    function Etc()
        location = GetUnitLoc(_UN.tree)
        nearest_mine = MeleeFindNearestMine(location, bj_MELEE_MINE_SEARCH_RADIUS)
		IssueTargetOrder(_UN.tree, "entangleinstant", _UN.mine_player)
    end

    function InitMap()
        trig_UnitState = CreateTrigger()
        trig_etc = CreateTrigger()
        trig_quest = CreateTrigger()

        InitEnvironment()
        InitPlayerState()
    	InitUnitState()
        InitQuests()
        -- Etc()

        TriggerRegisterTimerEventSingle(trig_quest, bj_QUEUE_DELAY_QUEST)
        TriggerAddAction(trig_quest, AssignMainQuest)

        --TriggerRegisterGameEvent(trig_etc, EVENT_GAME_LOADED)
        TriggerRegisterTimerEventSingle(trig_etc, 0.1)
        TriggerAddAction(trig_etc, Etc)
    end
end