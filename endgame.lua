do
    local function PlayerStructures(p)
        return CountUnitsInGroup(
            GetUnitsOfPlayerMatching(p, Condition(
                IsUnitType(GetFilterUnit(), UNIT_TYPE_STRUCTURE))))
    end

    local function Register()
        trig_victory = CreateTrigger()
        trig_defeat = CreateTrigger()

        TriggerRegisterPlayerUnitEvent(trig_victory, players.green, EVENT_PLAYER_UNIT_DEATH)
        TriggerAddCondition(trig_victory, Condition( IsUnitType(GetTriggerUnit(), UNIT_TYPE_STRUCTURE)))
        TriggerAddCondition(trig_victory, Condition(PlayerStructures(players.green) <= 0))
        TriggerAddAction(trig_victory, function()
            CustomVictoryBJ(players.player, true, true)
        end)

        TriggerRegisterPlayerUnitEvent(trig_defeat, players.player, EVENT_PLAYER_UNIT_DEATH)
        TriggerAddCondition(trig_victory, Condition( IsUnitType(GetTriggerUnit(), UNIT_TYPE_STRUCTURE)))
        TriggerAddCondition(trig_victory, Condition(PlayerStructures(players.player) <= 0))
        TriggerAddAction(trig_victory, function()
            TriggerSleepAction(2)
            CustomDefeatBJ(players.player "Defeat!")
        end)
    end

    OnInit.trig(Register)
end