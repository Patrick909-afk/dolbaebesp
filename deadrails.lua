local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- GUI
local main = Instance.new("ScreenGui")
main.Parent = LocalPlayer:WaitForChild("PlayerGui")
main.Name = "PatrickCheat"
main.ResetOnSpawn = false

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 100)
frame.Position = UDim2.new(0.1, 0, 0.4, 0)
frame.BackgroundColor3 = Color3.fromRGB(0,255,0)
frame.BackgroundTransparency = 0.3
frame.Active = true
frame.Draggable = true
frame.Parent = main

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 20)
title.Text = "☣ Patrick NoClip & ESP"
title.TextColor3 = Color3.fromRGB(0,255,0)
title.BackgroundTransparency = 1
title.Parent = frame

local btnNoClip = Instance.new("TextButton")
btnNoClip.Size = UDim2.new(1, -10, 0, 25)
btnNoClip.Position = UDim2.new(0,5,0,25)
btnNoClip.Text = "Toggle NoClip"
btnNoClip.BackgroundColor3 = Color3.fromRGB(0,100,0)
btnNoClip.TextColor3 = Color3.new(1,1,1)
btnNoClip.Parent = frame

local btnKillAura = Instance.new("TextButton")
btnKillAura.Size = UDim2.new(1, -10, 0, 25)
btnKillAura.Position = UDim2.new(0,5,0,55)
btnKillAura.Text = "Kill Aura"
btnKillAura.BackgroundColor3 = Color3.fromRGB(0,100,0)
btnKillAura.TextColor3 = Color3.new(1,1,1)
btnKillAura.Parent = frame

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 20, 0, 20)
closeBtn.Position = UDim2.new(1, -20, 0, 0)
closeBtn.Text = "X"
closeBtn.BackgroundColor3 = Color3.fromRGB(255,0,0)
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.Parent = frame

-- 📦 Logic

-- 🚂 Smart ESP trains
RunService.RenderStepped:Connect(function()
    for _,v in pairs(workspace:GetChildren()) do
        if v:IsA("Model") and not v:FindFirstChild("PatrickESP") then
            local part = v.PrimaryPart or v:FindFirstChildWhichIsA("BasePart")
            if part then
                local size = part.Size
                local speed = part.AssemblyLinearVelocity.Magnitude
                if size.Magnitude > 20 and speed > 10 then
                    local esp = Instance.new("BillboardGui", v)
                    esp.Name = "PatrickESP"
                    esp.Adornee = part
                    esp.Size = UDim2.new(0,120,0,50)
                    esp.StudsOffset = Vector3.new(0, size.Y+2, 0)
                    esp.AlwaysOnTop = true

                    local text = Instance.new("TextLabel", esp)
                    text.Size = UDim2.new(1,0,1,0)
                    text.Text = "🚂 Train"
                    text.TextColor3 = Color3.fromRGB(0,255,0)
                    text.BackgroundTransparency = 1
                    text.TextScaled = true
                end
            end
        end
    end
end)

-- 🧱 NoClip
local noclip = false
btnNoClip.MouseButton1Click:Connect(function()
    noclip = not noclip
end)

RunService.Stepped:Connect(function()
    if noclip and LocalPlayer.Character then
        for _,v in pairs(LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") and v.CanCollide then
                v.CanCollide = false
            end
        end
    end
end)

-- ⚔️ Kill Aura
btnKillAura.MouseButton1Click:Connect(function()
    local char = LocalPlayer.Character
    if not char then return end
    local tool = char:FindFirstChildOfClass("Tool")
    if not tool then return end

    for _,mob in pairs(workspace:GetDescendants()) do
        if mob:IsA("Model") and mob:FindFirstChildOfClass("Humanoid") and not Players:GetPlayerFromCharacter(mob) then
            mob:FindFirstChildOfClass("Humanoid").Health = 0
        end
    end
end)

-- Закрыть GUI
closeBtn.MouseButton1Click:Connect(function()
    main:Destroy()
end)

game:GetService("StarterGui"):SetCore("SendNotification",{
    Title="Patrick Cheat";
    Text="Loaded successfully!";
})
