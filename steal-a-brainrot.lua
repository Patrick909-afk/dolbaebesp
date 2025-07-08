local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

local AutoFling = false
local AntiFling = true
local MaxForce = 5000

-- GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "AutoFlingGUI"
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,180,0,125)
frame.Position = UDim2.new(0,100,0,100)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.Active = true
frame.Draggable = true
local uic = Instance.new("UICorner", frame)
uic.CornerRadius = UDim.new(0,8)

local btn = Instance.new("TextButton", frame)
btn.Size = UDim2.new(1,-20,0,22)
btn.Position = UDim2.new(0,10,0,10)
btn.Text = "Auto Fling: OFF"
btn.BackgroundColor3 = Color3.fromRGB(80,160,80)
btn.TextColor3 = Color3.new(1,1,1)
btn.Font = Enum.Font.Gotham
btn.TextSize = 13

local anti = Instance.new("TextButton", frame)
anti.Size = UDim2.new(1,-20,0,22)
anti.Position = UDim2.new(0,10,0,37)
anti.Text = "AntiFling: ON"
anti.BackgroundColor3 = Color3.fromRGB(100,100,180)
anti.TextColor3 = Color3.new(1,1,1)
anti.Font = Enum.Font.Gotham
anti.TextSize = 13

local plus = Instance.new("TextButton", frame)
plus.Size = UDim2.new(0.5,-12,0,20)
plus.Position = UDim2.new(0,10,0,64)
plus.Text = "+Power"
plus.BackgroundColor3 = Color3.fromRGB(120,180,120)
plus.TextColor3 = Color3.new(1,1,1)
plus.Font = Enum.Font.Gotham
plus.TextSize = 12

local minus = Instance.new("TextButton", frame)
minus.Size = UDim2.new(0.5,-12,0,20)
minus.Position = UDim2.new(0.5,2,0,64)
minus.Text = "-Power"
minus.BackgroundColor3 = Color3.fromRGB(180,120,120)
minus.TextColor3 = Color3.new(1,1,1)
minus.Font = Enum.Font.Gotham
minus.TextSize = 12

local close = Instance.new("TextButton", frame)
close.Size = UDim2.new(1,-20,0,20)
close.Position = UDim2.new(0,10,0,89)
close.Text = "Close"
close.BackgroundColor3 = Color3.fromRGB(160,80,80)
close.TextColor3 = Color3.new(1,1,1)
close.Font = Enum.Font.Gotham
close.TextSize = 12

-- Button logic
btn.MouseButton1Click:Connect(function()
    AutoFling = not AutoFling
    btn.Text = "Auto Fling: "..(AutoFling and "ON" or "OFF")
end)

anti.MouseButton1Click:Connect(function()
    AntiFling = not AntiFling
    anti.Text = "AntiFling: "..(AntiFling and "ON" or "OFF")
end)

plus.MouseButton1Click:Connect(function()
    MaxForce = MaxForce + 1000
    btn.Text = "Power: "..MaxForce
end)

minus.MouseButton1Click:Connect(function()
    MaxForce = math.max(0, MaxForce - 1000)
    btn.Text = "Power: "..MaxForce
end)

close.MouseButton1Click:Connect(function()
    gui:Destroy()
    AutoFling = false
end)

-- Антифлинг
RunService.Stepped:Connect(function()
    if AntiFling and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        hrp.Velocity = Vector3.zero
        hrp.RotVelocity = Vector3.zero
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero
    end
end)

-- Визуал: аура
local aura
local function createAura()
    if aura then aura:Destroy() end
    aura = Instance.new("Part")
    aura.Shape = Enum.PartType.Ball
    aura.Material = Enum.Material.Neon
    aura.Color = Color3.fromRGB(255,0,0)
    aura.Size = Vector3.new(8,8,8)
    aura.Anchored = true
    aura.CanCollide = false
    aura.Transparency = 0.5
    aura.Parent = workspace
end

-- Основной цикл
RunService.Heartbeat:Connect(function()
    if AutoFling and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        if not aura or not aura.Parent then createAura() end
        aura.Position = hrp.Position

        for _,plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character.Humanoid.Health>0 then
                local targetHRP = plr.Character.HumanoidRootPart
                local dist = (targetHRP.Position - hrp.Position).Magnitude
                if dist <= 10 then
                    targetHRP.Velocity = (targetHRP.Position - hrp.Position).Unit * MaxForce
                end
            end
        end
    elseif aura and aura.Parent then
        aura:Destroy()
    end
end)
