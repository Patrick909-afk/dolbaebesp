local player = game.Players.LocalPlayer
local runService = game:GetService("RunService")
local uis = game:GetService("UserInputService")
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
frame.BackgroundTransparency = 0.3
frame.Active = true
frame.Draggable = true

local stroke = Instance.new("UIStroke", frame)
stroke.Color = Color3.fromRGB(0,255,0)
stroke.Thickness = 2

-- 🌟 Сворачивание и закрытие
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

-- 🌟 Кнопка для создания подменю
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
local flyEnabled = false
local autoCloseEnabled = false
local autoAttackEnabled = false
local flySpeed = 2
local speedValue = 2

-- 🌟 NoClip с обходом античита
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

-- 🌟 SpeedHack подменю
local speedBtn = createButton("SpeedBtn","SpeedHack",80)
speedBtn.MouseButton1Click:Connect(function()
    local speedMenu = Instance.new("Frame", gui)
    speedMenu.Size = UDim2.new(0, 200, 0, 120)
    speedMenu.Position = UDim2.new(0.6,0,0.4,0)
    speedMenu.BackgroundColor3 = Color3.fromRGB(0,255,0)
    local onOff = createButton("SpeedOnOff","ON/OFF",10)
    onOff.Parent = speedMenu
    onOff.Size=UDim2.new(1,0,0,30)
    local plus = createButton("Plus","+",50)
    plus.Parent = speedMenu
    plus.Size=UDim2.new(0.5,0,0,30)
    local minus = createButton("Minus","-",50)
    minus.Parent = speedMenu
    minus.Position=UDim2.new(0.5,0,0,50)
    minus.Size=UDim2.new(0.5,0,0,30)
    local x = createButton("X","X",90)
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
runService.Stepped:Connect(function()
    if speedhackEnabled and player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = speedValue
    else
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = 16
        end
    end
end)

-- 🌟 Fly подменю
local flyBtn = createButton("FlyBtn","Fly",120)
flyBtn.MouseButton1Click:Connect(function()
    local flyMenu = Instance.new("Frame", gui)
    flyMenu.Size = UDim2.new(0, 200, 0, 120)
    flyMenu.Position = UDim2.new(0.6,0,0.6,0)
    flyMenu.BackgroundColor3 = Color3.fromRGB(0,255,0)
    local onOff = createButton("FlyOnOff","ON/OFF",10)
    onOff.Parent=flyMenu
    onOff.Size=UDim2.new(1,0,0,30)
    local up = createButton("Up","UP",50)
    up.Parent=flyMenu
    up.Size=UDim2.new(0.5,0,0,30)
    local down = createButton("Down","DOWN",50)
    down.Parent=flyMenu
    down.Position=UDim2.new(0.5,0,0,50)
    down.Size=UDim2.new(0.5,0,0,30)
    local x = createButton("X","X",90)
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

-- 🌟 AutoAttack
local atkBtn = createButton("AtkBtn","AutoAttack: OFF",160)
atkBtn.MouseButton1Click:Connect(function()
    autoAttackEnabled=not autoAttackEnabled
    atkBtn.Text="AutoAttack: "..(autoAttackEnabled and "ON" or "OFF")
    if autoAttackEnabled then
        spawn(function()
            while autoAttackEnabled do
                local tool=player.Character and player.Character:FindFirstChildOfClass("Tool")
                if tool then tool:Activate() end
                wait(0.1)
            end
        end)
    end
end)

-- 🌟 AutoCloseBase
local acbBtn = createButton("ACBBtn","AutoCloseBase: OFF",200)
acbBtn.MouseButton1Click:Connect(function()
    autoCloseEnabled=not autoCloseEnabled
    acbBtn.Text="AutoCloseBase: "..(autoCloseEnabled and "ON" or "OFF")
    if autoCloseEnabled then
        local basePos = player.Character and player.Character.HumanoidRootPart.Position
        spawn(function()
            while autoCloseEnabled do
                for _,obj in pairs(workspace:GetDescendants()) do
                    if obj:IsA("TextLabel") and tonumber(obj.Text)==4 then
                        player.Character.Humanoid.WalkSpeed=100
                        player.Character.HumanoidRootPart.CFrame=CFrame.new(basePos)
                        wait(0.2)
                        player.Character.Humanoid.WalkSpeed=16
                    end
                end
                wait(1)
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
