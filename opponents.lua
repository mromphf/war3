do
    ---@param p player
    ---@param state playerstate
    local function RegisterResourceTrigger(p, state)
        trig = CreateTrigger()
        TriggerRegisterPlayerStateEvent(trig, p, state, LESS_THAN_OR_EQUAL, 500)
        TriggerAddAction(trig, function()
            SetPlayerState(p, state, 10000)
        end)
    end

    local function RegisterTriggers()
        RegisterResourceTrigger(players.green, PLAYER_STATE_RESOURCE_GOLD)
        RegisterResourceTrigger(players.green, PLAYER_STATE_RESOURCE_LUMBER)
        RegisterResourceTrigger(players.orange, PLAYER_STATE_RESOURCE_GOLD)
        RegisterResourceTrigger(players.orange, PLAYER_STATE_RESOURCE_LUMBER)
    end

    local function FireAi()
        StartCampaignAI(players.green, "war3mapImported\\moderate undead.ai")
        StartCampaignAI(players.orange, "war3mapImported\\spammy undead.ai")
    end

    OnInit.map(RegisterTriggers)
    OnInit.final(FireAi)
end