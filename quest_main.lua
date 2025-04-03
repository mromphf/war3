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
                    (CountPlayerStructures(players.green) <= 0)
        end))

        TriggerAddAction(trig, function()
            DisableTrigger(trig)

            StartNewTimer(1.5, function()
                CompleteQuest(quests.main)
            end)

            StartNewTimer(3, function()
                CustomVictoryBJ(players.player, true, true)
            end)
        end)
    end

    local function TrigsDefeat()
        local trig = CreateTrigger()

        TriggerRegisterPlayerUnitEvent(trig,
            players.player, EVENT_PLAYER_UNIT_DEATH)

        TriggerAddCondition(trig, Condition(function()
            return IsUnitType(GetTriggerUnit(), UNIT_TYPE_STRUCTURE) and
                    (CountPlayerStructures(players.player) <= 0)
        end))

        TriggerAddAction(trig, function()
            DisableTrigger(trig)

            StartNewTimer(1.0, function()
                CustomDefeatBJ(players.player, "Defeat!")
            end)
        end)
    end

    OnInit.final(function()
        TrigsAssignQuest()
        TrigsVictory()
        TrigsDefeat()
    end)
end