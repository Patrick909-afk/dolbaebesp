local player = game.Players.LocalPlayer
local runService = game:GetService("RunService")
local uis = game:GetService("UserInputService")
local tweenService = game:GetService("TweenService")

local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.ResetOnSpawn = false

-- 🌟 Меню
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 220, 0, 180)
frame.Position = UDim2.new(0.4, 0, 0.4, 0)
frame.BackgroundColor3 = Color3.fromRGB(0, 40, 0)
frame.BackgroundTransparency = 0.25
frame.Active = true
frame.Draggable = true
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.ClipsDescendants = true
frame.Visible = false

local corner = Instance.new("UICorner", frame)
corner.CornerRadius = UDim.new(0, 12)

local stroke = Instance.new("UIStroke", frame)
stroke.Color = Color3.fromRGB(0, 255, 0)
stroke.Thickness = 2
stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- 🌟 Градиент
local gradient = Instance.new("UIGradient", frame)
gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0,255,0)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0,100,0))
}
gradient.Rotation = 45

-- 🌟 Анимация появления
frame.Visible = true
frame.Size = UDim2.new(0, 0, 0, 0)
local tween = tweenService:Create(frame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    { Size = UDim2.new(0,220,0,180) })
tween:Play()

-- 🌟 Функция для кнопок
local function createButton(text, posY)
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(1, -20, 0, 40)
    btn.Position = UDim2.new(0,10,0,posY)
    btn.Text = text
    btn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    btn.TextColor3 = Color3.new(0,0,0)
    btn.BackgroundTransparency = 0.05
    local btnCorner = Instance.new("UICorner", btn)
    btnCorner.CornerRadius = UDim.new(0, 8)

    -- анимация наведения
    btn.MouseEnter:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
    end)
    btn.MouseLeave:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    end)
    return btn
end

-- ✈️ Fly
local flyBtn = createButton("Patrick Fly: OFF", 10)
local flyEnabled = false
local velocity = Vector3.new()

flyBtn.MouseButton1Click:Connect(function()
    flyEnabled = not flyEnabled
    flyBtn.Text = "Patrick Fly: " .. (flyEnabled and "ON" or "OFF")
end)

runService.RenderStepped:Connect(function()
    if flyEnabled and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = player.Character.HumanoidRootPart
        local cam = workspace.CurrentCamera
        local dir = cam.CFrame.LookVector
        hrp.Velocity = dir * 50  -- скорость
    end
end)

-- 🚪 TP внутрь базы
local tpBtn = createButton("TP Inside Base", 60)
tpBtn.MouseButton1Click:Connect(function()
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = player.Character.HumanoidRootPart
        hrp.CFrame = hrp.CFrame * CFrame.new(0, 0, -10)
    end
end)

-- ❌ Закрыть
local closeBtn = Instance.new("TextButton", frame)
closeBtn.Size = UDim2.new(0, 30, 0, 25)
closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.Text = "✕"
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
closeBtn.TextColor3 = Color3.new(1,1,1)
local closeCorner = Instance.new("UICorner", closeBtn)
closeCorner.CornerRadius = UDim.new(0,6)

closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- 📌 Автор
local author = Instance.new("TextLabel", frame)
author.Size = UDim2.new(1, -20, 0, 20)
author.Position = UDim2.new(0,10,1,-25)
author.Text = "Автор @gde_patrick | @script_patrick"
author.TextScaled = true
author.TextColor3 = Color3.fromRGB(0,255,0)
author.BackgroundTransparency = 1
