local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

local savedPosition = nil
local flingPart = nil
local flingOn = false
local flyOn = false
local speedOn = false
local jumpOn = false
local spamOn = false
local autoHitOn = false

-- GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "PatrickHub"

-- Ключ
local keyFrame = Instance.new("Frame", gui)
keyFrame.Size = UDim2.new(0, 300, 0, 160)
keyFrame.Position = UDim2.new(0.5, -150, 0.5, -80)
keyFrame.BackgroundColor3 = Color3.fromRGB(30,30,40)

local uic = Instance.new("UICorner", keyFrame)

local title = Instance.new("TextLabel", keyFrame)
title.Size = UDim2.new(1,0,0,40)
title.Text = "PatrickHub v1 @gde_patrick"
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1

local keyBox = Instance.new("TextBox", keyFrame)
keyBox.PlaceholderText = "Введите ключ"
keyBox.Text = ""
keyBox.Size = UDim2.new(0.8,0,0,30)
keyBox.Position = UDim2.new(0.1,0,0.4,0)
keyBox.BackgroundColor3 = Color3.fromRGB(50,50,60)
keyBox.TextColor3 = Color3.new(1,1,1)
keyBox.Font = Enum.Font.Gotham
keyBox.TextSize = 14
Instance.new("UICorner", keyBox)

local msg = Instance.new("TextLabel", keyFrame)
msg.Size = UDim2.new(1,0,0,20)
msg.Position = UDim2.new(0,0,0.7,0)
msg.Text = ""
msg.TextColor3 = Color3.fromRGB(255,100,100)
msg.TextSize = 14
msg.BackgroundTransparency = 1
msg.Font = Enum.Font.Gotham

local btn = Instance.new("TextButton", keyFrame)
btn.Size = UDim2.new(0.6,0,0,30)
btn.Position = UDim2.new(0.2,0,0.85,0)
btn.Text = "Continue"
btn.Font = Enum.Font.GothamBold
btn.TextSize = 14
btn.TextColor3 = Color3.new(1,1,1)
btn.BackgroundColor3 = Color3.fromRGB(80,160,80)
Instance.new("UICorner", btn)

-- Основное меню
local main = Instance.new("Frame")
main.Size = UDim2.new(0, 300, 0, 400)
main.Position = UDim2.new(0.5, -150, 0.5, -200)
main.BackgroundColor3 = Color3.fromRGB(30,30,40)
main.Visible = false
main.Parent = gui
Instance.new("UICorner", main)

local title2 = Instance.new("TextLabel", main)
title2.Size = UDim2.new(1,0,0,30)
title2.Text = "PatrickHub v1 @gde_patrick"
title2.Font = Enum.Font.GothamBold
title2.TextSize = 16
title2.TextColor3 = Color3.new(1,1,1)
title2.BackgroundColor3 = Color3.fromRGB(20,20,30)

-- Кнопки + поля
local function createBtn(name, posY, text, callback)
    local b = Instance.new("TextButton", main)
    b.Size = UDim2.new(0.9,0,0,30)
    b.Position = UDim2.new(0.05,0,0,posY)
    b.Text = text
    b.Font = Enum.Font.Gotham
    b.TextSize = 14
    b.TextColor3 = Color3.new(1,1,1)
    b.BackgroundColor3 = Color3.fromRGB(60,60,80)
    Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(callback)
    return b
end

local flingSpeedBox = Instance.new("TextBox", main)
flingSpeedBox.Size = UDim2.new(0.4,0,0,25)
flingSpeedBox.Position = UDim2.new(0.55,0,0.08,35)
flingSpeedBox.PlaceholderText = "Скорость"
flingSpeedBox.Text = "500000"
flingSpeedBox.BackgroundColor3 = Color3.fromRGB(50,50,60)
flingSpeedBox.TextColor3 = Color3.new(1,1,1)
flingSpeedBox.Font = Enum.Font.Gotham
flingSpeedBox.TextSize = 12
Instance.new("UICorner", flingSpeedBox)

local flingBtn = createBtn("fling",0.08,"Fling ВКЛ/ВЫКЛ",function()
    flingOn = not flingOn
    if flingOn then
        local speed = tonumber(flingSpeedBox.Text) or 500000
        flingPart = Instance.new("BodyAngularVelocity")
        flingPart.AngularVelocity = Vector3.new(0,speed,0)
        flingPart.MaxTorque = Vector3.new(0,math.huge,0)
        flingPart.P = math.huge
        flingPart.Parent = hrp
    else
        if flingPart then flingPart:Destroy() end
    end
end)

local flyBtn = createBtn("fly",0.18,"Fly ВКЛ/ВЫКЛ",function()
    flyOn = not flyOn
end)

