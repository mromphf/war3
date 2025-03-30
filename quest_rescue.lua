do
    ---@type leaderboard
    local leaderboard = nil

    ---@type boolean
    local acquired_mountain_giant

    ---@type boolean
    local acquired_chimera


    ---@param f force
    ---@return leaderboard
    local function InitLeaderboard(f)
        lb = CreateLeaderboardBJ(f, "")

        LeaderboardDisplay(lb, false)
        LeaderboardAddItemBJ(players.player, lb, "Allies to Rescue",
            CountUnitsInGroup(GetUnitsOfPlayerAll(players.allies)))

        LeaderboardSetPlayerItemLabelColorBJ(players.player, lb, 0, 70, 70, 0)
        LeaderboardSetPlayerItemValueColorBJ(players.player, lb, 100, 100, 100, 0)

        return lb
    end

    local function OnMountainGiantRescue()
        if acquired_mountain_giant then return end

        acquired_mountain_giant = true

        SetPlayerUnitAvailableBJ(FourCC("emtg"), true, players.player)
        -- TODO: Not enabling ability available
        SetPlayerAbilityAvailableBJ(true, FourCC("Rers"), players.player)
        SetPlayerAbilityAvailableBJ(true, FourCC("Rehs"), players.player)

        TriggerSleepAction(2)
        Broadcast.NewUnitAvailable("Mountain Giant")
    end

    local function OnChimeraRescue()
        if acquired_chimera then return end

        acquired_chimera = true

        SetPlayerUnitAvailableBJ(FourCC("edos"), true, players.player)
        TriggerSleepAction(2)

        Broadcast.NewUnitAvailable("Chimera")
    end

    local function RegisterRescue()
        local trig = CreateTrigger()

        TriggerRegisterPlayerUnitEvent(trig,
            players.allies, EVENT_PLAYER_UNIT_RESCUED)

        TriggerAddAction(trig, function()
            if GetUnitTypeId(GetTriggerUnit()) == FourCC("emtg") then
                OnMountainGiantRescue()
            end

            if GetUnitTypeId(GetTriggerUnit()) == FourCC("echm") then
                OnChimeraRescue()
            end

            SetUnitUseFood(GetTriggerUnit(), false)
            LeaderboardSetItemValue(leaderboard,
                LeaderboardGetPlayerIndex(leaderboard, players.player),
                CountUnitsInGroup(GetUnitsOfPlayerAll(players.allies)))
        end)
    end

    local function RegisterAssignment()
        local trig = CreateTrigger()

        TriggerRegisterPlayerUnitEvent(trig,
            players.allies, EVENT_PLAYER_UNIT_RESCUED)

        TriggerAddAction(trig, function()
            leaderboard = InitLeaderboard(GetPlayersAll())

            DisableTrigger(trig)
            TriggerSleepAction(1.5)
            LeaderboardDisplay( leaderboard, true)
            AssignQuest(quests.rescue)
            TriggerSleepAction(bj_QUEUE_DELAY_HINT)
            Broadcast.Hint("Rescued allies will not cost food!")
        end)
    end

    local function RegisterCompletion()
        local trig = CreateTrigger()

        TriggerRegisterPlayerUnitEvent(trig,
            players.allies, EVENT_PLAYER_UNIT_RESCUED)

        TriggerAddCondition(trig, Condition(
            CountUnitsInGroup(
                GetUnitsOfPlayerAll(players.allies)) <= 0))

        TriggerAddAction(trig, function()
            DisableTrigger(trig)
            TriggerSleepAction(1.5)
            LeaderboardDisplay(leaderboard, false)
            CompleteQuest(quests.rescue)
        end)
    end

    OnInit.trig(function()
        RegisterRescue()
        RegisterAssignment()
        RegisterCompletion()
    end)
end