local WAITING = false

local function serverhop(player)
    local timeToWait = Random.new():NextInteger(30, 60)
    print("[ANTI-STAFF] BIG Games staff (" .. player.Name ..  ") is in server! Waiting for " .. tostring(timeToWait) .. " seconds before server hopping...")
    task.wait(timeToWait)

    local success, _ = pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/fdvll/pet-simulator-99/main/serverhop.lua"))()
    end)

    if not success then
        game.Players.LocalPlayer:Kick("[ANTI-STAFF] A BIG Games staff member joined and script was unable to server hop")
    end
end

for _, player in pairs(game.Players:GetPlayers()) do
    local success, _ = pcall(function()
        if player:IsInGroup(5060810) then
            WAITING = true
            serverhop(player)
        end
    end)
    if not success then
        print("[ANTI-STAFF] Error while checking player: " .. player.Name)
    end
end

print("[ANTI-STAFF] No staff member detected")

game.Players.PlayerAdded:Connect(function(player)
    if player:IsInGroup(5060810) and not WAITING then
        print("[ANTI-STAFF] Staff member joined, stopping all scripts")
        getgenv().autoBalloon = false
        getgenv().autoChest = false
        getgenv().autoFishing = false

        getgenv().STAFF_DETECTED = true
        game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = false

        local world
        local mapPath
        if game.PlaceId == 8737899170 then
            mapPath = game:GetService("Workspace").Map
            world = "World 1"
        elseif game.PlaceId == 16498369169 then
            mapPath = game:GetService("Workspace").Map2
            world = "World 2"
        end


        local _, zoneData

        if world == "World 1" then
            _, zoneData = require(game:GetService("ReplicatedStorage").Library.Util.ZonesUtil).GetZoneFromNumber(Random.new():NextInteger(40, 90))
        else
            _, zoneData = require(game:GetService("ReplicatedStorage").Library.Util.ZonesUtil).GetZoneFromNumber(Random.new():NextInteger(5, 20))
        end

        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = mapPath[tostring(zoneData["_script"])].PERSISTENT.Teleport.CFrame

        serverhop(player)
    end
end)