local speedBox = Instance.new("TextBox", main)
speedBox.Size = UDim2.new(0.4,0,0,25)
speedBox.Position = UDim2.new(0.55,0,0.28,35)
speedBox.PlaceholderText = "Скорость"
speedBox.Text = "50"
speedBox.BackgroundColor3 = Color3.fromRGB(50,50,60)
speedBox.TextColor3 = Color3.new(1,1,1)
speedBox.Font = Enum.Font.Gotham
speedBox.TextSize = 12
Instance.new("UICorner", speedBox)

local speedBtn = createBtn("speed",0.28,"SpeedHack ВКЛ/ВЫКЛ",function()
    speedOn = not speedOn
    if speedOn then
        char:FindFirstChildOfClass("Humanoid").WalkSpeed = tonumber(speedBox.Text) or 50
    else
        char:FindFirstChildOfClass("Humanoid").WalkSpeed = 16
    end
end)

local jumpBox = Instance.new("TextBox", main)
jumpBox.Size = UDim2.new(0.4,0,0,25)
jumpBox.Position = UDim2.new(0.55,0,0.38,35)
jumpBox.PlaceholderText = "Сила"
jumpBox.Text = "100"
jumpBox.BackgroundColor3 = Color3.fromRGB(50,50,60)
jumpBox.TextColor3 = Color3.new(1,1,1)
jumpBox.Font = Enum.Font.Gotham
jumpBox.TextSize = 12
Instance.new("UICorner", jumpBox)

local jumpBtn = createBtn("jump",0.38,"JumpHack ВКЛ/ВЫКЛ",function()
    jumpOn = not jumpOn
    if jumpOn then
        char:FindFirstChildOfClass("Humanoid").JumpPower = tonumber(jumpBox.Text) or 100
    else
        char:FindFirstChildOfClass("Humanoid").JumpPower = 50
    end
end)

createBtn("invis",0.48,"Невидимость",function()
    for _,v in pairs(char:GetDescendants()) do
        if v:IsA("BasePart") then v.Transparency=1 end
    end
end)

createBtn("color",0.58,"Случайный цвет",function()
    for _,v in pairs(char:GetDescendants()) do
        if v:IsA("BasePart") then v.Color=Color3.new(math.random(),math.random(),math.random()) end
    end
end)

createBtn("spam",0.68,"Спам в чат ВКЛ/ВЫКЛ",function()
    spamOn = not spamOn
end)

createBtn("hit",0.78,"Автоудар ВКЛ/ВЫКЛ",function()
    autoHitOn = not autoHitOn
end)

createBtn("save",0.88,"Сохранить базу",function()
    savedPosition = hrp.Position
end)

createBtn("tp",0.94,"Телепорт к базе",function()
    if savedPosition then
        TweenService:Create(hrp,TweenInfo.new(2),{CFrame=CFrame.new(savedPosition)}):Play()
    end
end)

-- Закрыть
local close = Instance.new("TextButton", title2)
close.Size=UDim2.new(0,25,0,25)
close.Position=UDim2.new(1,-30,0,2)
close.Text="X"
close.TextColor3=Color3.new(1,1,1)
close.BackgroundColor3=Color3.fromRGB(255,60,60)
Instance.new("UICorner",close)
close.MouseButton1Click:Connect(function() gui:Destroy() end)

-- Перетаскивание
local dragging,dragStart,startPos
title2.InputBegan:Connect(function(i)
if i.UserInputType==Enum.UserInputType.MouseButton1 then
dragging=true;dragStart=i.Position;startPos=main.Position
end end)
UserInputService.InputChanged:Connect(function(i)
if dragging and i.UserInputType==Enum.UserInputType.MouseMovement then
local delta=i.Position-dragStart
main.Position=UDim2.new(startPos.X.Scale, startPos.X.Offset+delta.X, startPos.Y.Scale, startPos.Y.Offset+delta.Y)
end end)
UserInputService.InputEnded:Connect(function(i)
if i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=false end end)

-- Логика флая/спама/ударов
spawn(function()
while wait(0.1) do
    if flyOn then hrp.Velocity=Vector3.new(0,50,0) end
    if spamOn then game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer("PatrickHub OP","All") end
    if autoHitOn then
        local tool=player.Backpack:FindFirstChildOfClass("Tool") or char:FindFirstChildOfClass("Tool")
        if tool then tool:Activate() end
    end
end end)

-- Проверка ключа
btn.MouseButton1Click:Connect(function()
if keyBox.Text=="FREE" then keyFrame.Visible=false main.Visible=true else msg.Text="Неверный ключ!" end
end)
