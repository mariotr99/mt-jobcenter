local QBCore = exports['qb-core']:GetCoreObject()
local insideZone = false

CreateThread(function()
    local zone = Config.JobCenterZone

    local jobCenterZone = BoxZone:Create(zone.coords, zone.length, zone.width, {
        name = "jobcenter_zone",
        heading = zone.heading,
        minZ = zone.minZ,
        maxZ = zone.maxZ,
        debugPoly = false
    })

    jobCenterZone:onPlayerInOut(function(isInside)
        insideZone = isInside

        if isInside then
            exports['qb-core']:DrawText("[E] Centro de Empleo", "left")
        else
            exports['qb-core']:HideText()
        end
    end)
end)

CreateThread(function()
    local npcData = Config.JobCenterNPC
    local model = npcData.model
    local coords = npcData.coords

    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(10)
    end

    local ped = CreatePed(0, model, coords.x, coords.y, coords.z - 1.0, coords.w, false, true)
    SetEntityInvincible(ped, true)
    SetEntityAsMissionEntity(ped, true, true)
    FreezeEntityPosition(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)

    if npcData.scenario and npcData.scenario ~= "" then
        TaskStartScenarioInPlace(ped, npcData.scenario, 0, true)
    end
end)

RegisterCommand("jobcenter_interact", function()
    if insideZone then
        QBCore.Functions.TriggerCallback('jobcenter:getPlayerData', function(playerData)
            SetNuiFocus(true, true)
            SendNUIMessage({
                action = "openUI",
                charinfo = playerData.charinfo,
                citizenid = playerData.citizenid,
                money = playerData.money,
                job = playerData.job,
                licenses = playerData.licenses or {}
            })
        end)
    end
end, false)

RegisterKeyMapping("jobcenter_interact", "Abrir Centro de Empleo", "keyboard", "E")

RegisterNUICallback("closeUI", function()
    SetNuiFocus(false, false)
end)

RegisterNUICallback("getJobsConfig", function(_, cb)
    QBCore.Functions.TriggerCallback('jobcenter:getJobsConfig', function(jobs)
        cb({ jobs = jobs or {} })
    end)
end)

RegisterNUICallback("getPlayerApartments", function(_, cb)
    QBCore.Functions.TriggerCallback('jobcenter:getPlayerApartments', function(apartments)
        cb({ apartments = apartments or {} })
    end)
end)

RegisterNUICallback("getPlayerVehicles", function(_, cb)
    QBCore.Functions.TriggerCallback('jobcenter:getPlayerVehicles', function(vehicles)
        cb({ vehicles = vehicles or {} })
    end)
end)

RegisterNUICallback("assignJob", function(data, cb)
    if data.job then
        TriggerServerEvent("jobcenter:assignJob", data.job)
    end
    cb({})
end)

RegisterNUICallback("getPlayerData", function(_, cb)
    QBCore.Functions.TriggerCallback('jobcenter:getPlayerData', function(playerData)
        cb(playerData)
    end)
end)

RegisterNUICallback("solicitarDocumento", function(data, cb)
    if not data or not data.doc then return cb({}) end

    if data.doc == "idcard" then
        TriggerServerEvent("jobcenter:requestIDCard")
    elseif data.doc == "driver" then
        TriggerServerEvent("jobcenter:requestDriverLicense")
    elseif data.doc == "weapon" then
        TriggerServerEvent("jobcenter:requestWeaponLicense")
    end

    cb({})
end)
