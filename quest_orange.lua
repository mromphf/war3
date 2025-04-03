do
    ---@type boolean
    local quest_unassigned = true

    local function RegisterQuestAssignment()
        local trig = CreateTrigger()

        TriggerRegisterPlayerUnitEvent(trig,
            players.orange, EVENT_PLAYER_UNIT_DEATH)

        TriggerAddCondition(trig, Condition(function()
            return quest_unassigned
        end))

        TriggerAddAction(trig, function()
            quest_unassigned = false

            DisableTrigger(trig)
            StartNewTimer(2.0, function()
                AssignQuest(quests.orange)
            end)
        end)
    end

    local function RegisterQuestComplete()
        local trig = CreateTrigger()

        TriggerRegisterPlayerUnitEvent(trig,
            players.orange, EVENT_PLAYER_UNIT_DEATH)

        TriggerAddCondition(trig, Condition(function()
            return IsUnitType(GetTriggerUnit(), UNIT_TYPE_STRUCTURE) and
                    (CountPlayerStructures(players.orange) <= 0)
        end ))

        TriggerAddAction(trig, function()
            DisableTrigger(trig)
            StartNewTimer(1.5, function()
                CompleteQuest(quests.orange)
            end)
        end)
    end

    OnInit.final(function()
        RegisterQuestAssignment()
        RegisterQuestComplete()
    end)
end