repeat
    task.wait(1)
until game:IsLoaded()

repeat
    task.wait(1)
until game.PlaceId ~= nil

repeat
    task.wait(1)
until game:GetService("Players").LocalPlayer and game:GetService("Players").LocalPlayer.Character and game:GetService("Players").LocalPlayer.Character.HumanoidRootPart


if game.PlaceId == 8737899170 then
    repeat
        task.wait(1)
    until #game:GetService("Workspace").Map:GetChildren() == 100
elseif game.PlaceId == 16498369169 then
    repeat
        task.wait(1)
    until #game:GetService("Workspace").Map2:GetChildren() == 51
end


repeat
    task.wait(1)
until game:GetService("Workspace").__THINGS and game:GetService("Workspace").__DEBRIS

task.wait(2)

print("[CLIENT] Loaded Game")
