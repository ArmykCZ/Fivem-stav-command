local playerStav = {}

RegisterCommand("stav", function(source, args, rawCommand)
    local playerPed = PlayerPedId()
    local playerId = GetPlayerServerId(PlayerId())
    local text = table.concat(args, " ")

    -- Pokud hráč zadá příkaz bez textu nebo zadá stejný text jako naposledy, tag se odstraní
    if text == "" or playerStav[playerId] == text then
        playerStav[playerId] = nil
    else
        playerStav[playerId] = text
    end
end, false)

-- Hlavní smyčka pro vykreslení textu
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        for _, player in ipairs(GetActivePlayers()) do
            local playerPed = GetPlayerPed(player)
            local playerId = GetPlayerServerId(player)

            if playerStav[playerId] then
                local coords = GetEntityCoords(playerPed)
                DrawText3D(coords.x, coords.y, coords.z - 0.9, playerStav[playerId]) -- Umístění textu na břicho
            end
        end
    end
end)

-- Funkce pro vykreslení 3D textu
function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local p = GetGameplayCamCoords()
    local distance = #(vector3(p.x, p.y, p.z) - vector3(x, y, z))
    local scale = 1 / distance * 1.2
    local fov = (1 / GetGameplayCamFov()) * 100
    scale = scale * fov

    if onScreen then
        SetTextScale(0.0 * scale, 1 * scale)
        SetTextFont(4)
        SetTextProportional(true)
        SetTextColour(255, 255, 255, 215)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(1, 0, 0, 0, 255)
        SetTextDropShadow()
        SetTextOutline()
        SetTextCentre(true)
        BeginTextCommandDisplayText("STRING")
        AddTextComponentSubstringPlayerName(text)
        EndTextCommandDisplayText(_x, _y)
    end
end
