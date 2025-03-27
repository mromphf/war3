do
    local _quests = {}

    local _quest_data = {
        main = {
            title = "Purity",
            iconPath = "ReplaceableTextures\\CommandButtons\\BTNHeroDreadLord.blp",
            description = "The Scourge has brought its blight to Ashenvale under the leadership of the dreadlord Terrordar. Priestess Mira Whitemane leads the night elves on an offensive to drive away the demon's undead army.",
            message = "|cffffcc00MAIN QUEST|r\nPurity - Destroy Terrordar's green Undead base",
            items = {
                "Destroy Terrordar's green Undead base"
            }
        }
    }

    local function AssignQuest()
        msg = _quest_data.main.message

        if _quests.main then
            QuestMessageBJ(_ALL_PLAYERS, bj_QUESTMESSAGE_DISCOVERED, msg)
            QuestSetDiscovered(_quests.main, true)
        end
    end

    ---@param q quest
    ---@param data table
    ---@return quest
    local function HydrateQuest(q, data)
        QuestSetDiscovered(q, false)
        QuestSetTitle(q, data.title)
        QuestSetDescription(q, data.description)
        QuestSetIconPath(q, data.iconPath)

        for description in data.items do
            objective = QuestCreateItem(q)
            QuestItemSetDescription(objective, description)
        end

        return q
    end

    function InitQuests()
        _quests.main = HydrateQuest(CreateQuest(), _quest_data.main)

        trig_quest = CreateTrigger()

        TriggerRegisterTimerEventSingle(trig_quest, bj_QUEUE_DELAY_QUEST)
        TriggerAddAction(trig_quest, AssignQuest)
    end
end