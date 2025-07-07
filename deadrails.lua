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
splash.TextColor3 = Color3.new(0,1,0)
wait(2)
splash:Destroy()

-- 🌟 Главное меню
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 220, 0, 240)
frame.Position = UDim2.new(0.4,0,0.4,0)
frame.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
frame.BackgroundTransparency = 0.2
frame.Active = true
frame.Draggable = true

local stroke = Instance.new("UIStroke", frame)
stroke.Color = Color3.fromRGB(0,255,0)
stroke.Thickness = 2

local function createButton(name, text, posY)
    local btn = Instance.new("TextButton", frame)
    btn.Name = name
    btn.Size = UDim2.new(0, 200, 0, 30)
    btn.Position = UDim2.new(0, 10, 0, posY)
    btn.Text = text
    btn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    btn.TextColor3 = Color3.new(0,0,0)
    btn.BackgroundTransparency = 0.1
    return btn
end

local noclipBtn = createButton("NoClipBtn", "NoClip: OFF", 40)
local flyBtn = createButton("FlyBtn", "Fly Menu", 80)
local speedBtn = createButton("SpeedBtn", "Speed Menu", 120)
local contraBtn = createButton("ContraBtn", "Контра Menu", 160)
local autoCloseBtn = createButton("AutoCloseBtn", "Auto-Close: OFF", 200)

local closeBtn = createButton("CloseBtn", "X", 0)
closeBtn.Size = UDim2.new(0, 30, 0, 20)
closeBtn.Position = UDim2.new(1, -35, 0, 0)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
closeBtn.TextColor3 = Color3.new(1,1,1)

local minimizeBtn = createButton("MinimizeBtn", "-", 0)
minimizeBtn.Size = UDim2.new(0, 30, 0, 20)
minimizeBtn.Position = UDim2.new(1, -70, 0, 0)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
minimizeBtn.TextColor3 = Color3.new(1,1,1)

-- Авторство
local author = Instance.new("TextLabel", frame)
author.Size = UDim2.new(0, 220, 0, 20)
author.Position = UDim2.new(0,0,1,-20)
author.Text = "Автор @gde_patrick | @script_patrick"
author.TextScaled = true
author.TextColor3 = Color3.new(0,1,0)
author.BackgroundTransparency = 1

-- 🔧 Переменные
local noclipEnabled, flyEnabled, speedEnabled, contraEnabled, autoCloseEnabled = false, false, false, false, false
local minimized = false
local speedValue = 50
local flySpeed = 50

-- 🚪 NoClip
noclipBtn.MouseButton1Click:Connect(function()
    noclipEnabled = not noclipEnabled
    noclipBtn.Text = "NoClip: "..(noclipEnabled and "ON" or "OFF")
end)

runService.Stepped:Connect(function()
    if noclipEnabled and player.Character then
        for _, part in pairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)

-- 🕊 Fly
flyBtn.MouseButton1Click:Connect(function()
    local flyMenu = Instance.new("Frame", gui)
    flyMenu.Size = UDim2.new(0, 200, 0, 120)
    flyMenu.Position = UDim2.new(0.4,0,0.2,0)
    flyMenu.BackgroundColor3 = Color3.fromRGB(0,255,0)
    flyMenu.Active = true
    flyMenu.Draggable = true

    local flyToggle = createButton("FlyToggle", "Fly: OFF", 10)
    flyToggle.Parent = flyMenu

    local upBtn = createButton("UpBtn", "Up", 50)
    upBtn.Parent = flyMenu

    local downBtn = createButton("DownBtn", "Down", 90)
    downBtn.Parent = flyMenu

    flyToggle.MouseButton1Click:Connect(function()
        flyEnabled = not flyEnabled
        flyToggle.Text = "Fly: "..(flyEnabled and "ON" or "OFF")
    end)

    upBtn.MouseButton1Click:Connect(function()
        flySpeed = flySpeed + 10
    end)

    downBtn.MouseButton1Click:Connect(function()
        flySpeed = flySpeed - 10
        if flySpeed < 10 then flySpeed=10 end
    end)

    spawn(function()
        while flyMenu.Parent do
            if flyEnabled and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local dir = workspace.CurrentCamera.CFrame.lookVector
                player.Character.HumanoidRootPart.Velocity = dir * flySpeed
            end
            wait()
        end
    end)
end)

