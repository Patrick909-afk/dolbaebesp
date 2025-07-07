local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

------------------------------------------------------------
-- ESP поездов (маленький, зелёный)
------------------------------------------------------------
local function createTrainESP(train)
    if train:FindFirstChild("ESP") then return end
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESP"
    billboard.Size = UDim2.new(0,50,0,20)
    billboard.AlwaysOnTop = true
    billboard.Adornee = train
    billboard.Parent = train
    local text = Instance.new("TextLabel", billboard)
    text.BackgroundTransparency = 1
    text.Text = "🚂"
    text.TextColor3 = Color3.fromRGB(0,255,0)
    text.TextScaled = true
    text.Font = Enum.Font.SourceSansBold
end

local function scanForTrains()
    for _,v in ipairs(Workspace:GetDescendants()) do
        if v:IsA("BasePart") and (v.Name:lower():find("train") or v.Parent.Name:lower():find("train")) then
            createTrainESP(v)
        end
    end
end

scanForTrains()
Workspace.DescendantAdded:Connect(function(v)
    if v:IsA("BasePart") and (v.Name:lower():find("train") or v.Parent.Name:lower():find("train")) then
        createTrainESP(v)
    end
end)

------------------------------------------------------------
-- Patrick NoClip GUI
------------------------------------------------------------
local screen = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
screen.Name = "PatrickNoClip"
screen.ResetOnSpawn = false

local frame = Instance.new("Frame", screen)
frame.Size = UDim2.new(0,200,0,80)
frame.Position = UDim2.new(0.05,0,0.4,0)
frame.BackgroundColor3 = Color3.fromRGB(0,255,0)
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,20)
title.Text = "Patrick NoClip"
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(0,0,0)

local toggle = Instance.new("TextButton", frame)
toggle.Size = UDim2.new(0.4,0,0,30)
toggle.Position = UDim2.new(0,5,0,25)
toggle.Text = "OFF"
toggle.BackgroundColor3 = Color3.fromRGB(50,200,50)
toggle.TextColor3 = Color3.new(0,0,0)

local close = Instance.new("TextButton", frame)
close.Size = UDim2.new(0.1,0,0,20)
close.Position = UDim2.new(0.9,0,0,0)
close.Text = "X"
close.TextColor3 = Color3.new(1,0,0)

local speedText = Instance.new("TextLabel", frame)
speedText.Size = UDim2.new(0.3,0,0,30)
speedText.Position = UDim2.new(0.45,0,0,25)
speedText.Text = "Speed: 2"
speedText.BackgroundTransparency = 1
speedText.TextColor3 = Color3.new(0,0,0)

local plus = Instance.new("TextButton", frame)
plus.Size = UDim2.new(0.1,0,0,30)
plus.Position = UDim2.new(0.8,0,0,25)
plus.Text = "+"
plus.TextColor3 = Color3.new(0,0,0)

local minus = Instance.new("TextButton", frame)
minus.Size = UDim2.new(0.1,0,0,30)
minus.Position = UDim2.new(0.7,0,0,25)
minus.Text = "-"
minus.TextColor3 = Color3.new(0,0,0)

local speed = 2
local enabled = false

toggle.MouseButton1Click:Connect(function()
    enabled = not enabled
    toggle.Text = enabled and "ON" or "OFF"
end)

plus.MouseButton1Click:Connect(function()
    speed = speed + 1
    speedText.Text = "Speed: "..speed
end)

minus.MouseButton1Click:Connect(function()
    if speed>1 then speed=speed-1 end
    speedText.Text = "Speed: "..speed
end)

close.MouseButton1Click:Connect(function()
    screen:Destroy()
end)

-- NoClip logic
RunService.Stepped:Connect(function()
    if enabled then
        for _,v in pairs(LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
        LocalPlayer.Character.Humanoid:Move(Vector3.new(0,0,0),false)
        LocalPlayer.Character.Humanoid.WalkSpeed = speed*10
    else
        LocalPlayer.Character.Humanoid.WalkSpeed = 16
    end
end)

------------------------------------------------------------
-- Бесконечные патроны и без перезарядки
------------------------------------------------------------
local function infiniteAmmo()
    while true do wait(1)
        for _,tool in ipairs(LocalPlayer.Backpack:GetChildren()) do
            if tool:FindFirstChild("Ammo") then tool.Ammo.Value=9999 end
            if tool:FindFirstChild("Clip") then tool.Clip.Value=9999 end
        end
        local char = LocalPlayer.Character
        if char then
            for _,tool in ipairs(char:GetChildren()) do
                if tool:FindFirstChild("Ammo") then tool.Ammo.Value=9999 end
                if tool:FindFirstChild("Clip") then tool.Clip.Value=9999 end
            end
        end
    end
end
spawn(infiniteAmmo)

------------------------------------------------------------
-- «Дюп» попытка (просто телепорт и detach, реальный дюп сервер проверяет)
------------------------------------------------------------
local function fakeDupe()
    local item = LocalPlayer.Backpack:FindFirstChildOfClass("Tool")
    if item then
        item.Parent = Workspace
        item.Handle.Position = LocalPlayer.Character.HumanoidRootPart.Position + Vector3.new(0,5,0)
        item.Parent = LocalPlayer.Backpack
    end
end
-- fakeDupe() вызови если хочешь попробовать

------------------------------------------------------------
-- Локальное бессмертие
------------------------------------------------------------
spawn(function()
    while true do wait(1)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.Health = LocalPlayer.Character.Humanoid.MaxHealth
        end
    end
end)
