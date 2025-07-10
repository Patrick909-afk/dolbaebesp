-- [[🔥 Fat Script by You 😎]]
local plrs = game:GetService("Players")
local lp = plrs.LocalPlayer
local chr = lp.Character or lp.CharacterAdded:Wait()
local hum = chr:WaitForChild("Humanoid")
local hrp = chr:WaitForChild("HumanoidRootPart")
local rs = game:GetService("RunService")
local tool = nil
for _,v in ipairs(lp.Backpack:GetChildren()) do
    if v:IsA("Tool") then tool = v break end
end

-- ⚙️ Настройки
local speed = hum.WalkSpeed * 1.1
local spin = 40
local hitTime = 0.02
local attacking = true
local spinning = true
local targeting = false
local stealing = false
local minimized = false
local target = nil
local lastHit = 0

-- 🖼 GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
local fr = Instance.new("Frame", gui)
fr.Size = UDim2.new(0, 240, 0, 360)
fr.Position = UDim2.new(0.5, -120, 0.5, -180)
fr.BackgroundColor3 = Color3.fromRGB(30,30,30)
fr.Active = true fr.Draggable = true

local close = Instance.new("TextButton", fr)
close.Text = "❌" close.Size = UDim2.new(0,30,0,30)
close.Position = UDim2.new(1,-35,0,5)
close.BackgroundColor3 = Color3.fromRGB(50,50,50)
close.TextColor3 = Color3.fromRGB(255,255,255)

local mini = Instance.new("TextButton", fr)
mini.Text = "⭐" mini.Size = UDim2.new(0,30,0,30)
mini.Position = UDim2.new(0,5,0,5)
mini.BackgroundColor3 = Color3.fromRGB(50,50,50)
mini.TextColor3 = Color3.fromRGB(255,255,255)

local title = Instance.new("TextLabel", fr)
title.Text = "🔥 Fat Script Menu"
title.Size = UDim2.new(1,-80,0,30)
title.Position = UDim2.new(0,40,0,5)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(255,255,255)
title.TextXAlignment = Enum.TextXAlignment.Left

local lst = Instance.new("ScrollingFrame", fr)
lst.Size = UDim2.new(1,-10,1,-100)
lst.Position = UDim2.new(0,5,0,40)
lst.BackgroundColor3 = Color3.fromRGB(40,40,40)
lst.ScrollBarThickness = 5 lst.BorderSizePixel = 0

local tgtBtn = Instance.new("TextButton", fr)
tgtBtn.Text = "🎯 Target (OFF)"
tgtBtn.Size = UDim2.new(1,-10,0,30)
tgtBtn.Position = UDim2.new(0,5,1,-55)
tgtBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
tgtBtn.TextColor3 = Color3.fromRGB(255,255,255)

local steal = Instance.new("TextButton", fr)
steal.Text = "🚀 Спиздить (OFF)"
steal.Size = UDim2.new(1,-10,0,30)
steal.Position = UDim2.new(0,5,1,-20)
steal.BackgroundColor3 = Color3.fromRGB(50,50,50)
steal.TextColor3 = Color3.fromRGB(255,255,255)

-- 📦 Обновление списка игроков
local function refresh()
    lst:ClearAllChildren()
    local y=0
    for _,p in ipairs(plrs:GetPlayers()) do
        if p ~= lp then
            local b = Instance.new("TextButton", lst)
            b.Text = (target==p and "✅ " or "")..p.Name
            b.Size = UDim2.new(1,-5,0,25)
            b.Position = UDim2.new(0,0,0,y)
            b.BackgroundColor3 = Color3.fromRGB(60,60,60)
            b.TextColor3 = Color3.fromRGB(255,255,255)
            b.MouseButton1Click:Connect(function()
                target = (target==p and nil or p)
                refresh()
            end)
            y = y + 26
        end
    end
    lst.CanvasSize = UDim2.new(0,0,0,y)
end
refresh()
plrs.PlayerAdded:Connect(refresh)
plrs.PlayerRemoving:Connect(refresh)

-- 🚀 Логика
rs.RenderStepped:Connect(function()
    -- Автоудары
    if attacking and tick()-lastHit>hitTime and tool then
        lastHit=tick()
        tool:Activate()
        -- Сильно отбрасываем цель
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            target.Character.HumanoidRootPart.Velocity = Vector3.new(999,999,999)
        end
    end
    -- Крутилка
    if spinning then hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(spin), 0) end
    -- "Спиздить": летим вверх лёжа
    if stealing then
        hrp.Velocity = Vector3.new(0,100,0)
        hrp.CFrame = hrp.CFrame * CFrame.Angles(math.rad(90),0,0)
    end
    -- Таргетинг
    if targeting and target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        local pos = target.Character.HumanoidRootPart.Position
        hrp.Velocity = (pos - hrp.Position).Unit * speed
    end
end)

-- 🛠 Кнопки
close.MouseButton1Click:Connect(function() gui:Destroy() end)

mini.MouseButton1Click:Connect(function()
    minimized = not minimized
    for _,v in pairs(fr:GetChildren()) do
        if v~=mini and v~=close then v.Visible = not minimized end
    end
    fr.Size = minimized and UDim2.new(0,60,0,40) or UDim2.new(0,240,0,360)
end)

tgtBtn.MouseButton1Click:Connect(function()
    targeting = not targeting
    tgtBtn.Text = targeting and "🎯 Target (ON)" or "🎯 Target (OFF)"
end)

steal.MouseButton1Click:Connect(function()
    stealing = not stealing
    steal.Text = stealing and "🚀 Спиздить (ON)" or "🚀 Спиздить (OFF)"
end)
