print("Made By firedevil (Ryan | 404678244215029762 | https://discord.gg/ettP4TjbAb)")

repeat
    task.wait()
until game:IsLoaded()

loadstring(game:HttpGet("https://raw.githubusercontent.com/fdvll/pet-simulator-99/main/antiStaff.lua"))()

game.Players.LocalPlayer.PlayerScripts.Scripts.Core["Idle Tracking"].Enabled = false

if getconnections then
    for _, v in pairs(getconnections(game.Players.LocalPlayer.Idled)) do
        v:Disable()
    end
else
    game.Players.LocalPlayer.Idled:Connect(function()
        game:GetService("VirtualUser"):Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
        task.wait(1)
        game:GetService("VirtualUser"):Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
    end)
end

if not game:GetService("Workspace").__THINGS.__INSTANCE_CONTAINER.Active:FindFirstChild("Digsite") then
    game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = game:GetService("Workspace").__THINGS.Instances.Digsite.Teleports.Enter.CFrame

    local loaded = false
    local detectLoad = game:GetService("Workspace").__THINGS.__INSTANCE_CONTAINER.Active.ChildAdded:Connect(function(child)
        if child.Name == "Digsite" then
            loaded = true
        end
    end)

    repeat
        task.wait()
    until loaded

    detectLoad:Disconnect()
    task.wait(1)
end

pcall(function()
    for _, v in pairs(game:GetService("Workspace"):FindFirstChild("__THINGS"):GetChildren()) do
        if table.find({"ShinyRelics", "Ornaments", "Instances", "Ski Chairs"}, v.Name) then
            v:Destroy()
        end
    end

    for _, v in pairs(game:GetService("Workspace"):FindFirstChild("__THINGS").__INSTANCE_CONTAINER.Active.Digsite:GetChildren()) do
        if string.find(v.Name, "hill") or string.find(v.Name, "Flower") or string.find(v.Name, "rock") or string.find(v.Name, "Meshes") or string.find(v.Name, "Sign") or string.find(v.Name, "Wood") or v.Name == "Model" then
            v:Destroy()
        end
    end

    game:GetService("Workspace"):FindFirstChild("__THINGS").__INSTANCE_CONTAINER.Active.Digsite:WaitForChild("Important").Merchant:Destroy()
    game:GetService("Workspace"):WaitForChild("ALWAYS_RENDERING"):Destroy()

    loadstring(game:HttpGet("https://raw.githubusercontent.com/fdvll/pet-simulator-99/main/cpuReducer.lua"))()
end)

local function findBlock()
    local dist = 9999
    local block = nil
    for _, v in pairs(game:GetService("Workspace").__THINGS.__INSTANCE_CONTAINER.Active.Digsite.Important.ActiveBlocks:GetChildren()) do
        if v:IsA("BasePart") then
            local magnitude = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v.Position).Magnitude
            if magnitude <= dist then
                dist = magnitude
                block = v
            end
        end
    end
    return block
end

local function findChest()
    local dist = 9999
    local chest = nil
    for _, v in pairs(game:GetService("Workspace").__THINGS.__INSTANCE_CONTAINER.Active.Digsite.Important.ActiveChests:GetChildren()) do
        if v:IsA("Model") then
            local magnitude = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v.Top.Position).Magnitude
            if magnitude <= dist then
                dist = magnitude
                chest = v
            end
        end
    end
    return chest
end


local noChestCount = os.clock()

getgenv().autoDigsite = true
while getgenv().autoDigsite do
    local chest = findChest()
    local block = findBlock()

    if not chest then
        if (os.clock() - noChestCount > 20) then
            loadstring(game:HttpGet("https://raw.githubusercontent.com/fdvll/pet-simulator-99/main/serverhop.lua"))()
        end
    else
        noChestCount = os.clock()
    end

    if chest then
        game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = chest.Top.CFrame
        game:GetService("ReplicatedStorage").Network:WaitForChild("Instancing_FireCustomFromClient"):FireServer("Digsite", "DigChest", chest:GetAttribute('Coord'))
    elseif block then
        game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = block.CFrame
        game:GetService("ReplicatedStorage").Network:WaitForChild("Instancing_FireCustomFromClient"):FireServer("Digsite", "DigBlock", block:GetAttribute('Coord'))
    end
    task.wait()
end
