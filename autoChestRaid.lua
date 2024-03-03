local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Things = Workspace:WaitForChild("__THINGS")
local Breakables = Things:WaitForChild("Breakables")
local LocalPlayer = Players.LocalPlayer

if not Things.__INSTANCE_CONTAINER.Active:FindFirstChild("ChestRaid") then
    local loaded = false
    local loadEvent = Things.__INSTANCE_CONTAINER.Active.ChildAdded:Connect(function(child)
        if child.Name == "ChestRaid" then
            loaded = true
        end
    end)
    LocalPlayer.Character.HumanoidRootPart.CFrame = Things.Instances:FindFirstChild("ChestRaid").Teleports.Enter.CFrame

    repeat
        task.wait()
    until loaded

    loadEvent:Disconnect()
end

Things:FindFirstChild("Lootbags").ChildAdded:Connect(function(lootbag)
    task.wait()
    if lootbag then
        ReplicatedStorage:WaitForChild("Network"):WaitForChild("Lootbags_Claim"):FireServer(unpack( { [1] = { [1] = lootbag.Name, }, } ))
        lootbag:Destroy()
    end
end)

for _, v in pairs(Breakables:GetChildren()) do
    if v:GetAttribute("ParentID") ~= "ChestRaid" then
        v:Destroy()
    end
end

if Breakables:FindFirstChild("Highlight") then
    Breakables:FindFirstChild("Highlight"):Destroy()
end

repeat
    task.wait()
until #Breakables:GetChildren() > 0

require(ReplicatedStorage:WaitForChild("Library"):WaitForChild("Client").PlayerPet).CalculateSpeedMultiplier = function(...)
    return 200
end

task.spawn(function()
    task.wait(601)
    LocalPlayer.Character.HumanoidRootPart.Anchored = false
end)

LocalPlayer.Character.HumanoidRootPart.Anchored = true
while Things.__INSTANCE_CONTAINER.Active:FindFirstChild("ChestRaid") do
    while #Breakables:GetChildren() == 0 do
        task.wait()
    end

    local closestBreakable
    local closestDist = 999
    for _, v in pairs(Breakables:GetChildren()) do
        if v then
            if v:GetAttribute("ParentID") == "ChestRaid" then
                local dist = (LocalPlayer.Character.HumanoidRootPart.Position - v.Top.Position).Magnitude
                if dist < closestDist then
                    closestBreakable = {
                        ["CFrame"] = v.Bottom.CFrame,
                        ["Name"] = v.Name
                    }
                    closestDist = dist
                end
            end
        end
    end
    LocalPlayer.Character.HumanoidRootPart.CFrame = closestBreakable.CFrame

    repeat
        ReplicatedStorage.Network.Breakables_PlayerDealDamage:FireServer(closestBreakable.Name)
        task.wait()
    until not Breakables:FindFirstChild(closestBreakable.Name)
end

LocalPlayer.Character.HumanoidRootPart.Anchored = false
