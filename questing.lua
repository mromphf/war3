do
    ---@type integer
    local MAX_PLAYERS = 15

    ---@type force | nil
    local _players = nil

    ---@type leaderboard | nil
    local _leaderboard = nil

    local _quests = {
        ---@class QuestDefinition
        ---@field data quest | nil
        ---@field required boolean
        ---@field discovered boolean
        ---@field title string
        ---@field iconPath string
        ---@field description string
        ---@field message string
        ---@field items table<integer, string>
        main = {
            data = nil,
            required = true,
            discovered = false,
            title = "Purity",
            iconPath = "ReplaceableTextures\\CommandButtons\\BTNHeroDreadLord.blp",
            description = "The Scourge has brought its blight to Ashenvale under the leadership of the dreadlord Terrordar. Priestess Mira Whitemane leads the night elves on an offensive to drive away the demon's undead army.",
            message = "|cffffcc00MAIN QUEST|r\nPurity - Destroy Terrordar's green Undead base",
            items = {
                "Destroy Terrordar's green Undead base"
            }
        },
        rescue = {
            data = nil,
            required = false,
            discovered = false,
            title = "Nature's Guardians",
            iconPath = "ReplaceableTextures\\CommandButtons\\BTNDryad.blp",
            description = "The Scourge's blight has stirred the creatures of the forest from their dens and burrows. The druids and dryads of Ashenvale will join your quest if you help them.",
            message = "|cffffcc00OPTIONAL QUEST|r\nNature's Guardians - Rescue all Ashenvale Guardians",
            items = {
                "Rescue all Ashenvale Guardians"
            }
        }
    }

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
            QuestMessageBJ(_players or AllHumanPlayers(), bj_QUESTMESSAGE_DISCOVERED, quest.message)
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

    function InitQuests()
        _players = AllHumanPlayers()
        _quests.main.data = InitQuest( _quests.main)
        _quests.rescue.data = InitQuest(_quests.rescue)

        local trig_assignMain = CreateTrigger()
        local trig_assignRescue = CreateTrigger()

        TriggerRegisterTimerEventSingle(trig_assignMain, bj_QUEUE_DELAY_QUEST)
        TriggerAddAction(trig_assignMain, function()
            DisableTrigger(trig_assignMain)
            AssignQuest(_quests.main)
        end)

        TriggerRegisterPlayerUnitEvent(trig_assignRescue, Player(2), EVENT_PLAYER_UNIT_RESCUED)
        TriggerAddAction(trig_assignRescue, function()
            DisableTrigger(trig_assignRescue)
            local pc = Player(1)
            local allies = Player(2)

            _leaderboard = CreateLeaderboardBJ(_players, "")
            LeaderboardDisplay(_leaderboard, false)
            LeaderboardAddItemBJ(pc, _leaderboard, "Allies to Rescue",
                CountUnitsInGroup(GetUnitsOfPlayerAll(allies)))
            LeaderboardSetPlayerItemLabelColorBJ(pc, _leaderboard, 0, 70, 70, 0)
            LeaderboardSetPlayerItemValueColorBJ(pc, _leaderboard, 100, 100, 100, 0)

            TriggerSleepAction(1.5)
            LeaderboardDisplay( _leaderboard, true)
            AssignQuest(_quests.rescue)
        end)
    end
end