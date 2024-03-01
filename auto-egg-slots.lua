loadstring(game:HttpGet("https://raw.githubusercontent.com/fdvll/pet-simulator-99/main/waitForGameLoad.lua"))()

local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Library = ReplicatedStorage:WaitForChild("Library")
local LocalPlayer = game:GetService("Players").LocalPlayer

local diamondCost = {
    [1] = 150,
    [2] = 300,
    [3] = 600,
    [4] = 900,
    [5] = 1350,
    [6] = 1800,
    [7] = 2400,
    [8] = 3000,
    [9] = 3600,
    [10] = 4200,
    [13] = 10600,
    [15] = 13600,
    [17] = 16600,
    [19] = 20100,
    [21] = 23700,
    [23] = 27300,
    [25] = 30900,
    [27] = 34500,
    [29] = 38500,
    [31] = 42700,
    [34] = 72000,
    [35] = 26100,
    [38] = 85500,
    [41] = 96300,
    [44] = 107000,
    [47] = 117000,
    [50] = 128000,
    [53] = 750000,
    [56] = 1200000,
    [59] = 1650000,
    [62] = 2100000,
    [65] = 2550000,
    [68] = 3000000,
    [69] = 1100000,
    [70] = 1150000,
    [71] = 1200000,
    [72] = 1250000,
    [73] = 1250000,
    [74] = 1300000,
    [75] = 1350000,
}

local currentEggs = require(Library.Client.Save).Get().EggSlotsPurchased
local currentmaxPurchaseableEggs = require(Library.Client.RankCmds).GetMaxPurchasableEggSlots()
local originalPosition

local function teleportToEggMachine()
    local zonePath = Workspace.Map["8 | Backyard"]
    LocalPlayer.Character.HumanoidRootPart.CFrame = zonePath.PERSISTENT.Teleport.CFrame
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

    LocalPlayer.Character.HumanoidRootPart.CFrame = zonePath.INTERACT.Machines.EggSlotsMachine.PadGlow.CFrame
end

print("Starting auto egg slot purchase")
while getgenv().autoEgg do

    print("Waiting for enough gems")
    while require(Library.Client.CurrencyCmds).Get("Diamonds") < diamondCost[currentEggs + 1] do
        task.wait(getgenv().autoEggConfig.GEM_WAIT_DELAY)
    end

    if currentEggs < require(Library.Client.RankCmds).GetMaxPurchasableEggSlots() then
        originalPosition = LocalPlayer.Character.HumanoidRootPart.CFrame
        print("Buying slot " .. tostring(currentEggs + 1) .. " for " .. tostring(diamondCost[currentEggs + 1]) .. " diamonds")

        teleportToEggMachine()

        task.wait()

        local args = {
            [1] = currentEggs + 1
        }

        game:GetService("ReplicatedStorage").Network.EggHatchSlotsMachine_RequestPurchase:InvokeServer(unpack(args))
        currentEggs = currentEggs + 1

        print("Purchased egg slot " .. tostring(currentEggs + 1))
        LocalPlayer.Character.HumanoidRootPart.CFrame = originalPosition
    else
        print("Already have max amount of egg slots, waiting for rankup")
        while currentmaxPurchaseableEggs == require(Library.Client.RankCmds).GetMaxPurchasableEggSlots() do
            task.wait(getgenv().autoEggConfig.RANK_WAIT_DELAY)
        end
    end
end
