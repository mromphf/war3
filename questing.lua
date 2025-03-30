do
    ---@param q QuestDefinition
    function CompleteQuest(q)
        if q.data then
            QuestSetCompleted(q.data, true)
            Broadcast.QuestComplete(q)
        end
    end

    ---@param quest QuestDefinition
    function AssignQuest(quest)
        if quest.data then
            QuestSetDiscovered(quest.data, true)
            Broadcast.QuestDiscovered(quest)
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
end