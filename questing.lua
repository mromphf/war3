do
    ---@type integer
    local MAX_PLAYERS = 15

    ---@type force | nil
    local _players = nil

    local _quests = {
        ---@class QuestDefinition
        ---@field data quest | nil
        ---@field discovered boolean
        ---@field title string
        ---@field iconPath string
        ---@field description string
        ---@field message string
        ---@field items table<integer, string>
        main = {
            data = nil,
            discovered = false,
            title = "Purity",
            iconPath = "ReplaceableTextures\\CommandButtons\\BTNHeroDreadLord.blp",
            description = "The Scourge has brought its blight to Ashenvale under the leadership of the dreadlord Terrordar. Priestess Mira Whitemane leads the night elves on an offensive to drive away the demon's undead army.",
            message = "|cffffcc00MAIN QUEST|r\nPurity - Destroy Terrordar's green Undead base",
            items = {
                "Destroy Terrordar's green Undead base"
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

        for n = 0, MAX_PLAYERS do
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

        local trig_assignment = CreateTrigger()

        TriggerRegisterTimerEventSingle(trig_assignment, bj_QUEUE_DELAY_QUEST)
        TriggerAddAction(trig_assignment, function()
            AssignQuest(_quests.main)
        end)
    end
end