local QBCore = exports['qb-core']:GetCoreObject()

function enumerateIdentifiers(source)
    local identifiers = {
        steam = "",
        ip = "",
        discord = "",
        fivem = "",
        license = "",
        xbl = "",
        live = ""
    }

    for i = 0, GetNumPlayerIdentifiers(source) - 1 do
        local id = GetPlayerIdentifier(source, i)
        
        for key, value in pairs(identifiers) do
            if string.match(id, key) then
                identifiers[key] = id
                break
            end
        end
    end

    return identifiers
end

local function exploitBan(id, reason)
    MySQL.insert('INSERT INTO bans (name, license, discord, ip, reason, expire, bannedby) VALUES (?, ?, ?, ?, ?, ?, ?)',
        {
            GetPlayerName(id),
            QBCore.Functions.GetIdentifier(id, 'license'),
            QBCore.Functions.GetIdentifier(id, 'discord'),
            QBCore.Functions.GetIdentifier(id, 'ip'),
            'NuiDevTool Abuse',
            2147483647,
            'Sisyphus Nui Denial'
        })
    TriggerEvent('qb-log:server:CreateLog', 'snd', 'Player Banned', 'red',
        string.format('%s was banned by %s for %s', GetPlayerName(id), 'GR_Nui_Denial', reason), true)
    DropPlayer(id, 'You were permanently banned by the server for: Attempting to use nuidevtools to exploit the server.')
end

RegisterServerEvent(GetCurrentResourceName())
AddEventHandler(GetCurrentResourceName(), function()
    local src = source
    local identifier = enumerateIdentifiers(source)
    local identifierLicense = identifier.license
    local identifierDiscord = identifier.discord
    if permType == 'license' then
        local isInPermissions = false
        
        for _, v in pairs(permissions) do
            if v == identifierLicense then
             isInPermissions = true
                break
            end
        end
        
        if not isInPermissions then
            exploitBan(src)
        end
    elseif permType == 'discord' then
        local isInPermissions = false
    
        for _, v in pairs(permissions) do
            if v == identifierDiscord then
             isInPermissions = true
                break
            end
        end
    
        if not isInPermissions then
            exploitBan(src)
        end
    else
        print("Invalid check method specified.")
    end
end)

