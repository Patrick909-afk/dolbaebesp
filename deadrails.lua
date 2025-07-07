local player = game.Players.LocalPlayer
local runService = game:GetService("RunService")
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.ResetOnSpawn = false

-- 🌟 Неоновая анимация старта
local splash = Instance.new("TextLabel", gui)
splash.Size = UDim2.new(1,0,1,0)
splash.BackgroundColor3 = Color3.new(0,0,0)
splash.Text = "🌟 Loading Patrick Script... 🌟"
splash.TextScaled = true
splash.TextColor3 = Color3.fromRGB(0,255,0)
local stroke = Instance.new("UIStroke", splash)
stroke.Thickness = 2
stroke.Color = Color3.fromRGB(0,255,0)
wait(2)
splash:Destroy()

-- 🌟 Главное меню
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 240, 0, 260)
frame.Position = UDim2.new(0.4,0,0.3,0)
frame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
frame.BackgroundTransparency = 0.2
frame.Active = true
frame.Draggable = true
local frameStroke = Instance.new("UIStroke", frame)
frameStroke.Color = Color3.fromRGB(0,255,0)
frameStroke.Thickness = 2

local function createButton(parent, name, text, posY)
    local btn = Instance.new("TextButton", parent)
    btn.Name = name
    btn.Size = UDim2.new(0, 220, 0, 30)
    btn.Position = UDim2.new(0, 10, 0, posY)
    btn.Text = text
    btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    btn.TextColor3 = Color3.fromRGB(0,255,0)
    btn.BackgroundTransparency = 0.1
    local btnStroke = Instance.new("UIStroke", btn)
    btnStroke.Color = Color3.fromRGB(0,255,0)
    btnStroke.Thickness = 1
    return btn
end

-- 🔧 Переменные
local minimized, noclip, autoClose = false, false, false
local speedEnabled, speed = false, 50
local flyEnabled, flySpeed = false, 50
local contraEnabled = false
local contraTargets = {}

-- Кнопки
local noclipBtn = createButton(frame, "NoClipBtn", "NoClip: OFF", 40)
local speedMenuBtn = createButton(frame, "SpeedMenuBtn", "Speed Menu ▸", 80)
local flyMenuBtn = createButton(frame, "FlyMenuBtn", "Fly Menu ▸", 120)
local contraMenuBtn = createButton(frame, "ContraMenuBtn", "Контра Menu ▸", 160)
local autoCloseBtn = createButton(frame, "AutoCloseBtn", "Auto-Close: OFF", 200)

local closeBtn = createButton(frame, "CloseBtn", "X", 0)
closeBtn.Size = UDim2.new(0, 30, 0, 20)
closeBtn.Position = UDim2.new(1, -35, 0, 0)

local minimizeBtn = createButton(frame, "MinimizeBtn", "-", 0)
minimizeBtn.Size = UDim2.new(0, 30, 0, 20)
minimizeBtn.Position = UDim2.new(1, -70, 0, 0)

-- Авторство
local author = Instance.new("TextLabel", frame)
author.Size = UDim2.new(0, 240, 0, 20)
author.Position = UDim2.new(0,0,1,-20)
author.Text = "Автор @gde_patrick | @script_patrick"
author.TextScaled = true
author.TextColor3 = Color3.fromRGB(0,255,0)
author.BackgroundTransparency = 1

-- 🌟 Speed подменю
local speedMenu = Instance.new("Frame", gui)
speedMenu.Size = UDim2.new(0, 200, 0, 100)
speedMenu.Position = UDim2.new(0.6,0,0.3,0)
speedMenu.BackgroundColor3 = Color3.fromRGB(10,10,10)
speedMenu.Visible = false
local s1 = createButton(speedMenu, "SpeedToggle", "Speed: OFF", 10)
local s2 = createButton(speedMenu, "AddSpeed", "+10 Speed", 50)
local s3 = createButton(speedMenu, "SubSpeed", "-10 Speed", 50)
s3.Position = UDim2.new(0,110,0,50)

-- 🌟 Fly подменю
local flyMenu = Instance.new("Frame", gui)
flyMenu.Size = UDim2.new(0, 200, 0, 100)
flyMenu.Position = UDim2.new(0.6,0,0.45,0)
flyMenu.BackgroundColor3 = Color3.fromRGB(10,10,10)
flyMenu.Visible = false
local f1 = createButton(flyMenu, "FlyToggle", "Fly: OFF", 10)
local f2 = createButton(flyMenu, "AddFly", "+10 Speed", 50)
local f3 = createButton(flyMenu, "SubFly", "-10 Speed", 50)
f3.Position = UDim2.new(0,110,0,50)

