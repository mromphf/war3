do
    local cmd_harvest_gold = "autoharvestgold"
    local cmd_harvest_lumber = "autoharvestlumber"
    local cmd_entangle_instantly = "entangleinstant"

    local function DispatchWorkers(workers)
        for _, worker in ipairs(workers.gold) do
            IssueImmediateOrderBJ(worker, cmd_harvest_gold)
        end

        for _, worker in ipairs(workers.lumber) do
            IssueImmediateOrderBJ(worker, cmd_harvest_lumber)
        end
    end

    local function InitWorkers()
        local trig_worker_dispatch = CreateTrigger()
        IssueTargetOrderBJ(units.tree, cmd_entangle_instantly, units.mines.player)

        TriggerRegisterTimerEventSingle(trig_worker_dispatch, 0.5)
        TriggerAddAction(trig_worker_dispatch, function()
            DispatchWorkers(units.workers)
        end)
    end

    OnInit.final(InitWorkers)
end