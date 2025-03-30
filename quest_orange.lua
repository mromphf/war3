
do
    ---@type boolean
    local quest_unassigned = true

    local function RegisterQuestAssignment()
        local trig = CreateTrigger()

        TriggerRegisterPlayerUnitEvent(trig,
            players.orange, EVENT_PLAYER_UNIT_DEATH)

        TriggerAddCondition(trig, Condition(
            quest_unassigned))

        TriggerAddAction(trig, function()
            quest_unassigned = false

            DisableTrigger(trig)
            TriggerSleepAction(2)
            AssignQuest(quests.orange)
        end)
    end

    local function RegisterQuestComplete()
        local trig = CreateTrigger()

        TriggerRegisterPlayerUnitEvent(trig,
            players.orange, EVENT_PLAYER_UNIT_DEATH)

        TriggerAddCondition(trig, Condition(
            IsUnitType(GetTriggerUnit(), UNIT_TYPE_STRUCTURE) and
            CountPlayerStructures(players.orange) <= 0
        ))

        TriggerAddAction(trig, function()
            DisableTrigger(trig)
            TriggerSleepAction(1.5)
            CompleteQuest(quests.orange)
        end)
    end

    OnInit.trig(function()
        RegisterQuestAssignment()
        RegisterQuestComplete()
    end)
end