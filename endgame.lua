local Broadcast = require("broadcast")

do
    local function trigsRescueQuest()
        t = CreateTrigger()

        TriggerRegisterPlayerUnitEvent(t,
            players.allies, EVENT_PLAYER_UNIT_RESCUED)

        TriggerAddCondition(t, Condition(
            CountUnitsInGroup(
                GetUnitsOfPlayerAll(players.allies)) <= 0))

        TriggerAddAction(t, function()
            DisableTrigger(t)
            TriggerSleepAction(1.5)
            LeaderboardDisplay(leaderboard, false)
            Broadcast.QuestComplete(quests.rescue)
        end)
    end

    local function trigsOrangeQuest()
        t = CreateTrigger()

        TriggerRegisterPlayerUnitEvent(t,
            players.orange, EVENT_PLAYER_UNIT_DEATH)

        TriggerAddCondition(t, Condition(
            IsUnitType(GetTriggerUnit(), UNIT_TYPE_STRUCTURE)))

        TriggerAddCondition(t, Condition(
            CountPlayerStructures(players.orange) <= 0))

        TriggerAddAction(t, function()
            DisableTrigger(t)
            TriggerSleepAction(1.5)
            Broadcast.QuestComplete(quests.orange)
        end)
    end

    local function trigsEndgame()
        trig_victory = CreateTrigger()
        trig_defeat = CreateTrigger()

        TriggerRegisterPlayerUnitEvent(trig_victory,
            players.green, EVENT_PLAYER_UNIT_DEATH)

        TriggerAddCondition(trig_victory, Condition(
            IsUnitType(GetTriggerUnit(), UNIT_TYPE_STRUCTURE)))

        TriggerAddCondition(trig_victory, Condition(
            CountPlayerStructures(players.green) <= 0))

        TriggerAddAction(trig_victory, function()
            TriggerSleepAction(1.5)
            Broadcast.CompleteQuest(quests.main)
            TriggerSleepAction(3)
            CustomVictoryBJ(players.player, true, true)
        end)

        TriggerRegisterPlayerUnitEvent(trig_defeat,
            players.player, EVENT_PLAYER_UNIT_DEATH)

        TriggerAddCondition(trig_defeat, Condition(
            IsUnitType(GetTriggerUnit(), UNIT_TYPE_STRUCTURE)))

        TriggerAddCondition(trig_defeat, Condition(
            CountPlayerStructures(players.player) <= 0))

        TriggerAddAction(trig_defeat, function()
            TriggerSleepAction(1.0)
            CustomDefeatBJ(players.player "Defeat!")
        end)
    end

    OnInit.trig(trigsEndgame)
    OnInit.trig(trigsOrangeQuest)
    OnInit.trig(trigsRescueQuest)
end