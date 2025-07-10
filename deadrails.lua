-- [[🔥 Fat Script by @gde_patrick 😎]]
local plrs = game:GetService("Players")
local lp = plrs.LocalPlayer
local chr = lp.Character or lp.CharacterAdded:Wait()
local hum = chr:WaitForChild("Humanoid")
local hrp = chr:WaitForChild("HumanoidRootPart")
local rs = game:GetService("RunService")
local uis = game:GetService("UserInputService")
local cam = workspace.CurrentCamera

local tool = nil
for _,v in ipairs(lp.Backpack:GetChildren()) do
    if v:IsA("Tool") then tool = v break end
end

-- ⚙️ Настройки
local speed = 1.15  -- Fly/Target speed
local spinSpeed = 80
local hitTime = 0.01
local attacking, spinning, targeting, stealing, flying, espEnabled = false, false, false, false, false, false
local minimized = false
local savedPos = nil
local target = nil
local lastHit = 0
local espObjects = {}

-- 🖼 GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
local fr = Instance.new("Frame", gui)
fr.Size = UDim2.new(0, 400, 0, 300)  -- шире меню
fr.Position = UDim2.new(0.5, -200, 0.5, -150)
fr.BackgroundColor3 = Color3.fromRGB(30,30,30)
fr.Active = true
fr.Draggable = true

local title = Instance.new("TextLabel", fr)
title.Text = "🔥 Fat Script Menu by @gde_patrick"
title.Size = UDim2.new(1, -40, 0, 30)
title.Position = UDim2.new(0, 20, 0, 5)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(255,255,255)
title.TextXAlignment = Enum.TextXAlignment.Left

local close = Instance.new("TextButton", fr)
close.Text = "❌"
close.Size = UDim2.new(0,30,0,30)
close.Position = UDim2.new(1,-35,0,5)
close.BackgroundColor3 = Color3.fromRGB(50,50,50)
close.TextColor3 = Color3.fromRGB(255,255,255)

local mini = Instance.new("TextButton", fr)
mini.Text = "⭐"
mini.Size = UDim2.new(0,30,0,30)
mini.Position = UDim2.new(0,5,0,5)
mini.BackgroundColor3 = Color3.fromRGB(50,50,50)
mini.TextColor3 = Color3.fromRGB(255,255,255)

-- Кнопки функций
local buttons = {}
local function addButton(text, order, callback)
    local btn = Instance.new("TextButton", fr)
    btn.Text = text.." (OFF)"
    btn.Size = UDim2.new(0.48, -10, 0, 25)
    btn.Position = UDim2.new((order%2)*0.5+0.01,0,0,40+math.floor(order/2)*28)
    btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.MouseButton1Click:Connect(function()
        callback(btn)
    end)
    table.insert(buttons, btn)
end

-- 🎯 Target ON/OFF
addButton("🎯 Target",0,function(btn)
    targeting = not targeting
    btn.Text = targeting and "🎯 Target (ON)" or "🎯 Target (OFF)"
end)

-- 🚀 Спиздить ON/OFF
addButton("🚀 Спиздить",1,function(btn)
    stealing = not stealing
    btn.Text = stealing and "🚀 Спиздить (ON)" or "🚀 Спиздить (OFF)"
end)

-- 🔄 Крутилка ON/OFF
addButton("🔄 Крутилка",2,function(btn)
    spinning = not spinning
    btn.Text = spinning and "🔄 Крутилка (ON)" or "🔄 Крутилка (OFF)"
end)

-- ⚔ Авто-атака ON/OFF
addButton("⚔ Авто-атака",3,function(btn)
    attacking = not attacking
    btn.Text = attacking and "⚔ Авто-атака (ON)" or "⚔ Авто-атака (OFF)"
end)

-- ✈ Fly ON/OFF
addButton("✈ Fly",4,function(btn)
    flying = not flying
    btn.Text = flying and "✈ Fly (ON)" or "✈ Fly (OFF)"
end)

-- 🧊 ESP ON/OFF
addButton("🧊 ESP",5,function(btn)
    espEnabled = not espEnabled
    btn.Text = espEnabled and "🧊 ESP (ON)" or "🧊 ESP (OFF)"
end)

-- 📍 Сохранить координаты
addButton("📍 Save Pos",6,function()
    savedPos = hrp.Position
end)

