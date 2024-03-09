print("Made By firedevil (Ryan | 404678244215029762 | https://discord.gg/ettP4TjbAb)")

loadstring(game:HttpGet("https://raw.githubusercontent.com/fdvll/pet-simulator-99/main/waitForGameLoad.lua"))()
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

if not game:GetService("Workspace").__THINGS.__INSTANCE_CONTAINER.Active:FindFirstChild("AdvancedFishing") then
    game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = game:GetService("Workspace").__THINGS.Instances.AdvancedFishing.Teleports.Enter.CFrame

    local loaded = false
    local detectLoad = game:GetService("Workspace").__THINGS.__INSTANCE_CONTAINER.Active.ChildAdded:Connect(function(child)
        if child.Name == "AdvancedFishing" then
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

    for _, v in pairs(game:GetService("Workspace"):FindFirstChild("__THINGS").__INSTANCE_CONTAINER.Active.AdvancedFishing:GetChildren()) do
        if string.find(v.Name, "Model") or string.find(v.Name, "Water") or string.find(v.Name, "Debris") or string.find(v.Name, "Interactable") then
            v:Destroy()
        end

        if v.Name == "Map" then
            for _, v in pairs(v:GetChildren()) do
                if v.Name ~= "Union" then
                    v:Destroy()
                end
            end
        end
    end

    game:GetService("Workspace"):WaitForChild("ALWAYS_RENDERING"):Destroy()
end)

loadstring(game:HttpGet("https://raw.githubusercontent.com/fdvll/pet-simulator-99/main/cpuReducer.lua"))()

for _, v in pairs(game.Players:GetChildren()) do
    for _, v2 in pairs(v.Character:GetDescendants()) do
        if v2:IsA("BasePart") or v2:IsA("Decal") then
            v2.Transparency = 1
        end
    end
end

game.Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        for _, v in pairs(character:GetDescendants()) do
            if v:IsA("BasePart") or v:IsA("Decal") then
                v.Transparency = 1
            end
        end
    end)
end)


for _, v in pairs(game:GetDescendants()) do
	if v:IsA("Part") or v:IsA("BasePart") then
		v.Transparency = 1
	end
end

for i,v in pairs(game.Players.LocalPlayer.PlayerGui:GetChildren()) do
    if v:IsA("ScreenGui") then
        v.Enabled = false
    end
end

for i, v in pairs(game:GetService("StarterGui"):GetChildren()) do
    if v:IsA("ScreenGui") then
        v.Enabled = false
    end
end

for i, v in pairs(game:GetService("CoreGui"):GetChildren()) do
    if v:IsA("ScreenGui") then
        v.Enabled = false
    end
end

getgenv().autoFishing = true
while getgenv().autoFishing do
    local castVector = Vector3.new(1403.54736328125 + Random.new():NextInteger(0, 20), 61.62470245361328, -4472.0439453125 + Random.new():NextInteger(0, 20))

    game:GetService("ReplicatedStorage").Network.Instancing_FireCustomFromClient:FireServer("AdvancedFishing", "RequestCast", castVector)

    local bobbers = game:GetService("Workspace").__THINGS.__INSTANCE_CONTAINER.Active.AdvancedFishing.Bobbers
    bobbers:ClearAllChildren()

    local playerBobber
    local foundBobber = false

    while not foundBobber do
        for _, v in pairs(bobbers:GetChildren()) do
            if v:FindFirstChild("Bobber") then
                if v.Bobber.CFrame.X == castVector.X and v.Bobber.CFrame.Z == castVector.Z then
                    foundBobber = true
                    playerBobber = v.Bobber
                    break
                end
            end
        end
        task.wait()
    end

    local previousPos
    while true do
        local bp = playerBobber.CFrame.Y
        if bp == previousPos then
            break
        end
        previousPos = bp
        task.wait()
    end

    local bobberPos = playerBobber.CFrame.Y
    while playerBobber.CFrame.Y >= bobberPos do
        task.wait()
    end

    game:GetService("ReplicatedStorage").Network.Instancing_FireCustomFromClient:FireServer("AdvancedFishing", "RequestReel")

    while game.Players.LocalPlayer.Character.Model.Rod:FindFirstChild("FishingLine") do
        game:GetService("ReplicatedStorage").Network.Instancing_InvokeCustomFromClient:InvokeServer("AdvancedFishing", "Clicked")
    end
end
