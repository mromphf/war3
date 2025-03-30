do
    ---@param cmd string
    ---@param units table<number, unit>
    function DispatchUnits(units, cmd)
        for _, unit in ipairs(units) do
            IssueImmediateOrderBJ(unit, cmd)
        end
    end


    ---@param p player
    ---@return integer
    function CountPlayerStructures(p)
        return CountUnitsInGroup(
            GetUnitsOfPlayerMatching(p, Condition(
                IsUnitType(GetFilterUnit(), UNIT_TYPE_STRUCTURE))))
    end


    ---@param p player
    ---@param c conditionfunc
    ---@return integer
    function CountPlayerUnitsBy(p, c)
        return CountUnitsInGroup(
                GetUnitsOfPlayerMatching(p, c))
    end


    ---@param p player
    ---@param gold integer
    ---@param lumber integer
    function InitResources(p, gold, lumber)
        SetPlayerState(p, PLAYER_STATE_RESOURCE_GOLD, gold)
        SetPlayerState(p, PLAYER_STATE_RESOURCE_LUMBER, lumber)
    end


    ---@param ... player
    function AllyWithNeutral(...)
        for _, plyr in pairs({...}) do
            SetPlayerAlliance(plyr, players.neutral_hostile,
                ALLIANCE_PASSIVE, true)

            SetPlayerAlliance(players.neutral_hostile, plyr,
                ALLIANCE_PASSIVE, true)
        end
    end


    ---@param u unit
    ---@param ... string
    function LearnSkills(u, ...)
        for _, skill_code in pairs({...}) do
            IncUnitAbilityLevel(u,
                FourCC(skill_code))
        end
    end


    ---@param u unit
    ---@param ... string
    function GiveItems(u, ...)
        for _, item_code in pairs({...}) do
            UnitAddItemById(u,
                FourCC(item_code))
        end
    end
end