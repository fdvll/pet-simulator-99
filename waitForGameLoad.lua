repeat
    task.wait()
until game:IsLoaded()

repeat
    task.wait()
until game.PlaceId ~= nil

repeat
    task.wait()
until game:GetService("Players").LocalPlayer and game:GetService("Players").LocalPlayer.Character and game:GetService("Players").LocalPlayer.Character.HumanoidRootPart

repeat
    task.wait()
until game:GetService("Workspace"):FindFirstChild("Map") or game:GetService("Workspace"):FindFirstChild("Map2")

repeat
    task.wait()
until game:GetService("Workspace").__THINGS and game:GetService("Workspace").__DEBRIS

print("[CLIENT] Loaded Game")
