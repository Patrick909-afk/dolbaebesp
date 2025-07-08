--// by @gde_patrick

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local savedBasePos = nil
local flingPower = 1000
local flingOn = false

--// GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "PatrickMenu"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 250, 0, 200)
frame.Position = UDim2.new(0.5, -125, 0.5, -100)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.Active = true
frame.Draggable = true

local uicorner = Instance.new("UICorner", frame)
uicorner.CornerRadius = UDim.new(0,8)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,25)
title.BackgroundTransparency = 1
title.Text = "Patrick's Script"
title.TextColor3 = Color3.fromRGB(255,255,255)
title.Font = Enum.Font.GothamBold
title.TextSize = 16

local close = Instance.new("TextButton", frame)
close.Size = UDim2.new(0,25,0,25)
close.Position = UDim2.new(1,-25,0,0)
close.Text = "X"
close.TextColor3 = Color3.fromRGB(255,0,0)
close.BackgroundTransparency = 1
close.Font = Enum.Font.GothamBold
close.TextSize = 16
close.MouseButton1Click:Connect(function() gui:Destroy() end)

local flingBtn = Instance.new("TextButton", frame)
flingBtn.Size = UDim2.new(1,-20,0,30)
flingBtn.Position = UDim2.new(0,10,0,35)
flingBtn.Text = "Fling: OFF"
flingBtn.TextColor3 = Color3.fromRGB(255,255,255)
flingBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
flingBtn.Font = Enum.Font.Gotham
flingBtn.TextSize = 14

flingBtn.MouseButton1Click:Connect(function()
    flingOn = not flingOn
    flingBtn.Text = "Fling: "..(flingOn and "ON" or "OFF")
    flingBtn.BackgroundColor3 = flingOn and Color3.fromRGB(100,200,100) or Color3.fromRGB(50,50,50)
end)

local slider = Instance.new("TextBox", frame)
slider.Size = UDim2.new(1,-20,0,30)
slider.Position = UDim2.new(0,10,0,70)
slider.PlaceholderText = "Fling Power (default 1000)"
slider.Text = tostring(flingPower)
slider.TextColor3 = Color3.fromRGB(255,255,255)
slider.BackgroundColor3 = Color3.fromRGB(40,40,40)
slider.Font = Enum.Font.Gotham
slider.TextSize = 14

slider.FocusLost:Connect(function()
    local n = tonumber(slider.Text)
    if n then flingPower = n end
    slider.Text = tostring(flingPower)
end)

local saveBtn = Instance.new("TextButton", frame)
saveBtn.Size = UDim2.new(1,-20,0,30)
saveBtn.Position = UDim2.new(0,10,0,105)
saveBtn.Text = "Save Base Position"
saveBtn.TextColor3 = Color3.fromRGB(255,255,255)
saveBtn.BackgroundColor3 = Color3.fromRGB(50,50,80)
saveBtn.Font = Enum.Font.Gotham
saveBtn.TextSize = 14

saveBtn.MouseButton1Click:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        savedBasePos = LocalPlayer.Character.HumanoidRootPart.Position
        saveBtn.Text = "Base Saved!"
        task.wait(1)
        saveBtn.Text = "Save Base Position"
    end
end)

local tpBtn = Instance.new("TextButton", frame)
tpBtn.Size = UDim2.new(1,-20,0,30)
tpBtn.Position = UDim2.new(0,10,0,140)
tpBtn.Text = "TP to Base (smooth)"
tpBtn.TextColor3 = Color3.fromRGB(255,255,255)
tpBtn.BackgroundColor3 = Color3.fromRGB(80,50,50)
tpBtn.Font = Enum.Font.Gotham
tpBtn.TextSize = 14

tpBtn.MouseButton1Click:Connect(function()
    if savedBasePos and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        local tween = TweenService:Create(hrp, TweenInfo.new(2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {CFrame = CFrame.new(savedBasePos)})
        tween:Play()
    end
end)

--// fling loop
RunService.Heartbeat:Connect(function()
    if flingOn and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        for _,plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local dist = (hrp.Position - plr.Character.HumanoidRootPart.Position).Magnitude
                if dist < 10 then -- радиус действия
                    local bv = Instance.new("BodyVelocity")
                    bv.Velocity = (plr.Character.HumanoidRootPart.Position - hrp.Position).Unit * flingPower
                    bv.MaxForce = Vector3.new(1e5,1e5,1e5)
                    bv.Parent = plr.Character.HumanoidRootPart
                    game:GetService("Debris"):AddItem(bv, 0.1)
                end
            end
        end
    end
end)
