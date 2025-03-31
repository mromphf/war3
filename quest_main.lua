do
    local function TrigsAssignQuest()
        local trig = CreateTrigger()

        TriggerRegisterTimerEventSingle(trig,
            bj_QUEUE_DELAY_QUEST)

        TriggerAddAction(trig, function()
            DisableTrigger(trig)
            AssignQuest(quests.main)
        end)
    end

    local function TrigsVictory()
        local trig = CreateTrigger()

        TriggerRegisterPlayerUnitEvent(trig,
            players.green, EVENT_PLAYER_UNIT_DEATH)

        TriggerAddCondition(trig, Condition(function()
            return IsUnitType(GetTriggerUnit(), UNIT_TYPE_STRUCTURE) and
                    CountPlayerStructures(players.green) <= 0
        end))

        TriggerAddAction(trig, function()
            DisableTrigger(trig)

            TriggerSleepAction(1.5)
            CompleteQuest(quests.green)

            TriggerSleepAction(3)
            CustomVictoryBJ(players.player, true, true)
        end)
    end

    local function TrigsDefeat()
        local trig = CreateTrigger()

        TriggerRegisterPlayerUnitEvent(trig,
            players.player, EVENT_PLAYER_UNIT_DEATH)

        TriggerAddCondition(trig, Condition(function()
            return IsUnitType(GetTriggerUnit(), UNIT_TYPE_STRUCTURE) and
                    CountPlayerStructures(players.player) <= 0
        end))

        TriggerAddAction(trig, function()
            DisableTrigger(trig)

            TriggerSleepAction(1.0)
            CustomDefeatBJ(players.player, "Defeat!")
        end)
    end

    OnInit.trig(function()
        TrigsAssignQuest()
        TrigsVictory()
        TrigsDefeat()
    end)
end