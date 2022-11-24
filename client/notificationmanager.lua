local notifications = {}
local announcements = {}

function AddAnnouncement(message, delay)
    local time = delay or 5
    local removeTime = GetGameTimer() + (time * 1000)
    
    table.insert(announcements, {
        message = message,
        removeTime = removeTime
    })

    SendNUIMessage({
        type = "fivez_notifications",
        name = "AddAnnouncement",
        data = message
    })
end

function AddNotification(message, delay)
    local time = delay or 5
    local removeTime = GetGameTimer() + (time * 1000)
    table.insert(notifications, {
        message = message,
        removeTime = removeTime
    })

    SendNUIMessage({
        type = "fivez_notifications",
        name = "AddNotification",
        data = message
    })
end

Citizen.CreateThread(function()
    while true do
        for k,v in pairs(notifications) do
            if v.removeTime < GetGameTimer() then
                SendNUIMessage({
                    type = "fivez_notifications",
                    name = "RemoveNotification",
                    data = k
                })
                table.remove(notifications, k)
            end
        end
        for k,v in pairs(announcements) do
            if v.removeTime < GetGameTimer() then
                SendNUIMessage({
                    type = "fivez_notifications",
                    name = "RemoveAnnouncement",
                    data = k
                })
                table.remove(announcements, k)
            end
        end
        Citizen.Wait(1000)
    end
end)

RegisterNetEvent("fivez:AddNotification", function(message, delay)
    AddNotification(message, delay)
end)

RegisterNetEvent("fivez:AddAnnouncement", function(message, delay)
    AddAnnouncement(message, delay)
end)

RegisterNetEvent("fivez:AddInventoryNotification", function(added, item)
    SendNUIMessage({
        type = "message",
        message = "addNotification",
        added = added,
        item = json.decode(item)
    })
end)