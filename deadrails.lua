local player = game.Players.LocalPlayer
local runService = game:GetService("RunService")
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.ResetOnSpawn = false

-- 🌟 Анимация старта
local splash = Instance.new("TextLabel", gui)
splash.Size = UDim2.new(1,0,1,0)
splash.BackgroundColor3 = Color3.new(0,0,0)
splash.Text = "🌟 Loading Patrick Script... 🌟"
splash.TextScaled = true
splash.TextColor3 = Color3.fromRGB(0,255,0)
wait(2)
splash:Destroy()

-- 🌟 Главное меню
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 250, 0, 250)
frame.Position = UDim2.new(0.4,0,0.4,0)
frame.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
frame.BackgroundTransparency = 0.2
frame.Active = true
frame.Draggable = true

local stroke = Instance.new("UIStroke", frame)
stroke.Color = Color3.fromRGB(0,255,0)
stroke.Thickness = 2

-- 🌟 Кнопки свернуть и закрыть
local closeBtn = Instance.new("TextButton", frame)
closeBtn.Size = UDim2.new(0, 30, 0, 20)
closeBtn.Position = UDim2.new(1, -35, 0, 0)
closeBtn.Text = "X"
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)

local minimizeBtn = Instance.new("TextButton", frame)
minimizeBtn.Size = UDim2.new(0, 30, 0, 20)
minimizeBtn.Position = UDim2.new(1, -70, 0, 0)
minimizeBtn.Text = "-"
minimizeBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)

local minimized = false
minimizeBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    for _, c in pairs(frame:GetChildren()) do
        if c:IsA("TextButton") and c ~= closeBtn and c ~= minimizeBtn then
            c.Visible = not minimized
        end
    end
end)
closeBtn.MouseButton1Click:Connect(function() gui:Destroy() end)

-- 🌟 Создание кнопок
local function createButton(name, text, posY)
    local btn = Instance.new("TextButton", frame)
    btn.Name = name
    btn.Size = UDim2.new(0, 230, 0, 30)
    btn.Position = UDim2.new(0,10,0,posY)
    btn.Text = text
    btn.BackgroundColor3 = Color3.fromRGB(0,200,0)
    btn.TextColor3 = Color3.new(0,0,0)
    btn.BackgroundTransparency = 0.1
    return btn
end

-- 🌟 Переменные
local noclipEnabled = false
local speedhackEnabled = false
local speedValue = 2
local flyEnabled = false
local flySpeed = 2
local autoAttackEnabled = false
local closeBaseEnabled = false
local baseSavedPos = nil

-- 🌟 NoClip с обходом
local noclipBtn = createButton("NoClipBtn","NoClip: OFF",40)
noclipBtn.MouseButton1Click:Connect(function()
    noclipEnabled = not noclipEnabled
    noclipBtn.Text = "NoClip: "..(noclipEnabled and "ON" or "OFF")
end)
runService.Stepped:Connect(function()
    if noclipEnabled and player.Character then
        for _,part in pairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide=false end
        end
    end
end)

-- 🌟 SpeedHack
local speedBtn = createButton("SpeedBtn","SpeedHack",80)
speedBtn.MouseButton1Click:Connect(function()
    local speedMenu = Instance.new("Frame", gui)
    speedMenu.Size = UDim2.new(0,200,0,120)
    speedMenu.Position = UDim2.new(0.6,0,0.4,0)
    speedMenu.BackgroundColor3 = Color3.fromRGB(0,255,0)
    speedMenu.Active = true
    speedMenu.Draggable = true
    local onOff = createButton("OnOff","ON/OFF",10)
    onOff.Parent = speedMenu
    onOff.Size=UDim2.new(1,0,0,30)
    local plus = createButton("Plus","+",50)
    plus.Parent = speedMenu
    plus.Size=UDim2.new(0.5,0,0,30)
    local minus = createButton("Minus","-",50)
    minus.Parent = speedMenu
    minus.Position=UDim2.new(0.5,0,0,50)
    minus.Size=UDim2.new(0.5,0,0,30)
    local x = createButton("Close","X",90)
    x.Parent=speedMenu
    x.Size=UDim2.new(1,0,0,30)
    onOff.MouseButton1Click:Connect(function()
        speedhackEnabled=not speedhackEnabled
        onOff.Text="ON/OFF: "..(speedhackEnabled and "ON" or "OFF")
    end)
    plus.MouseButton1Click:Connect(function() speedValue=speedValue+1 end)
    minus.MouseButton1Click:Connect(function() speedValue=math.max(1,speedValue-1) end)
    x.MouseButton1Click:Connect(function() speedMenu:Destroy() end)
end)
runService.RenderStepped:Connect(function()
    if speedhackEnabled and player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = speedValue*16
    else
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = 16
        end
    end
end)

