do
    Broadcast = {}

    ---@param unitname string
    function Broadcast.NewUnitAvailable(unitname)
        QuestMessageBJ(GetPlayersAll(), bj_QUESTMESSAGE_UNITAVAILABLE,
            "|cff87CEEBNEW UNIT AVAILABLE|r\n" .. unitname)
    end

    ---@param msg string
    function Broadcast.Hint(msg)
        QuestMessageBJ(GetPlayersAll(), bj_QUESTMESSAGE_HINT,
            "|cff32CD32HINT|r - " .. msg)
    end

    ---@param q QuestDefinition
    function Broadcast.QuestDiscovered(q)
        QuestMessageBJ(GetPlayersAll(), bj_QUESTMESSAGE_DISCOVERED,
            "|cffffcc00QUEST DICOVERED|r\n" .. q.title)
    end


    ---@param q QuestDefinition
    function Broadcast.QuestComplete(q)
        QuestMessageBJ(GetPlayersAll(), bj_QUESTMESSAGE_COMPLETED,
            "|cffffcc00QUEST COMPLETED|r\n" .. q.title)
    end
end