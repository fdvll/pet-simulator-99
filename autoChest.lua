local BigChests = {
    [1] = "Beach",
    [2] = "Underworld",
    [3] = "No Path Forest",
    [4] = "Heaven Gates"
}

repeat
    task.wait()
until game:IsLoaded()

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
                LocalPlayer.Character.HumanoidRootPart.CFrame = game:GetService("Workspace").Map[v.Name].PERSISTENT.Teleport.CFrame
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
            zonePath = game:GetService("Workspace").Map[v.Name]
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
        local detectLoad = zonePath.INTERACT.BREAK_ZONES.ChildAdded:Connect(function(child)
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

    game:GetService("ReplicatedStorage").Network.Pets_SetTargetBulk:FireServer(unpack(args))

    local brokeChest = false
    local breakableRemovedService = Workspace:WaitForChild("__THINGS").Breakables.ChildRemoved:Connect(function(breakable)
        if breakable.Name == chest then
            brokeChest = true
            print("Broke chest")
        end
    end)

    LocalPlayer.Character.HumanoidRootPart.CFrame = zonePath.INTERACT.BREAKABLE_SPAWNS.Boss.CFrame

    repeat
        task.wait()
    until brokeChest

    breakableRemovedService:Disconnect()
end



require(Library.Client.PlayerPet).CalculateSpeedMultiplier = function()
    return 200
end

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
    task.wait()

    task.wait(2)
    for _, v in pairs(game:GetService("Workspace").__DEBRIS:GetChildren()) do

        if v.Name == "host" then
            local timer

            pcall(function()
                timer = v.ChestTimer.Timer.Text
            end)

            if timer ~= nil then
                if timer == "00:00" or timer == "09:59" then
                    print(zoneName .. " chest is available")
                    breakChest(zoneName)
                else
                    print(zoneName .. " chest is not available " .. timer)
                end
                v:Destroy()
                break
            end
        end
    end
    warn("Finished " .. zoneName)
    task.wait(getgenv().autoChestConfig.CHEST_BREAK_DELAY)
end

if getgenv().autoChestConfig.SERVER_HOP then
    print("Server hopping in " .. tostring(getgenv().autoChestConfig.SERVER_HOP_DELAY) .. " seconds")
    task.wait(getgenv().autoChestConfig.SERVER_HOP_DELAY)

    local PlaceID = game.PlaceId
    local AllIDs = {}
    local foundAnything = ""
    local actualHour = os.date("!*t").hour
    local function tp()
        local Site;
        if foundAnything == "" then
            Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/8737899170/servers/Public?sortOrder=Asc&limit=100'))
        else
            Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/8737899170/servers/Public?sortOrder=Asc&limit=100&cursor=' .. foundAnything))
        end
        local ID = ""
        if Site.nextPageCursor and Site.nextPageCursor ~= "null" and Site.nextPageCursor ~= nil then
            foundAnything = Site.nextPageCursor
        end
        local num = 0;
        for i,v in pairs(Site.data) do
            local Possible = true
            ID = tostring(v.id)
            if tonumber(v.maxPlayers) > tonumber(v.playing) then
                for _,Existing in pairs(AllIDs) do
                    if num ~= 0 then
                        if ID == tostring(Existing) then
                            Possible = false
                        end
                    else
                        if tonumber(actualHour) ~= tonumber(Existing) then
                            pcall(function()
                                AllIDs = {}
                                table.insert(AllIDs, actualHour)
                            end)
                        end
                    end
                    num = num + 1
                end
                if Possible == true then
                    table.insert(AllIDs, ID)
                    task.wait()
                    pcall(function()
                        task.wait()
                        game:GetService("TeleportService"):TeleportToPlaceInstance(PlaceID, ID, game.Players.LocalPlayer)
                    end)
                    task.wait(4)
                end
            end
        end
    end

    while task.wait() do
        pcall(function()
            tp()
            if foundAnything ~= "" then
                tp()
            end
        end)
    end
end
