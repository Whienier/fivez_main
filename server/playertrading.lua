local tradeRequests = {}
local openTrades = {}

--Loops through existing requests to check if source or the target source already exist 
function CheckForExistingRequest(source, targetsource)
    if #tradeRequests <= 0 then return false end
    for k,v in pairs(tradeRequests) do
        if v.trader == source or v.trader == targetsource or v.target == source or v.target == targetsource then
            return true
        end
    end

    return false
end

function GetTraderFromRequest(source)
    for k,v in pairs(tradeRequests) do
        if v.target == source then
            return v.trader
        end
    end
end

function AddTradeRequest(source, targetsource)
    table.insert(tradeRequests, {
        trader = source,
        target = targetsource
    })
end
--Used when the target is decline the trade request
function RemoveTradeRequest(source)
    for k,v in pairs(tradeRequests) do
        if v.target == source then
            local traderSource = v.trader
            table.remove(tradeRequests, k)
            return traderSource
        end
    end
    return false
end
--Used when a trader is the one cancelling the trade request
function CancelTradeRequest(source)
    for k,v in pairs(tradeRequests) do
        if v.trader == source then
            local targetSource = v.target
            table.remove(tradeRequests, k)
            return targetSource
        end
    end
    return false
end

function GetExistingOpenTrade(source)
    for k,v in pairs(openTrades) do
        if v.trader == source or v.target == source then
            return v
        end
    end

    return false
end

function RemoveOpenTrade(source)
    for k,v in pairs(openTrades) do
        if v.target == source then
            local traderSource = v.trader
            table.remove(openTrades, k)
            return traderSource
        end
        if v.trader == source then
            local targetSource = v.target
            table.remove(openTrades, k)
            return targetSource
        end
    end

    return false
end

RegisterNetEvent("fivez:RequestTrade", function(targetsource)
    local source = source
    local existingRequest = CheckForExistingRequest(source, targetsource)
    if not existingRequest then
        AddTradeRequest(source, targetsource)
        local playerData = GetJoinedPlayer(source)
        local targetPlayerData = GetJoinedPlayer(targetsource)
        TriggerClientEvent("fivez:AddNotification", targetsource, playerData.name.." has requested a trade")
        TriggerClientEvent("fivez:AddNotification", source, "You have requested a trade with"..targetPlayerData.name)
    else
        TriggerClientEvent("fivez:AddNotification", source, "You or the target already have a trade request!")
    end
end)

RegisterNetEvent("fivez:AcceptTradeRequest", function()
    local source = source
    local existingRequest = CheckForExistingRequest(-1, source)
    if existingRequest then
        local traderSource = GetTraderFromRequest(source)
        local playerData = GetJoinedPlayer(source)
        local traderPlayerData = GetJoinedPlayer(traderSource)
        TriggerClientEvent("fivez:AddNotification", source, "You have accepted "..traderPlayerData.name.."'s trade request")
        TriggerClientEvent("fivez:AddNotification", traderSource, playerData.name.." has accepted your trade request")

        table.insert(openTrades, {trader = traderSource, target = source, traderAccepted = false, targetAccepted = false})
        TriggerClientEvent("fivez:StartTrade", source)
        TriggerClientEvent("fivez:StartTrade", traderSource)
    else
        TriggerClientEvent("fivez:AddNotification", source, "You don't have an existing trade request!")
    end
end)

RegisterNetEvent("fivez:DeclineTradeRequest", function()
    local source = source
    local existingRequest = CheckForExistingRequest(-1, source)

    if existingRequest then
        local result = RemoveTradeRequest(source)
        local playerData = GetJoinedPlayer(source)
        if result == false then
            TriggerClientEvent("fivez:AddNotification", source, "Couldn't find existing trade request!")
        elseif result > 0 then
            TriggerClientEvent("fivez:AddNotification", source, "You have declined the trade request")
            TriggerClientEvent("fivez:AddNotification", result, playerData.name.." declined your trade request")
        end
    else
        TriggerClientEvent("fivez:AddNotification", source, "You don't have an existing trade request!")
    end
end)

RegisterNetEvent("fivez:CancelTradeRequest", function()
    local source = source
    local existingRequest = CheckForExistingRequest(source, -1)

    if existingRequest then
        local result = CancelTradeRequest(source)
        if result == false then
            TriggerClientEvent("fivez:AddNotification", source, "Couldn't find existing trade request!")
        elseif result > 0 then
            TriggerClientEvent("fivez:AddNotification", result, "The trade request has been cancelled")
            TriggerClientEvent("fivez:AddNotification", source, "You have cancelled the trade request")
        end
    else
        TriggerClientEvent("fivez:AddNotification", source, "You don't have any existing trade requests!")
    end
end)

RegisterNetEvent("fivez:AcceptTrade", function()
    local source = source
    local existingRequest = CheckForExistingRequest(source, source)

    if existingRequest then
        local result = GetOpenTrade(source)

        if result == false then
            TriggerClientEvent("fivez:AddNotification", source, "Couldn't find existing open trade!")
        else
            if result.trader == source then
                result.traderAccepted = true
                if result.targetAccepted then
                    TriggerClientEvent("fivez:FinishTrade", source)
                    TriggerClientEvent("fivez:FinishTrade", result.target)
                end
            elseif result.target == source then
                result.targetAccepted = true
                if result.traderAccepted then
                    TriggerClientEvent("fivez:FinishTrade", source)
                    TriggerClientEvent("fivez:FinishTrade", result.trader)
                end
            else
                TriggerClientEvent("fivez:AddNotification", source, "Found an open trade, but you aren't apart of it")
            end
        end
    else
        TriggerClientEvent("fivez:AddNotification", source, "You don't have any trade requests!")
    end
end)

RegisterNetEvent("fivez:CancelTrade", function()
    local source = source
    local existingRequest = CheckForExistingRequest(source, source)

    if existingRequest then
        local result = RemoveOpenTrade(source)

        if result == false then
            TriggerClientEvent("fivez:AddNotification", source, "Couldn't find existing open trade!")
        elseif result > 0 then
            TriggerClientEvent("fivez:CancelTrade", source)
            TriggerClientEvent("fivez:CancelTrade", result)
        end
    else
        TriggerClientEvent("fivez:AddNotification", source, "You don't have any existing trade requests!")
    end
end)