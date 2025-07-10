--// ⚙️ Настройки
local speed = 30          -- скорость бега
local spinSpeed = 40      -- скорость кручения
local hitRate = 0.05      -- удары каждые 0.05 сек
local jumpPower = 50      -- сила прыжка
local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local chr = lp.Character or lp.CharacterAdded:Wait()
local hum = chr:WaitForChild("Humanoid")
local hrp = chr:WaitForChild("HumanoidRootPart")
local mouse = lp:GetMouse()

--// 📦 Переменные
local target = nil
local spinning = false
local attacking = false
local stealing = false
local minimized = false
local tool = nil

--// 🛠 Ищем оружие
for _,v in ipairs(lp.Backpack:GetChildren()) do
    if v:IsA("Tool") then
        tool = v
        break
    end
end
if not tool then warn("Оружие не найдено!") end

--// 🖼 GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 220, 0, 350)
frame.Position = UDim2.new(0.5, -110, 0.5, -175)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

local close = Instance.new("TextButton", frame)
close.Text = "❌"
close.Size = UDim2.new(0,30,0,30)
close.Position = UDim2.new(1,-35,0,5)
close.BackgroundColor3 = Color3.fromRGB(40,40,40)
close.TextColor3 = Color3.fromRGB(255,255,255)

local minimize = Instance.new("TextButton", frame)
minimize.Text = "⭐"
minimize.Size = UDim2.new(0,30,0,30)
minimize.Position = UDim2.new(0,5,0,5)
minimize.BackgroundColor3 = Color3.fromRGB(40,40,40)
minimize.TextColor3 = Color3.fromRGB(255,255,255)

local title = Instance.new("TextLabel", frame)
title.Text = "🔥 Script Menu"
title.Size = UDim2.new(1,-80,0,30)
title.Position = UDim2.new(0,40,0,5)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(255,255,255)
title.TextXAlignment = Enum.TextXAlignment.Left

local playerList = Instance.new("ScrollingFrame", frame)
playerList.Size = UDim2.new(1,-10,1,-80)
playerList.Position = UDim2.new(0,5,0,40)
playerList.CanvasSize = UDim2.new(0,0,0,0)
playerList.BackgroundColor3 = Color3.fromRGB(30,30,30)
playerList.ScrollBarThickness = 5
playerList.BorderSizePixel = 0

local stealBtn = Instance.new("TextButton", frame)
stealBtn.Text = "🚀 Спиздить (OFF)"
stealBtn.Size = UDim2.new(1,-10,0,30)
stealBtn.Position = UDim2.new(0,5,1,-35)
stealBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
stealBtn.TextColor3 = Color3.fromRGB(255,255,255)

--// 📋 Функция обновления списка игроков
local function refreshPlayers()
    playerList:ClearAllChildren()
    local y = 0
    for _,p in ipairs(Players:GetPlayers()) do
        if p ~= lp then
            local btn = Instance.new("TextButton", playerList)
            btn.Text = (target==p and "✅ " or "")..p.Name
            btn.Size = UDim2.new(1, -5, 0, 25)
            btn.Position = UDim2.new(0,0,0,y)
            btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
            btn.TextColor3 = Color3.fromRGB(255,255,255)
            btn.MouseButton1Click:Connect(function()
                if target==p then
                    target=nil
                else
                    target=p
                end
                refreshPlayers()
            end)
            y = y+26
        end
    end
    playerList.CanvasSize = UDim2.new(0,0,0,y)
end
refreshPlayers()

Players.PlayerAdded:Connect(refreshPlayers)
Players.PlayerRemoving:Connect(refreshPlayers)

--// 🧲 Автоатака и крутилка
RunService.RenderStepped:Connect(function(dt)
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        local tgtPos = target.Character.HumanoidRootPart.Position
        local myPos = hrp.Position
        local dir = (tgtPos - myPos).Unit
        hrp.Velocity = dir * speed
    end
    if spinning then
        hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(spinSpeed), 0)
    end
    if attacking and tick()-lastHit>=hitRate and tool then
        lastHit=tick()
        tool:Activate()
    end
end)

--// 🛠 Кнопки
close.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

minimize.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        for _,v in pairs(frame:GetChildren()) do
            if v~=minimize and v~=close then v.Visible=false end
        end
        frame.Size=UDim2.new(0,60,0,40)
    else
        for _,v in pairs(frame:GetChildren()) do
            v.Visible=true
        end
        frame.Size=UDim2.new(0,220,0,350)
    end
end)

stealBtn.MouseButton1Click:Connect(function()
    stealing=not stealing
    stealBtn.Text= stealing and "🚀 Спиздить (ON)" or "🚀 Спиздить (OFF)"
    if stealing then
        hrp.Velocity=Vector3.new(0,ceilingFlyHeight,0)
    else
        hrp.Velocity=Vector3.zero
    end
end)

--// 🔥 Включаем автоудары и кручение
attacking=true
spinning=true
