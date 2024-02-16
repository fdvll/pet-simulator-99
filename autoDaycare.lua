repeat
    task.wait()
until game:IsLoaded()

task.wait(getgenv().autoDaycareConfig.START_DELAY)


local Library = game.ReplicatedStorage:WaitForChild('Library')
local LocalPlayer = game:GetService("Players").LocalPlayer
local Workspace = game:GetService("Workspace")
local pets = require(Library).Save.Get().Inventory.Pet

local daycareModule = require(Library.Client.DaycareCmds)

if getgenv().autoDaycareConfig.PET_AMOUNT == "max" then
    getgenv().autoDaycareConfig.PET_AMOUNT = daycareModule.GetMaxSlots()
end

if getgenv().autoDaycareConfig.PET_TYPE == 0 then
    getgenv().autoDaycareConfig.PET_TYPE = nil
end

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

local function teleportToDaycare()

    local zonePath
    local teleported = false
    while not teleported do
        for _, v in pairs(Workspace.Map:GetChildren()) do
            local zoneName = trim(split(v.Name, "|")[2])
            if zoneName and zoneName == "Beach" then
                zonePath = game:GetService("Workspace").Map[v.Name]
                LocalPlayer.Character.HumanoidRootPart.CFrame = zonePath.PERSISTENT.Teleport.CFrame
                teleported = true
                break
            end
        end
        task.wait()
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

    LocalPlayer.Character.HumanoidRootPart.CFrame = zonePath.INTERACT.Machines.DaycareMachine.PadGlow.CFrame
end

local petId
for id, petData in pairs(pets) do
    if petData["id"] == getgenv().autoDaycareConfig.DAYCARE_PET then
        if tonumber(petData["pt"]) == getgenv().autoDaycareConfig.PET_TYPE then
            if getgenv().autoDaycareConfig.IS_SHINY then
                if petData["sh"] then
                    petId = id
                    break
                end
            else
                if not petData["sh"] then
                    petId = id
                    break
                end
            end
        else
            petId = id
        end
    end
end

if not petId then
    print("Pet not found")
else
    print("Found pet: " .. petId)
end


local function getActivePet()
    for i, _ in pairs(daycareModule.GetActive()) do
        return i
    end
end

local activePetId = getActivePet()

local daycareAvailable
if not activePetId then
    daycareAvailable = true
else
    daycareAvailable = false
end

local OGPos
local needClaim = false

if daycareModule.ComputeRemainingTime(activePetId) == 0 then
    needClaim = true
end

while getgenv().autoDaycare do
    if daycareAvailable then
        print("Daycare is available")

        OGPos = LocalPlayer.Character.HumanoidRootPart.CFrame
        teleportToDaycare()

        if needClaim then
            task.wait()
            game:GetService("ReplicatedStorage").Network:FindFirstChild("Daycare: Claim"):InvokeServer()
            print("Claimed pet from daycare")
            needClaim = false
        end

        task.wait()

        local args = {
            [1] = {
                [petId] = getgenv().autoDaycareConfig.PET_AMOUNT
            }
        }

        game:GetService("ReplicatedStorage").Network:FindFirstChild("Daycare: Enroll"):InvokeServer(unpack(args))

        print("put pet into daycare")

        LocalPlayer.Character.HumanoidRootPart.CFrame = OGPos

        task.wait(2.5)

        daycareAvailable = false
    else
        print("Daycare is not available, waiting for pets to be ready")

        activePetId = getActivePet()

        print("Waiting for current daycare pet: " .. tostring(activePetId))

        while daycareModule.ComputeRemainingTime(activePetId) > 0 and getgenv().autoDaycare do
            task.wait(1)
        end

        if not getgenv().autoDaycare then
            break
        end

        print("Daycare pet is ready")

        needClaim = true

        daycareAvailable = true
    end
end
