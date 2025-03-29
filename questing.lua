do
    ---@type integer
    local MAX_PLAYERS = 15

    ---@type force
    local human_players_force

    ---@type leaderboard
    local leaderboard

    ---@type boolean
    local is_acquired_mountain_giant

    ---@type boolean
    local is_acquired_chimera

    ---@param p player
    ---@return boolean
    local function IsHumanPlaying(p)
        return GetPlayerSlotState(p) == PLAYER_SLOT_STATE_PLAYING and
               GetPlayerController(p) == MAP_CONTROL_USER
    end

    ---@return force
    local function AllHumanPlayers()
        local f = CreateForce()

        for n = 0, MAX_PLAYERS - 1 do
            local p = Player(n)
            if IsHumanPlaying(p) then
                ForceAddPlayer(f, p)
            end
        end

        return f
    end

    ---@param quest QuestDefinition
    local function AssignQuest(quest)
        if quest.data then
            QuestMessageBJ(human_players_force or AllHumanPlayers(), bj_QUESTMESSAGE_DISCOVERED, quest.message)
            QuestSetDiscovered(quest.data, true)
        end
    end

    ---@param definition QuestDefinition
    ---@return quest
    local function InitQuest(definition)
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

        print(lb)
        return lb
    end

    local function AssignRescueQuest()
        if IsQuestDiscovered(quests.rescue.data) then return end
        leaderboard = InitLeaderboard(human_players_force)

        TriggerSleepAction(1.5)
        LeaderboardDisplay( leaderboard, true)
        AssignQuest(quests.rescue)
        TriggerSleepAction(bj_QUEUE_DELAY_HINT)
        QuestMessageBJ(human_players_force, bj_QUESTMESSAGE_HINT, "|cff32CD32HINT|r - Rescued allies will not consume food!")
    end

    local function OnMountainGiantRescue()
        is_acquired_mountain_giant = true

        SetPlayerUnitAvailableBJ(FourCC("emtg"), true, players.player)
        -- TODO: Not enabling ability available
        SetPlayerAbilityAvailableBJ(true, FourCC("Rers"), players.player)
        SetPlayerAbilityAvailableBJ(true, FourCC("Rehs"), players.player)
        TriggerSleepAction(2)
        QuestMessageBJ(human_players_force, bj_QUESTMESSAGE_UNITAVAILABLE, "|cff87CEEBNEW UNIT AVAILABLE|r\nMountain Giants")
    end

    local function OnChimeraRescue()
        is_acquired_chimera = true

        SetPlayerUnitAvailableBJ(FourCC("edos"), true, players.player)
        TriggerSleepAction(2)
        QuestMessageBJ(human_players_force, bj_QUESTMESSAGE_UNITAVAILABLE, "|cff87CEEBNEW UNIT AVAILABLE|r\nChimeras")
    end

    local function OnRescueAlly()
        if IsQuestDiscovered(quests.rescue.data) then
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

    local function InitQuests()
        local trig_assignMain = CreateTrigger()
        local trig_assignRescue = CreateTrigger()
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
        quests.main.data = InitQuest( quests.main)
        quests.rescue.data = InitQuest(quests.rescue)
    end)

    OnInit.final(InitQuests)
end