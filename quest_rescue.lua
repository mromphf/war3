do
    ---@type leaderboard
    local leaderboard

    ---@type boolean
    local acquired_mountain_giant

    ---@type boolean
    local acquired_chimera


    ---@return leaderboard
    local function InitLeaderboard()
        lb = CreateLeaderboardBJ(GetPlayersAll(), "")

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

        StartNewTimer(2.0, function()
            Broadcast.NewUnitAvailable("Mountain Giant")
        end)
    end

    local function OnChimeraRescue()
        if acquired_chimera then return end

        acquired_chimera = true

        SetPlayerUnitAvailableBJ(FourCC("edos"), true, players.player)

        StartNewTimer(2.0, function()
            Broadcast.NewUnitAvailable("Chimera")
        end)
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
            DisableTrigger(trig)

            StartNewTimer(1.5, function()
                LeaderboardDisplay(leaderboard, true)
                AssignQuest(quests.rescue)
            end)

            StartNewTimer(8.0, function()
                Broadcast.Hint("Rescued allies do not cost food!")
            end)
        end)
    end

    local function RegisterCompletion()
        local trig = CreateTrigger()

        TriggerRegisterPlayerUnitEvent(trig,
            players.allies, EVENT_PLAYER_UNIT_RESCUED)

        TriggerAddCondition(trig, Condition(function()
            return CountUnitsInGroup(
                    GetUnitsOfPlayerAll(players.allies)) <= 0
        end))

        TriggerAddAction(trig, function()
            DisableTrigger(trig)

            StartNewTimer(1.5, function()
                LeaderboardDisplay(leaderboard, false)
                CompleteQuest(quests.rescue)
            end)
        end)
    end

    OnInit.final(function()
        leaderboard = InitLeaderboard()
        RegisterRescue()
        RegisterAssignment()
        RegisterCompletion()
    end)
end