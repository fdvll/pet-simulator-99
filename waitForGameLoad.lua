repeat
    task.wait()
until game:IsLoaded()

repeat
    task.wait()
until game.PlaceId ~= nil

repeat
    task.wait()
until game:GetService("Players").LocalPlayer and game:GetService("Players").LocalPlayer.Character and game:GetService("Players").LocalPlayer.Character.HumanoidRootPart


if game.PlaceId == 8737899170 then
    repeat
        task.wait()
    until #game:GetService("Workspace").Map:GetChildren() == 100
elseif game.PlaceId == 16498369169 then
    repeat
        task.wait()
    until #game:GetService("Workspace").Map2:GetChildren() == 26
end


repeat
    task.wait()
until game:GetService("Workspace").__THINGS and game:GetService("Workspace").__DEBRIS

print("[CLIENT] Loaded Game")
