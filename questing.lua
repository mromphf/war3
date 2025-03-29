do
    ---@type leaderboard
    leaderboard = nil

    ---@type integer
    local MAX_PLAYERS = 15

    ---@type force
    local human_players_force

    ---@type boolean
    local is_acquired_mountain_giant

    ---@type boolean
    local is_acquired_chimera

    ---@type boolean
    local is_orange_unassigned


    -- ------------------------------------------
    -- Scenario-agnostic
    -- ------------------------------------------

    ---@param p player
    ---@return boolean
    function IsHumanPlaying(p)
        return GetPlayerSlotState(p) == PLAYER_SLOT_STATE_PLAYING and
               GetPlayerController(p) == MAP_CONTROL_USER
    end

    ---@return force
    function AllHumanPlayers()
        local f = CreateForce()

        for n = 0, MAX_PLAYERS - 1 do
            local p = Player(n)
            if IsHumanPlaying(p) then
                ForceAddPlayer(f, p)
            end
        end

        return f
    end

    ---@param q QuestDefinition
    ---@param msg string
    function CompleteQuest(q, msg)
        if q.data then
            QuestSetCompleted(q.data, true)
            QuestMessageBJ(human_players_force, bj_QUESTMESSAGE_COMPLETED, msg)
        end
    end

    ---@param quest QuestDefinition
    function AssignQuest(quest)
        print(quest)
        if quest.data then
            QuestMessageBJ(human_players_force or AllHumanPlayers(), bj_QUESTMESSAGE_DISCOVERED, quest.message)
            QuestSetDiscovered(quest.data, true)
        end
    end

    ---@param definition QuestDefinition
    ---@return quest | nil
    function InitQuest(definition)
        if not definition then
            print("ERR: Tried to init quest with no definition")
            return nil
        end

        local q = CreateQuest()

        QuestSetRequired(q, definition.required)
        QuestSetDiscovered(q, definition.discovered)
        QuestSetTitle(q, definition.title)
        QuestSetDescription(q, definition.description)
        QuestSetIconPath(q, definition.iconPath)

        for _, description in ipairs(definition.items) do
            QuestItemSetDescription(QuestCreateItem(q), description)
        end

        return q
    end

    ---@param f force
    ---@return leaderboard
    local function InitLeaderboard(f)
        lb = CreateLeaderboardBJ(f, "")

        LeaderboardDisplay(lb, false)
        LeaderboardAddItemBJ(players.player, lb, "Allies to Rescue",
            CountUnitsInGroup(GetUnitsOfPlayerAll(players.allies)))
        LeaderboardSetPlayerItemLabelColorBJ(players.player, lb, 0, 70, 70, 0)
        LeaderboardSetPlayerItemValueColorBJ(players.player, lb, 100, 100, 100, 0)

        return lb
    end

    -- ------------------------------------------
    -- Scenario-specific
    -- ------------------------------------------

    local function AssignRescueQuest()
        if IsQuestDiscovered(quests.rescue.data) then return end
        leaderboard = InitLeaderboard(human_players_force)

        TriggerSleepAction(1.5)
        LeaderboardDisplay( leaderboard, true)
        AssignQuest(quests.rescue)
        TriggerSleepAction(bj_QUEUE_DELAY_HINT)
        QuestMessageBJ(human_players_force, bj_QUESTMESSAGE_HINT, hints.general.allies)
    end

    local function AssignOrangeQuest()
        is_orange_unassigned = false

        TriggerSleepAction(2)
        AssignQuest(quests.orange)
    end

    local function OnMountainGiantRescue()
        is_acquired_mountain_giant = true

        SetPlayerUnitAvailableBJ(FourCC("emtg"), true, players.player)
        -- TODO: Not enabling ability available
        SetPlayerAbilityAvailableBJ(true, FourCC("Rers"), players.player)
        SetPlayerAbilityAvailableBJ(true, FourCC("Rehs"), players.player)
        TriggerSleepAction(2)
        QuestMessageBJ(human_players_force, bj_QUESTMESSAGE_UNITAVAILABLE, hints.new_unit.giant)
    end

    local function OnChimeraRescue()
        is_acquired_chimera = true

        SetPlayerUnitAvailableBJ(FourCC("edos"), true, players.player)
        TriggerSleepAction(2)
        QuestMessageBJ(human_players_force, bj_QUESTMESSAGE_UNITAVAILABLE, hints.new_unit.chimera)
    end

    local function OnRescueAlly()
        if IsQuestDiscovered(quests.rescue.data) then
            SetUnitUseFood(GetTriggerUnit(), false)
            LeaderboardSetItemValue(leaderboard,
                LeaderboardGetPlayerIndex(leaderboard, players.player),
                CountUnitsInGroup(GetUnitsOfPlayerAll(players.allies)))
        end
    end

    ---@param u unit
    local function IsNewUnitAcquired(u, typeId, b)
        return not b and
            GetUnitTypeId(u) == FourCC(typeId) and
            CountLivingPlayerUnitsOfTypeId(FourCC(typeId), players.player) <= 1
    end

    local function RegisterQuestTrigs()
        local trig_assignMain = CreateTrigger()
        local trig_assignRescue = CreateTrigger()
        local trig_assignOrange = CreateTrigger()
        local trig_onRescue = CreateTrigger()
        local trig_onRescueGiant = CreateTrigger()
        local trig_onRescueChimera = CreateTrigger()

        TriggerRegisterTimerEventSingle(trig_assignMain, bj_QUEUE_DELAY_QUEST)
        TriggerAddAction(trig_assignMain, function()
            DisableTrigger(trig_assignMain)
            AssignQuest(quests.main)
        end)

        TriggerRegisterPlayerUnitEvent(trig_assignRescue, players.allies, EVENT_PLAYER_UNIT_RESCUED)
        TriggerAddAction(trig_assignRescue, function()
            DisableTrigger(trig_assignRescue)
            AssignRescueQuest()
        end)

        TriggerRegisterPlayerUnitEvent(trig_assignOrange, players.orange, EVENT_PLAYER_UNIT_DEATH)
        TriggerAddCondition(trig_assignOrange, Condition(is_orange_unassigned))
        TriggerAddAction(trig_assignOrange, AssignOrangeQuest)
        TriggerAddAction(trig_assignOrange, function() DisableTrigger(trig_assignOrange) end)

        TriggerRegisterPlayerUnitEvent(trig_onRescue, players.allies, EVENT_PLAYER_UNIT_RESCUED)
        TriggerAddAction(trig_onRescue, OnRescueAlly)

        TriggerRegisterPlayerUnitEvent(trig_onRescueGiant, players.allies, EVENT_PLAYER_UNIT_RESCUED)
        TriggerAddCondition(trig_onRescueGiant, Condition(function() return
            IsNewUnitAcquired(GetTriggerUnit(), "emtg", is_acquired_mountain_giant)
        end))

        TriggerRegisterPlayerUnitEvent(trig_onRescueChimera, players.allies, EVENT_PLAYER_UNIT_RESCUED)
        TriggerAddCondition(trig_onRescueChimera, Condition(function() return
            IsNewUnitAcquired(GetTriggerUnit(), "echm", is_acquired_chimera)
        end))

        TriggerAddAction(trig_onRescueGiant, OnMountainGiantRescue)
        TriggerAddAction(trig_onRescueChimera, OnChimeraRescue)
    end

    OnInit.map(function()
        human_players_force = AllHumanPlayers()
        for _, def in pairs(quests) do
            def.data = InitQuest(def)
        end
    end)

    OnInit.final(RegisterQuestTrigs)
end