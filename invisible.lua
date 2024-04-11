local Player = game:GetService("Players").LocalPlayer
local Workspace = game:GetService("Workspace")
local RealCharacter = Player.Character or Player.CharacterAdded:Wait()

RealCharacter.Archivable = true
local FakeCharacter = RealCharacter:Clone()
local Part
Part = Instance.new("Part", Workspace)
Part.Anchored = true
Part.Size = Vector3.new(200, 1, 200)
Part.CFrame = CFrame.new(Random.new():NextInteger(-9999, 9999), -9999, Random.new():NextInteger(-9999, 9999))
Part.CanCollide = true
FakeCharacter.Parent = Workspace
FakeCharacter.HumanoidRootPart.CFrame = Part.CFrame * CFrame.new(0, 5, 0)

for _, v in pairs(RealCharacter:GetChildren()) do
    if v:IsA("LocalScript") then
        local clone = v:Clone()
        clone.Disabled = true
        clone.Parent = FakeCharacter
    end
end

for _, v in pairs(FakeCharacter:GetDescendants()) do
    if v:IsA("BasePart") then
        v.Transparency = 0.7
    end
end

local function RealCharacterDied()
    RealCharacter:Destroy()
    RealCharacter = Player.Character
    FakeCharacter:Destroy()
    Workspace.CurrentCamera.CameraSubject = RealCharacter.Humanoid

    RealCharacter.Archivable = true
    FakeCharacter = RealCharacter:Clone()
    Part:Destroy()
    Part = Instance.new("Part", Workspace)
    Part.Anchored = true
    Part.Size = Vector3.new(200, 1, 200)
    Part.CFrame = CFrame.new(Random.new():NextInteger(-9999, 9999), 9999, Random.new():NextInteger(-9999, 9999))
    Part.CanCollide = true
    FakeCharacter.Parent = Workspace
    FakeCharacter.HumanoidRootPart.CFrame = Part.CFrame * CFrame.new(0, 5, 0)

    for _, v in pairs(RealCharacter:GetChildren()) do
        if v:IsA("LocalScript") then
            local clone = v:Clone()
            clone.Disabled = true
            clone.Parent = FakeCharacter
        end
    end

    for _, v in pairs(FakeCharacter:GetDescendants()) do
        if v:IsA("BasePart") then
            v.Transparency = 0.7
        end
    end

    RealCharacter.Humanoid.Died:Connect(function()
        RealCharacter:Destroy()
        FakeCharacter:Destroy()
    end)

    Player.CharacterAppearanceLoaded:Connect(RealCharacterDied)
end

RealCharacter.Humanoid.Died:Connect(function()
    RealCharacter:Destroy()
    FakeCharacter:Destroy()
end)

Player.CharacterAppearanceLoaded:Connect(RealCharacterDied)

local PseudoAnchor
game:GetService "RunService".RenderStepped:Connect(function()
    if PseudoAnchor ~= nil then
        PseudoAnchor.CFrame = Part.CFrame * CFrame.new(0, 5, 0)
    end
end)

PseudoAnchor = FakeCharacter.HumanoidRootPart

local StoredCF = RealCharacter.HumanoidRootPart.CFrame
RealCharacter.HumanoidRootPart.CFrame = FakeCharacter.HumanoidRootPart.CFrame
FakeCharacter.HumanoidRootPart.CFrame = StoredCF
RealCharacter.Humanoid:UnequipTools()
Player.Character = FakeCharacter
Workspace.CurrentCamera.CameraSubject = FakeCharacter.Humanoid
PseudoAnchor = RealCharacter.HumanoidRootPart
for _, v in pairs(FakeCharacter:GetChildren()) do
    if v:IsA("LocalScript") then
        v.Disabled = false
    end
end