-- 📍 Телепорт к базе
addButton("📍 To Base",7,function()
    if savedPos then
        coroutine.wrap(function()
            while (hrp.Position - savedPos).Magnitude > 5 do
                hrp.CFrame = hrp.CFrame:Lerp(CFrame.new(savedPos + Vector3.new(0,10,0)),0.1)
                wait()
            end
        end)()
    end
end)

-- 🧭 Телепорт к цели
addButton("🧭 To Target",8,function()
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        local pos = target.Character.HumanoidRootPart.Position
        coroutine.wrap(function()
            while (hrp.Position - pos).Magnitude > 5 do
                hrp.CFrame = hrp.CFrame:Lerp(CFrame.new(pos + Vector3.new(0,10,0)),0.1)
                wait()
            end
        end)()
    end
end)

-- 📦 Список игроков
local lst = Instance.new("ScrollingFrame", fr)
lst.Size = UDim2.new(1,-10,0,100)
lst.Position = UDim2.new(0,5,1,-105)
lst.BackgroundColor3 = Color3.fromRGB(40,40,40)
lst.ScrollBarThickness=5
lst.BorderSizePixel=0

local function refreshList()
    lst:ClearAllChildren()
    local y=0
    for _,p in ipairs(plrs:GetPlayers()) do
        if p~=lp then
            local b=Instance.new("TextButton",lst)
            b.Text=(target==p and "✅ " or "")..p.Name
            b.Size=UDim2.new(1,-5,0,25)
            b.Position=UDim2.new(0,0,0,y)
            b.BackgroundColor3=Color3.fromRGB(60,60,60)
            b.TextColor3=Color3.fromRGB(255,255,255)
            b.MouseButton1Click:Connect(function()
                target = (target==p) and nil or p
                refreshList()
            end)
            y=y+26
        end
    end
    lst.CanvasSize=UDim2.new(0,0,0,y)
end
refreshList()
plrs.PlayerAdded:Connect(refreshList)
plrs.PlayerRemoving:Connect(refreshList)

-- 🚀 Логика
rs.RenderStepped:Connect(function()
    -- Автоудары
    if attacking and tick()-lastHit>hitTime and tool then
        lastHit=tick()
        tool:Activate()
    end
    -- Крутилка
    if spinning then hrp.CFrame=hrp.CFrame*CFrame.Angles(0,math.rad(spinSpeed*rs.Heartbeat:Wait()),0) end
    -- Спиздить: аккуратный полёт вверх
    if stealing then hrp.Velocity=Vector3.new(0,40,0) end
    -- Target
    if targeting and target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        local pos=target.Character.HumanoidRootPart.Position
        hrp.Velocity=(pos-hrp.Position).Unit*speed*50
    end
    -- Fly
    if flying then
        local move=Vector3.zero
        if uis:IsKeyDown(Enum.KeyCode.W) then move=move+cam.CFrame.LookVector end
        if uis:IsKeyDown(Enum.KeyCode.S) then move=move-cam.CFrame.LookVector end
        if uis:IsKeyDown(Enum.KeyCode.A) then move=move-cam.CFrame.RightVector end
        if uis:IsKeyDown(Enum.KeyCode.D) then move=move+cam.CFrame.RightVector end
        hrp.Velocity=move.Unit*speed*50
    end
    -- ESP
    if espEnabled then
        for _,v in pairs(espObjects) do v:Destroy() end
        espObjects={}
        for _,p in ipairs(plrs:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local box=Instance.new("BillboardGui",gui)
                box.Size=UDim2.new(0,100,0,20)
                box.AlwaysOnTop=true
                local txt=Instance.new("TextLabel",box)
                txt.Size=UDim2.new(1,0,1,0)
                txt.BackgroundTransparency=1
                txt.Text=p.Name.." ["..math.floor((p.Character.HumanoidRootPart.Position-hrp.Position).Magnitude).."m]"
                txt.TextColor3=Color3.new(1,1,1)
                txt.TextScaled=true
                box.Adornee=p.Character.HumanoidRootPart
                table.insert(espObjects,box)
            end
        end
    end
end)

-- 🛠 Кнопки
close.MouseButton1Click:Connect(function()
    gui:Destroy()
    attacking, spinning, targeting, stealing, flying, espEnabled=false,false,false,false,false,false
end)

mini.MouseButton1Click:Connect(function()
    minimized=not minimized
    for _,v in ipairs(buttons) do v.Visible=not minimized end
    lst.Visible=not minimized
end)
