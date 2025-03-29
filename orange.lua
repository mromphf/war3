do
    ---@type function
    local tu = function()
        print("ERR: tu not initialized")
    end

    local function ResolveOrangeQuest()
        TriggerSleepAction(1.5)
        CompleteQuest(quests.orange, "|cffffcc00QUEST COMPLETED|r\nComorbidity")
    end

    local function InitTrigs()
        t = CreateTrigger()

        TriggerRegisterPlayerUnitEvent(t, players.orange, EVENT_PLAYER_UNIT_DEATH)
        TriggerAddCondition(t, Condition(IsUnitType(tu(), UNIT_TYPE_STRUCTURE)))
        -- TODO: no more structures
        TriggerAddAction(t, function()
            DisableTrigger(t)
            ResolveOrangeQuest()
        end)
    end

    OnInit.map(InitTrigs)
    OnInit.global(function()
        tu = GetTriggerUnit
    end)
end