do
    --- Issues targetless order to each
    --- unit in the provided table
    ---@param cmd string
    ---@param units table<number, unit>
    function DispatchUnits(units, cmd)
        if not units then return end

        for _, unit in ipairs(units) do
            IssueImmediateOrderBJ(unit, cmd)
        end
    end


    --- Count structures owned by player
    ---@param p player
    ---@return number
    function CountPlayerStructures(p)
        return CountUnitsInGroup(
            GetUnitsOfPlayerMatching(p, Filter(function()
                local fUnit = GetFilterUnit()

                return IsUnitAliveBJ(fUnit) and
                       IsUnitType(fUnit, UNIT_TYPE_STRUCTURE)
            end)))
    end


    --- Count units matching a predicate filter.
    ---@param p player
    ---@param f filterfunc
    ---@return number
    function CountPlayerUnitsBy(p, f)
        if not p or not f then return 0 end

        return CountUnitsInGroup(
                GetUnitsOfPlayerMatching(p, f))
    end


    --- Set player's gold and lumber.
    ---@param p player
    ---@param gold number
    ---@param lumber number
    function InitResources(p, gold, lumber)
        if p then
            SetPlayerState(p, PLAYER_STATE_RESOURCE_GOLD, math.max(gold, 0))
            SetPlayerState(p, PLAYER_STATE_RESOURCE_LUMBER, math.max(lumber, 0))
        end
    end


    --- Establishes each player as
    --- ALLIANCE_PASSIVE with Neutral Hostile (the creeps)
    ---@param ... player
    function AllyWithNeutral(...)
        local creeps = Player(PLAYER_NEUTRAL_AGGRESSIVE)

        for _, player in pairs({...}) do

            SetPlayerAlliance(player, creeps,
                ALLIANCE_PASSIVE, true)

            SetPlayerAlliance(creeps, player,
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
    --- Extra items will be discarded
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

        TimerStart(t, seconds, false, function()
            callback()
            DestroyTimer(t)
        end)

        return t
    end
end