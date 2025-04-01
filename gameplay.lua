do
    --- Issues targetless order to each
    --- unit in the provided table
    ---@param cmd string
    ---@param units table<number, unit>
    function DispatchUnits(units, cmd)
        if not units or not cmd_str[cmd] then return end

        for _, unit in ipairs(units) do
            IssueImmediateOrderBJ(unit, cmd)
        end
    end


    --- Count structures owned by player
    ---@param p player
    ---@return integer
    function CountPlayerStructures(p)
        return CountUnitsInGroup(
            GetUnitsOfPlayerMatching(p, Condition(function()
                return IsUnitType(GetFilterUnit(), UNIT_TYPE_STRUCTURE)
            end)))
    end


    --- Count units matching a predicate.
    ---@param p player
    ---@param c conditionfunc
    ---@return integer
    function CountPlayerUnitsBy(p, c)
        if not p or not c then return 0 end

        return CountUnitsInGroup(
                GetUnitsOfPlayerMatching(p, c))
    end


    --- Set player's gold and lumber.
    ---@param p player
    ---@param gold integer
    ---@param lumber integer
    function InitResources(p, gold, lumber)
        if p then
            SetPlayerState(p, PLAYER_STATE_RESOURCE_GOLD, math.max(gold, 0))
            SetPlayerState(p, PLAYER_STATE_RESOURCE_LUMBER, math.max(lumber, 0))
        end
    end


    --- Establishes each provided player as
    --- ALLIANCE_PASSIVE with Neutral Hostile
    ---@param ... player
    function AllyWithNeutral(...)
        for _, plyr in pairs({...}) do
            SetPlayerAlliance(plyr, players.neutral_hostile,
                ALLIANCE_PASSIVE, true)

            SetPlayerAlliance(players.neutral_hostile, plyr,
                ALLIANCE_PASSIVE, true)
        end
    end


    --- Increments the hero's skill level by
    --- one for each provided skill code.
    ---@param u unit
    ---@param ... string
    function LearnSkills(u, ...)
        for _, skill_code in pairs({...}) do
            IncUnitAbilityLevel(u,
                FourCC(skill_code))
        end
    end


    --- Give items to a hero.
    --- Further items will be discarded
    --- once the hero's inventory is full.
    ---@param u unit
    ---@param ... string
    function GiveItems(u, ...)
        for _, item_code in pairs({...}) do
            if UnitInventoryCount(u) < UnitInventorySize(u) then
                UnitAddItemById(u,
                    FourCC(item_code))
            end
        end
    end



    --- Creates and starts a new timer,
    --- invoking the callback function when timer elapses.
    --- Returns timer ref. Timer disposed following
    --- callback invocation.
    ---@param seconds number
    ---@param callback function
    ---@return timer
    function StartNewTimer(seconds, callback)
        local t = CreateTimer()

        TimerStart(t, math.max(seconds, 0), false, function()
            callback()
            DestroyTimer(t)
        end)

        return t
    end
end