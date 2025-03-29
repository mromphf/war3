do
    ---@type function
    tUnit = function()
        print("ERR: tu not initialized")
    end

    ---@param cmd string
    ---@param units table<number, unit>
    function DispatchUnits(units, cmd)
        for _, unit in ipairs(units) do
            IssueImmediateOrderBJ(unit, cmd)
        end
    end

    OnInit.global(function()
        tUnit = GetTriggerUnit
    end)
end