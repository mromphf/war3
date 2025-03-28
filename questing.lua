do
    ---@type integer
    local MAX_PLAYERS = 15

    ---@type force
    local human_players_force

    ---@type leaderboard
    local _leaderboard

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

    local function InitQuests()
        local trig_assignMain = CreateTrigger()
        local trig_assignRescue = CreateTrigger()

        TriggerRegisterTimerEventSingle(trig_assignMain, bj_QUEUE_DELAY_QUEST)
        TriggerAddAction(trig_assignMain, function()
            DisableTrigger(trig_assignMain)
            AssignQuest(quests.main)
        end)

        TriggerRegisterPlayerUnitEvent(trig_assignRescue, players.allies, EVENT_PLAYER_UNIT_RESCUED)
        TriggerAddAction(trig_assignRescue, function()
            DisableTrigger(trig_assignRescue)
            local pc = players.player
            local allies = players.allies

            _leaderboard = CreateLeaderboardBJ(human_players_force, "")
            LeaderboardDisplay(_leaderboard, false)
            LeaderboardAddItemBJ(pc, _leaderboard, "Allies to Rescue",
                CountUnitsInGroup(GetUnitsOfPlayerAll(allies)))
            LeaderboardSetPlayerItemLabelColorBJ(pc, _leaderboard, 0, 70, 70, 0)
            LeaderboardSetPlayerItemValueColorBJ(pc, _leaderboard, 100, 100, 100, 0)

            TriggerSleepAction(1.5)
            LeaderboardDisplay( _leaderboard, true)
            AssignQuest(quests.rescue)
        end)
    end

    OnInit.map(function()
        human_players_force = AllHumanPlayers()
        quests.main.data = InitQuest( quests.main)
        quests.rescue.data = InitQuest(quests.rescue)
    end)

    OnInit.final(InitQuests)
end