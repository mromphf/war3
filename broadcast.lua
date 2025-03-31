do
    Broadcast = {}

    ---@param unitname string
    ---@param delay? number | nil
    function Broadcast.NewUnitAvailable(unitname, delay)
        StartNewTimer(math.max(delay, 0), function()
            QuestMessageBJ(GetPlayersAll(), bj_QUESTMESSAGE_UNITAVAILABLE,
                "|cff87CEEBNEW UNIT AVAILABLE|r\n" .. unitname)
        end)
    end

    ---@param msg string
    ---@param delay? number | nil
    function Broadcast.Hint(msg, delay)
        StartNewTimer(math.max(delay, 0), function()
            QuestMessageBJ(GetPlayersAll(), bj_QUESTMESSAGE_HINT,
                "|cff32CD32HINT|r: " .. msg)
        end)
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