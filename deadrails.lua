local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

-------------------------
-- Patrick NoClip GUI
-------------------------
local gui = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
gui.Name = "PatrickNoClipGui"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 200, 0, 60)
frame.Position = UDim2.new(0.3, 0, 0.4, 0)
frame.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0.5, 0)
title.Text = "Patrick NoClip"
title.TextColor3 = Color3.fromRGB(0, 0, 0)
title.BackgroundTransparency = 1

local toggle = Instance.new("TextButton", frame)
toggle.Position = UDim2.new(0, 0, 0.5, 0)
toggle.Size = UDim2.new(0.5, 0, 0.5, 0)
toggle.Text = "ON"
toggle.BackgroundColor3 = Color3.fromRGB(0, 200, 0)

local close = Instance.new("TextButton", frame)
close.Position = UDim2.new(0.5, 0, 0.5, 0)
close.Size = UDim2.new(0.5, 0, 0.5, 0)
close.Text = "X"
close.BackgroundColor3 = Color3.fromRGB(255, 0, 0)

-------------------------
-- NoClip logic
-------------------------
local noclipEnabled = false
toggle.MouseButton1Click:Connect(function()
    noclipEnabled = not noclipEnabled
    toggle.Text = noclipEnabled and "ON" or "OFF"
end)

close.MouseButton1Click:Connect(function()
    gui.Enabled = false
end)

RunService.Stepped:Connect(function()
    if noclipEnabled and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
        -- Лёгкий «парящий эффект», чтобы не падал
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.Velocity = Vector3.new(0, 2, 0)
        end
    end
end)

-------------------------
-- ESP поездов (больше и сверху)
-------------------------
local function createESP(obj)
    if obj:FindFirstChild("PatrickESP") then return end
    local bill = Instance.new("BillboardGui", obj)
    bill.Name = "PatrickESP"
    bill.Size = UDim2.new(0, 80, 0, 40)
    bill.AlwaysOnTop = true
    bill.StudsOffset = Vector3.new(0, 8, 0)  -- выше модели
    local txt = Instance.new("TextLabel", bill)
    txt.BackgroundTransparency = 1
    txt.Text = "🚂"
    txt.TextColor3 = Color3.fromRGB(0, 255, 0)
    txt.TextScaled = true
    txt.Size = UDim2.new(1,0,1,0)
end

for _, v in pairs(Workspace:GetDescendants()) do
    if v:IsA("Model") and (v.Name:lower():find("train") or v.Name:lower():find("locomotive") or v.Name:lower():find("wagon")) then
        createESP(v)
    end
end

Workspace.DescendantAdded:Connect(function(v)
    if v:IsA("Model") and (v.Name:lower():find("train") or v.Name:lower():find("locomotive") or v.Name:lower():find("wagon")) then
        createESP(v)
    end
end)

-------------------------
-- Бессмертие от мобов (и быстрая подстройка)
-------------------------
local humanoid
RunService.RenderStepped:Connect(function()
    if LocalPlayer.Character then
        humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            -- Блокируем урон (если скрипты наносят TakeDamage)
            humanoid.Health = humanoid.MaxHealth
        end
    end
end)

-------------------------
-- Бесконечные патроны
-------------------------
RunService.RenderStepped:Connect(function()
    if LocalPlayer.Character then
        for _, tool in pairs(LocalPlayer.Character:GetChildren()) do
            if tool:IsA("Tool") then
                for _, v in pairs(tool:GetDescendants()) do
                    if v.Name:lower():find("ammo") or v.Name:lower():find("clip") then
                        if v:IsA("IntValue") or v:IsA("NumberValue") then
                            v.Value = 9999
                        end
                    end
                end
            end
        end
    end
end)