-- 🌟 Контра подменю
local contraMenu = Instance.new("Frame", gui)
contraMenu.Size = UDim2.new(0, 220, 0, 160)
contraMenu.Position = UDim2.new(0.6,0,0.6,0)
contraMenu.BackgroundColor3 = Color3.fromRGB(10,10,10)
contraMenu.Visible = false
local c1 = createButton(contraMenu, "ContraToggle", "Контра: OFF", 10)
local c2 = createButton(contraMenu, "ClearList", "Очистить список", 50)
local playersList = Instance.new("TextLabel", contraMenu)
playersList.Size = UDim2.new(0,220,0,60)
playersList.Position = UDim2.new(0,0,0,90)
playersList.Text = "Игроки:"
playersList.TextColor3 = Color3.fromRGB(0,255,0)
playersList.BackgroundTransparency = 1
playersList.TextScaled = true

-- 🧩 Функционал
noclipBtn.MouseButton1Click:Connect(function()
    noclip = not noclip
    noclipBtn.Text = "NoClip: "..(noclip and "ON" or "OFF")
end)

runService.Stepped:Connect(function()
    if noclip and player.Character then
        for _, part in pairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide=false end
        end
    end
end)

speedMenuBtn.MouseButton1Click:Connect(function() speedMenu.Visible = not speedMenu.Visible end)
flyMenuBtn.MouseButton1Click:Connect(function() flyMenu.Visible = not flyMenu.Visible end)
contraMenuBtn.MouseButton1Click:Connect(function() contraMenu.Visible = not contraMenu.Visible end)

s1.MouseButton1Click:Connect(function()
    speedEnabled = not speedEnabled
    s1.Text = "Speed: "..(speedEnabled and "ON" or "OFF")
end)
s2.MouseButton1Click:Connect(function() speed=speed+10 end)
s3.MouseButton1Click:Connect(function() speed=math.max(10,speed-10) end)

f1.MouseButton1Click:Connect(function()
    flyEnabled=not flyEnabled
    f1.Text="Fly: "..(flyEnabled and "ON" or "OFF")
end)
f2.MouseButton1Click:Connect(function() flySpeed=flySpeed+10 end)
f3.MouseButton1Click:Connect(function() flySpeed=math.max(10,flySpeed-10) end)

c1.MouseButton1Click:Connect(function()
    contraEnabled=not contraEnabled
    c1.Text="Контра: "..(contraEnabled and "ON" or "OFF")
end)
c2.MouseButton1Click:Connect(function() contraTargets={} end)

autoCloseBtn.MouseButton1Click:Connect(function()
    autoClose=not autoClose
    autoCloseBtn.Text="Auto-Close: "..(autoClose and "ON" or "OFF")
end)

runService.RenderStepped:Connect(function()
    if flyEnabled and player.Character then
        local dir = workspace.CurrentCamera.CFrame.lookVector
        player.Character.HumanoidRootPart.Velocity=dir*flySpeed
    end
    if speedEnabled and player.Character then
        player.Character:FindFirstChildOfClass("Humanoid").WalkSpeed=speed
    else
        if player.Character then player.Character:FindFirstChildOfClass("Humanoid").WalkSpeed=16 end
    end
    if contraEnabled then
        local str="Игроки:\n"
        for _,p in pairs(game.Players:GetPlayers()) do
            if p~=player and p.Character then
                str=str..p.Name.."\n"
                local tool=player.Backpack:FindFirstChildOfClass("Tool") or player.Character:FindFirstChildOfClass("Tool")
                if tool then
                    player.Character.HumanoidRootPart.CFrame=p.Character.PrimaryPart.CFrame+Vector3.new(0,0,2)
                    tool:Activate()
                end
            end
        end
        playersList.Text=str
    end
end)

closeBtn.MouseButton1Click:Connect(function() gui:Destroy() end)
minimizeBtn.MouseButton1Click:Connect(function()
    minimized=not minimized
    for _,v in pairs(frame:GetChildren()) do
        if v:IsA("TextButton") or v:IsA("TextLabel") then
            if v~=closeBtn and v~=minimizeBtn then v.Visible=not minimized end
        end
    end
end)
