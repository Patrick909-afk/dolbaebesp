-- by @gde_patrick

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local flingPart = nil
local flingEnabled = false
local flingPower = 5000 -- начальная мощность

-- GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "PatrickFlingMenu"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 230, 0, 140)
frame.Position = UDim2.new(0.5, -115, 0.5, -70)
frame.BackgroundColor3 = Color3.fromRGB(30,30,40)
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, -30, 0, 30)
title.Position = UDim2.new(0, 5, 0, 5)
title.BackgroundTransparency = 1
title.Text = "Patrick Fling v1"
title.TextColor3 = Color3.fromRGB(255,255,255)
title.TextSize = 16
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left

local close = Instance.new("TextButton", frame)
close.Size = UDim2.new(0, 25, 0, 25)
close.Position = UDim2.new(1, -30, 0, 7)
close.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
close.Text = "X"
close.TextColor3 = Color3.new(1,1,1)
close.TextSize = 14
close.Font = Enum.Font.GothamBold

local toggle = Instance.new("TextButton", frame)
toggle.Size = UDim2.new(1, -20, 0, 35)
toggle.Position = UDim2.new(0, 10, 0, 40)
toggle.BackgroundColor3 = Color3.fromRGB(80,160,80)
toggle.Text = "Включить fling"
toggle.TextColor3 = Color3.new(1,1,1)
toggle.TextSize = 16
toggle.Font = Enum.Font.GothamBold

local powerLabel = Instance.new("TextLabel", frame)
powerLabel.Size = UDim2.new(1, -20, 0, 20)
powerLabel.Position = UDim2.new(0, 10, 0, 80)
powerLabel.BackgroundTransparency = 1
powerLabel.Text = "Мощность: "..flingPower
powerLabel.TextColor3 = Color3.fromRGB(255,255,255)
powerLabel.TextSize = 14
powerLabel.Font = Enum.Font.Gotham

local slider = Instance.new("TextButton", frame)
slider.Size = UDim2.new(1, -20, 0, 25)
slider.Position = UDim2.new(0, 10, 0, 105)
slider.BackgroundColor3 = Color3.fromRGB(60,60,80)
slider.Text = "Увеличить мощность +500"
slider.TextColor3 = Color3.new(1,1,1)
slider.TextSize = 14
slider.Font = Enum.Font.Gotham

-- fling logic
local function startFling()
    if flingPart then flingPart:Destroy() end

    flingPart = Instance.new("Part", workspace)
    flingPart.Name = "PatrickFlingPart"
    flingPart.Size = Vector3.new(5,5,5)
    flingPart.Transparency = 1
    flingPart.Anchored = false
    flingPart.CanCollide = true

    local weld = Instance.new("WeldConstraint", flingPart)
    weld.Part0 = flingPart
    weld.Part1 = LocalPlayer.Character:WaitForChild("HumanoidRootPart")

    local gyro = Instance.new("BodyAngularVelocity", flingPart)
    gyro.AngularVelocity = Vector3.new(0, flingPower, 0)
    gyro.MaxTorque = Vector3.new(1e9,1e9,1e9)
    gyro.P = 1e9
end

local function stopFling()
    if flingPart then
        flingPart:Destroy()
        flingPart = nil
    end
end

-- кнопки
toggle.MouseButton1Click:Connect(function()
    flingEnabled = not flingEnabled
    if flingEnabled then
        toggle.Text = "Выключить fling"
        toggle.BackgroundColor3 = Color3.fromRGB(200,80,80)
        startFling()
    else
        toggle.Text = "Включить fling"
        toggle.BackgroundColor3 = Color3.fromRGB(80,160,80)
        stopFling()
    end
end)

slider.MouseButton1Click:Connect(function()
    flingPower = flingPower + 500
    powerLabel.Text = "Мощность: "..flingPower
    if flingEnabled and flingPart then
        flingPart.BodyAngularVelocity.AngularVelocity = Vector3.new(0, flingPower, 0)
    end
end)

close.MouseButton1Click:Connect(function()
    gui:Destroy()
end)
