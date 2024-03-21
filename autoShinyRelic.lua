local relics = {}
for i,v in pairs(game:GetService("ReplicatedStorage").Network.Relics_Request:InvokeServer()) do
    relics[i] = v
end

local totalRelics = #relics

local save = require(game:GetService("ReplicatedStorage"):WaitForChild("Library")).Save.Get()
for _, collectedRelic in pairs(save.ShinyRelics) do
    relics[collectedRelic] = nil
end

if game:GetService("Workspace"):FindFirstChild("Map") then
    print("Filtering all relics in World 1")
    for i = 86, totalRelics do
        relics[i] = nil
    end
else
    print("Filtering all relics in World 2")
    for i = 1, 85 do
        relics[i] = nil
    end
end


local originalPosition = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame

for i, v in pairs(relics) do
    if relics[i] == nil then
        continue
    elseif v.ParentType == 1 then
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.Position
        while not game:GetService("ReplicatedStorage").Network.Relic_Found:InvokeServer(i) do
            task.wait()
        end
        print("Found relic: " .. tostring(i))
    elseif v.ParentType == 2 then

        local instanceTeleports = game:GetService("Workspace").__THINGS.Instances:FindFirstChild(v.ParentId).Teleports
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = instanceTeleports.Enter.CFrame

        repeat
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = instanceTeleports.Enter.CFrame
            task.wait()
        until game:GetService("Workspace").__THINGS.__INSTANCE_CONTAINER.Active:FindFirstChild(v.ParentId)

        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.Position

        while not game:GetService("ReplicatedStorage").Network.Relic_Found:InvokeServer(i) do
            task.wait()
        end

        print("Found relic " .. tostring(i) .. " in instance " .. tostring(v.ParentId))

        repeat
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = instanceTeleports.Leave.CFrame
            task.wait()
        until not game:GetService("Workspace").__THINGS.__INSTANCE_CONTAINER.Active:FindFirstChild(v.ParentId)
    end
end
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = originalPosition
print("Done")
