repeat
    task.wait()
until game:IsLoaded()

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Workspace = game:GetService("Workspace")

local map
local PlaceId = game.PlaceId
if PlaceId == 8737899170 then
    map = Workspace.Map
elseif PlaceId == 16498369169 then
    map = Workspace.Map2
end

local unfinished = true
local currentZone

require(ReplicatedStorage.Library.Client.PlayerPet).CalculateSpeedMultiplier = function(...)
    return 200
end

local function teleportToMaxZone()
    local zoneName, maxZoneData = require(ReplicatedStorage.Library.Client.ZoneCmds).GetMaxOwnedZone()
    while currentZone == zoneName do
        zoneName, maxZoneData = require(ReplicatedStorage.Library.Client.ZoneCmds).GetMaxOwnedZone()
        task.wait()
    end
    currentZone = zoneName
    print("Teleporting to zone: " .. zoneName)

    local zonePath
    for _, v in pairs(map:GetChildren()) do
        if string.find(v.Name, tostring(maxZoneData.ZoneNumber) .. " | " .. zoneName) then
            zonePath = v
        end
    end
    LocalPlayer.Character.HumanoidRootPart.CFrame = zonePath.PERSISTENT.Teleport.CFrame + Vector3.new(0, 10, 0)
    task.wait()

    if not zonePath:FindFirstChild("INTERACT") then
        local loaded = false
        local detectLoad = zonePath.ChildAdded:Connect(function(child)
            if child.Name == "INTERACT" then
                loaded = true
            end
        end)

        repeat
            task.wait()
        until loaded

        detectLoad:Disconnect()
    end

    local dist = 999
    local closestBreakZone = nil
    for _, v in pairs(zonePath.INTERACT.BREAK_ZONES:GetChildren()) do
        local magnitude = (LocalPlayer.Character.HumanoidRootPart.Position - v.Position).Magnitude
        if magnitude <= dist then
            dist = magnitude
            closestBreakZone = v
        end
    end

    LocalPlayer.Character.HumanoidRootPart.CFrame = closestBreakZone.CFrame + Vector3.new(0, 10, 0)

    if maxZoneData.ZoneNumber >= getgenv().ZONE_TO_REACH then
        print("Reached selected zone")
        unfinished = false
    end
end

for _, lootbag in pairs(Workspace.__THINGS:FindFirstChild("Lootbags"):GetChildren()) do
    if lootbag then
        ReplicatedStorage.Network:WaitForChild("Lootbags_Claim"):FireServer(unpack( { [1] = { [1] = lootbag.Name, }, } ))
        lootbag:Destroy()
        task.wait()
    end
end

Workspace.__THINGS:FindFirstChild("Lootbags").ChildAdded:Connect(function(lootbag)
    task.wait()
    if lootbag then
        ReplicatedStorage.Network:WaitForChild("Lootbags_Claim"):FireServer(unpack( { [1] = { [1] = lootbag.Name, }, } ))
        lootbag:Destroy()
    end
end)

Workspace.__THINGS:FindFirstChild("Orbs").ChildAdded:Connect(function(orb)
    task.wait()
    if orb then
        ReplicatedStorage.Network:FindFirstChild("Orbs: Collect"):FireServer(unpack( { [1] = { [1] = tonumber(orb.Name), }, } ))
        orb:Destroy()
    end
end)

task.spawn(function()
    print("Starting zone purchase service")
    while unfinished do
        local nextZoneName, _ = require(game.ReplicatedStorage.Library.Client.ZoneCmds).GetNextZone()
        local success, _ = game:GetService("ReplicatedStorage").Network.Zones_RequestPurchase:InvokeServer(nextZoneName)
        if success then
            print("Successfully purchased " .. nextZoneName)
            teleportToMaxZone()
        end
        task.wait()
    end
end)

teleportToMaxZone()