-- ⚡ SpeedHack
speedBtn.MouseButton1Click:Connect(function()
    local speedMenu = Instance.new("Frame", gui)
    speedMenu.Size = UDim2.new(0, 200, 0, 90)
    speedMenu.Position = UDim2.new(0.4,0,0.2,0)
    speedMenu.BackgroundColor3 = Color3.fromRGB(0,255,0)
    speedMenu.Active = true
    speedMenu.Draggable = true

    local toggleBtn = createButton("ToggleSpeed", "Speed: OFF", 10)
    toggleBtn.Parent = speedMenu

    local addBtn = createButton("AddSpeed", "+10", 50)
    addBtn.Parent = speedMenu
    addBtn.Position = UDim2.new(0, 100, 0, 50)

    toggleBtn.MouseButton1Click:Connect(function()
        speedEnabled = not speedEnabled
        toggleBtn.Text = "Speed: "..(speedEnabled and "ON" or "OFF")
    end)

    addBtn.MouseButton1Click:Connect(function()
        speedValue = speedValue + 10
    end)

    spawn(function()
        while speedMenu.Parent do
            if player.Character and speedEnabled then
                player.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = speedValue
            else
                player.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = 16
            end
            wait()
        end
    end)
end)

-- 🛡 Контра
contraBtn.MouseButton1Click:Connect(function()
    local contraMenu = Instance.new("Frame", gui)
    contraMenu.Size = UDim2.new(0, 200, 0, 100)
    contraMenu.Position = UDim2.new(0.4,0,0.2,0)
    contraMenu.BackgroundColor3 = Color3.fromRGB(0,255,0)
    contraMenu.Active = true
    contraMenu.Draggable = true

    local toggleBtn = createButton("ToggleContra", "Контра: OFF", 10)
    toggleBtn.Parent = contraMenu

    local clearBtn = createButton("ClearList", "Очистить список", 50)
    clearBtn.Parent = contraMenu

    toggleBtn.MouseButton1Click:Connect(function()
        contraEnabled = not contraEnabled
        toggleBtn.Text = "Контра: "..(contraEnabled and "ON" or "OFF")
    end)

    spawn(function()
        while contraMenu.Parent do
            if contraEnabled and player.Character then
                for _, target in pairs(game.Players:GetPlayers()) do
                    if target ~= player and target.Character and (target.Character.PrimaryPart.Position - player.Character.PrimaryPart.Position).Magnitude<50 then
                        local tool = player.Backpack:FindFirstChildOfClass("Tool") or player.Character:FindFirstChildOfClass("Tool")
                        if tool then
                            player.Character.HumanoidRootPart.CFrame = target.Character.PrimaryPart.CFrame + Vector3.new(0,0,2)
                            tool:Activate()
                        end
                    end
                end
            end
            wait(0.1)
        end
    end)
end)

-- 🏠 AutoClose
autoCloseBtn.MouseButton1Click:Connect(function()
    autoCloseEnabled = not autoCloseEnabled
    autoCloseBtn.Text = "Auto-Close: "..(autoCloseEnabled and "ON" or "OFF")
    if autoCloseEnabled then
        spawn(function()
            while autoCloseEnabled do
                local human = player.Character:FindFirstChildOfClass("Humanoid")
                if human then human.WalkSpeed = 100 end
                wait(0.5)
                if human then human.WalkSpeed = 16 end
                wait(1)
            end
        end)
    end
end)

-- ❌ Закрыть меню
closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- 🔽 Свернуть меню
minimizeBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    for _, child in pairs(frame:GetChildren()) do
        if child:IsA("TextButton") or child:IsA("TextLabel") then
            if child ~= closeBtn and child ~= minimizeBtn then
                child.Visible = not minimized
            end
        end
    end
end)
