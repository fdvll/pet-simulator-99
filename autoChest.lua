local BigChests = {
    [1] = "Beach",
    [2] = "Underworld",
    [3] = "No Path Forest",
    [4] = "Heaven Gates"
}

repeat
    task.wait()
until game:IsLoaded()

loadstring(game:HttpGet("https://raw.githubusercontent.com/fdvll/pet-simulator-99/main/antiStaff.lua"))()

task.wait(getgenv().autoChestConfig.START_DELAY)

local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Library = ReplicatedStorage:WaitForChild("Library")
local Client = Library:WaitForChild("Client")
local LocalPlayer = game:GetService("Players").LocalPlayer

local zonePath

local function trim(string)
    if not string then
        return false
    end
    return string:match("^%s*(.-)%s*$")
end

local function split(input, separator)
    if separator == nil then
        separator = "%s"
    end
    local parts = {}
    for str in string.gmatch(input, "([^" .. separator .. "]+)") do
        table.insert(parts, str)
    end
    return parts
end

local function teleportToZone(selectedZone)
    local teleported = false

    while not teleported do
        for _, v in pairs(Workspace.Map:GetChildren()) do
            local zoneName = trim(split(v.Name, "|")[2])
            if zoneName and zoneName == selectedZone then
                LocalPlayer.Character.HumanoidRootPart.CFrame = Workspace.Map[v.Name].PERSISTENT.Teleport.CFrame
                teleported = true
                break
            end
        end
        task.wait()
    end
end

local function waitForLoad(zone)
    for _, v in pairs(Workspace.Map:GetChildren()) do
        local zoneName = trim(split(v.Name, "|")[2])
        if zoneName and zoneName == zone then
            zonePath = Workspace.Map[v.Name]
            break
        end
    end

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

    local function getBreakZonesAmount()
        local counter = 0
        for _ in pairs(zonePath.INTERACT.BREAK_ZONES:GetChildren()) do
            counter = counter + 1
        end
        return counter
    end

    if getBreakZonesAmount() < 2 then
        local loaded = false
        local detectLoad = zonePath.INTERACT.BREAK_ZONES.ChildAdded:Connect(function(_)
            if getBreakZonesAmount() == 2 then
                loaded = true
            end
        end)
        repeat
            task.wait()
        until loaded
        detectLoad:Disconnect()
    end
end


local function breakChest(zone)

    local chest
    while not chest do
        for v in require(Client.BreakableCmds).AllByZoneAndClass(zone, "Chest") do
            chest = v
            break
        end
        task.wait()
    end

    if getgenv().autoChestConfig.SEND_PETS then
        local args = {
            [1] = {

            }
        }

        for petId, _ in pairs(require(Client.Save).Get(LocalPlayer).EquippedPets) do
            args[1][petId] = {
                ["targetValue"] = chest,
                ["targetType"] = "Player"
            }
        end

        ReplicatedStorage.Network.Pets_SetTargetBulk:FireServer(unpack(args))
    end

    local brokeChest = false
    local breakableRemovedService = Workspace:WaitForChild("__THINGS").Breakables.ChildRemoved:Connect(function(breakable)
        if breakable.Name == chest then
            brokeChest = true
            print("Broke chest")
        end
    end)

    LocalPlayer.Character.HumanoidRootPart.CFrame = zonePath.INTERACT.BREAKABLE_SPAWNS.Boss.CFrame

    repeat
        local args = {
            [1] = chest
        }

        game:GetService("ReplicatedStorage").Network.Breakables_PlayerDealDamage:FireServer(unpack(args))
        task.wait()
    until brokeChest

    breakableRemovedService:Disconnect()
end

local function isWithinRange(part)
    return (LocalPlayer.Character.HumanoidRootPart.CFrame.Position - part.CFrame.Position).magnitude <= 300
end

local function autoChest()
    local sortedKeys = {}
    for key in pairs(BigChests) do
        table.insert(sortedKeys, key)
    end
    table.sort(sortedKeys)

    for _, key in ipairs(sortedKeys) do
        local zoneName = BigChests[key]

        print("Starting " .. zoneName)

        teleportToZone(zoneName)
        waitForLoad(zoneName)

        local timerFound = false

        while not timerFound do
            for _, v in pairs(game:GetService("Workspace").__DEBRIS:GetChildren()) do
                local timer
                local isTimer, _ = pcall(function()
                    timer = v.ChestTimer.Timer.Text
                end)

                if v.Name == "host" and isTimer and isWithinRange(v)then

                    timerFound = true

                    if timer == "00:00" then
                        print(zoneName .. " chest is available")
                        breakChest(zoneName)
                    else
                        print(zoneName .. " chest is not available " .. timer)
                    end

                    break
                end
            end
            task.wait(getgenv().autoChestConfig.TIMER_SEARCH_DELAY)
        end

        warn("Finished " .. zoneName)

        if _G.STAFF_DETECTED then
            return
        end

        task.wait(getgenv().autoChestConfig.CHEST_BREAK_DELAY)
    end
end

require(Library.Client.PlayerPet).CalculateSpeedMultiplier = function()
    return 200
end

while getgenv().autoChest do
    local originalPosition = LocalPlayer.Character.HumanoidRootPart.CFrame

    autoChest()

    if _G.STAFF_DETECTED then
        getgenv().autoChest = false
        break
    end

    if not getgenv().autoChestConfig.SERVER_HOP then
        LocalPlayer.Character.HumanoidRootPart.CFrame = originalPosition
        print("Waiting 10 minutes for chests to respawn")
        task.wait(600)
    else
        print("Server hopping in " .. getgenv().autoChestConfig.SERVER_HOP_DELAY .. " seconds")
        task.wait(getgenv().autoChestConfig.SERVER_HOP_DELAY)

        loadstring(game:HttpGet("https://raw.githubusercontent.com/fdvll/pet-simulator-99/main/serverhop.lua"))()
    end
end
