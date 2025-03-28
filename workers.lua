do
    local function DispatchWorkers(workers)
        for _, worker in ipairs(workers.gold) do
            IssueImmediateOrderBJ(worker, "autoharvestgold")
        end

        for _, worker in ipairs(workers.lumber) do
            IssueImmediateOrderBJ(worker, "autoharvestlumber")
        end
    end

    function InitWorkers()
        local trig_worker_dispatch = CreateTrigger()

        TriggerRegisterTimerEventSingle(trig_worker_dispatch, 0.5)
        TriggerAddAction(trig_worker_dispatch, function()
            DispatchWorkers({
                gold = {
                    gg_unit_ewsp_0007,
                    gg_unit_ewsp_0008,
                    gg_unit_ewsp_0009,
                    gg_unit_ewsp_0010,
                    gg_unit_ewsp_0011,
                },
                lumber = {
                    gg_unit_ewsp_0012,
                    gg_unit_ewsp_0013,
                    gg_unit_ewsp_0014,
                }
            })
        end)
    end
end