-- 🌟 Fly
local flyBtn = createButton("FlyBtn","Fly",120)
flyBtn.MouseButton1Click:Connect(function()
    local flyMenu = Instance.new("Frame", gui)
    flyMenu.Size = UDim2.new(0,200,0,120)
    flyMenu.Position = UDim2.new(0.6,0,0.6,0)
    flyMenu.BackgroundColor3 = Color3.fromRGB(0,255,0)
    flyMenu.Active = true
    flyMenu.Draggable = true
    local onOff = createButton("OnOff","ON/OFF",10)
    onOff.Parent=flyMenu
    onOff.Size=UDim2.new(1,0,0,30)
    local up = createButton("Up","UP",50)
    up.Parent=flyMenu
    up.Size=UDim2.new(0.5,0,0,30)
    local down = createButton("Down","DOWN",50)
    down.Parent=flyMenu
    down.Position=UDim2.new(0.5,0,0,50)
    down.Size=UDim2.new(0.5,0,0,30)
    local x = createButton("Close","X",90)
    x.Parent=flyMenu
    x.Size=UDim2.new(1,0,0,30)
    onOff.MouseButton1Click:Connect(function()
        flyEnabled=not flyEnabled
        onOff.Text="ON/OFF: "..(flyEnabled and "ON" or "OFF")
    end)
    up.MouseButton1Click:Connect(function() flySpeed=flySpeed+1 end)
    down.MouseButton1Click:Connect(function() flySpeed=math.max(1,flySpeed-1) end)
    x.MouseButton1Click:Connect(function() flyMenu:Destroy() end)
end)
runService.RenderStepped:Connect(function()
    if flyEnabled and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local cf=player.Character.HumanoidRootPart.CFrame
        player.Character.HumanoidRootPart.Velocity=cf.LookVector*flySpeed*10
    end
end)

-- 🌟 AutoAttack с увеличением хитбоксов
local atkBtn = createButton("AtkBtn","AutoAttack: OFF",160)
atkBtn.MouseButton1Click:Connect(function()
    autoAttackEnabled=not autoAttackEnabled
    atkBtn.Text="AutoAttack: "..(autoAttackEnabled and "ON" or "OFF")
    if autoAttackEnabled then
        spawn(function()
            while autoAttackEnabled do
                for _,pl in pairs(game.Players:GetPlayers()) do
                    if pl~=player and pl.Character then
                        for _,part in pairs(pl.Character:GetChildren()) do
                            if part:IsA("BasePart") then part.Size=Vector3.new(10,10,10) end
                        end
                    end
                end
                local tool=player.Character and player.Character:FindFirstChildOfClass("Tool")
                if tool then tool:Activate() end
                wait(0.1)
            end
        end)
    end
end)

-- 🌟 Закрыть базу
local acbBtn = createButton("ACBBtn","Закрыть базу: OFF",200)
acbBtn.MouseButton1Click:Connect(function()
    closeBaseEnabled=not closeBaseEnabled
    acbBtn.Text="Закрыть базу: "..(closeBaseEnabled and "ON" or "OFF")
    if closeBaseEnabled and not baseSavedPos then
        baseSavedPos = player.Character and player.Character.HumanoidRootPart.Position
    end
    if closeBaseEnabled then
        spawn(function()
            while closeBaseEnabled do
                if baseSavedPos then
                    player.Character.HumanoidRootPart.CFrame=CFrame.new(baseSavedPos)
                end
                wait(0.2)
            end
        end)
    end
end)

-- Автор
local author=Instance.new("TextLabel",frame)
author.Size=UDim2.new(0,250,0,20)
author.Position=UDim2.new(0,0,1,-20)
author.Text="Автор @gde_patrick | Подпишись @script_patrick"
author.TextScaled=true
author.TextColor3=Color3.new(0,1,0)
author.BackgroundTransparency=1
