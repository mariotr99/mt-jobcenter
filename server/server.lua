local QBCore = exports['qb-core']:GetCoreObject()
Config = Config or {}

QBCore.Functions.CreateCallback('jobcenter:getPlayerData', function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)
    if Player then
        local playerData = {
            charinfo = Player.PlayerData.charinfo,
            citizenid = Player.PlayerData.citizenid,
            money = {
                cash = Player.PlayerData.money["cash"],
                bank = Player.PlayerData.money["bank"]
            },
            job = {
                name = Player.PlayerData.job.name,
                label = Player.PlayerData.job.label,
                grade = Player.PlayerData.job.grade.name,
                gradelabel = Player.PlayerData.job.grade.name
            },
            licenses = Player.PlayerData.metadata.licences or {}
        }
        cb(playerData)
    else
        cb(nil)
    end
end)

QBCore.Functions.CreateCallback('jobcenter:getJobsConfig', function(source, cb)
    cb(Config.Jobs or {})
end)

QBCore.Functions.CreateCallback('jobcenter:getPlayerApartments', function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return cb({}) end

    local citizenid = Player.PlayerData.citizenid
    exports.oxmysql:execute('SELECT name, label FROM apartments WHERE citizenid = ?', { citizenid }, function(results)
        local apartments = {}
        for _, apt in pairs(results or {}) do
            table.insert(apartments, {
                name = apt.name,
                label = apt.label or apt.name,
                type = "Propietario"
            })
        end
        cb(apartments)
    end)
end)

QBCore.Functions.CreateCallback('jobcenter:getPlayerVehicles', function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return cb({}) end

    local citizenid = Player.PlayerData.citizenid
    exports.oxmysql:execute('SELECT * FROM player_vehicles WHERE citizenid = ?', { citizenid }, function(result)
        cb(result or {})
    end)
end)

RegisterNetEvent("jobcenter:assignJob", function(jobName)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player and jobName then
        Player.Functions.SetJob(jobName, 0)
        TriggerClientEvent('QBCore:Notify', src, "Has sido asignado al trabajo: " .. jobName, "success")
    end
end)

RegisterNetEvent("jobcenter:requestIDCard", function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    local idCardInfo = {
        citizenid = Player.PlayerData.citizenid,
        firstname = Player.PlayerData.charinfo.firstname,
        lastname = Player.PlayerData.charinfo.lastname,
        birthdate = Player.PlayerData.charinfo.birthdate,
        gender = Player.PlayerData.charinfo.gender,
        nationality = Player.PlayerData.charinfo.nationality
    }

    Player.Functions.AddItem("id_card", 1, false, idCardInfo)
    TriggerClientEvent('QBCore:Notify', src, "Se te ha entregado el DNI.", "success")
end)

RegisterNetEvent("jobcenter:requestDriverLicense", function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    local licenseInfo = {
        firstname = Player.PlayerData.charinfo.firstname,
        lastname = Player.PlayerData.charinfo.lastname,
        birthdate = Player.PlayerData.charinfo.birthdate,
        type = "Class C Driver License"
    }

    Player.Functions.AddItem("driver_license", 1, false, licenseInfo)
    TriggerClientEvent('QBCore:Notify', src, "Se te ha entregado la licencia de conducir.", "success")
end)


RegisterNetEvent("jobcenter:requestWeaponLicense", function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    local licenses = Player.PlayerData.metadata.licences or {}

    if licenses.weapon then
        local info = {
            firstname = Player.PlayerData.charinfo.firstname,
            lastname = Player.PlayerData.charinfo.lastname,
            birthdate = Player.PlayerData.charinfo.birthdate
        }

        Player.Functions.AddItem("weaponlicense", 1, false, info)
        TriggerClientEvent('QBCore:Notify', src, "Se te ha entregado la licencia de armas.", "success")
    else
        TriggerClientEvent('QBCore:Notify', src, "No estás autorizado para obtener una licencia de armas.", "error")
    end
end)
