-- [[🔥 Fat Script by @gde_patrick 😎]]
local plrs=game:GetService("Players")
local lp=plrs.LocalPlayer
local chr=lp.Character or lp.CharacterAdded:Wait()
local hum=chr:WaitForChild("Humanoid")
local hrp=chr:WaitForChild("HumanoidRootPart")
local rs=game:GetService("RunService")
local tool=nil
for _,v in ipairs(lp.Backpack:GetChildren()) do if v:IsA("Tool") then tool=v break end end

-- ⚙️ Настройки
local speed=hum.WalkSpeed*1.15 -- Чуть быстрее остальных
local hitTime=0.02
local attacking=true
local spinning=true
local targeting=false
local stealing=false
local espPlayers=false
local tpToTarget=false
local minimized=false
local target=nil
local lastHit=0
local stopped=false

-- ESP
local espFolder=Instance.new("Folder",game.CoreGui)
espFolder.Name="ESPFolder"

-- 🖼 GUI
local gui=Instance.new("ScreenGui",game.CoreGui)
local fr=Instance.new("Frame",gui)
fr.Size=UDim2.new(0,240,0,500)
fr.Position=UDim2.new(0.5,-120,0.5,-250)
fr.BackgroundColor3=Color3.fromRGB(30,30,30)
fr.Active=true fr.Draggable=true

local function newBtn(text,posY)
    local btn=Instance.new("TextButton",fr)
    btn.Text=text
    btn.Size=UDim2.new(1,-10,0,30)
    btn.Position=UDim2.new(0,5,0,posY)
    btn.BackgroundColor3=Color3.fromRGB(50,50,50)
    btn.TextColor3=Color3.fromRGB(255,255,255)
    return btn
end

local close=newBtn("❌",5)
close.Size=UDim2.new(0,30,0,30)
close.Position=UDim2.new(1,-35,0,5)

local mini=newBtn("⭐",5)
mini.Size=UDim2.new(0,30,0,30)
mini.Position=UDim2.new(0,5,0,5)

local title=Instance.new("TextLabel",fr)
title.Text="🔥 Fat Script Menu by @gde_patrick"
title.Size=UDim2.new(1,-80,0,30)
title.Position=UDim2.new(0,40,0,5)
title.BackgroundTransparency=1
title.TextColor3=Color3.fromRGB(255,255,255)
title.TextXAlignment=Enum.TextXAlignment.Left

local lst=Instance.new("ScrollingFrame",fr)
lst.Size=UDim2.new(1,-10,0,200)
lst.Position=UDim2.new(0,5,0,40)
lst.BackgroundColor3=Color3.fromRGB(40,40,40)
lst.ScrollBarThickness=5 lst.BorderSizePixel=0

local tgtBtn=newBtn("🎯 Target (OFF)",245)
local stealBtn=newBtn("🚀 Спиздить (OFF)",280)
local spinBtn=newBtn("🌀 Крутилка (ON)",315)
local atkBtn=newBtn("⚔️ Авто-атака (ON)",350)
local espBtn=newBtn("👁️ ESP Players (OFF)",385)
local tpBtn=newBtn("⚡ Телепорт к цели",420)

-- 📦 Обновление списка игроков
local function refresh()
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
                if target==p then target=nil else target=p end
                refresh()
            end)
            y=y+26
        end
    end
    lst.CanvasSize=UDim2.new(0,0,0,y)
end
refresh()
plrs.PlayerAdded:Connect(refresh)
plrs.PlayerRemoving:Connect(refresh)

-- 🚀 Логика
local conn
conn=rs.RenderStepped:Connect(function()
    if stopped then return end

    -- Автоатака
    if attacking and tool and tick()-lastHit>hitTime then lastHit=tick() tool:Activate() end

    -- Крутилка
    if spinning then hrp.CFrame=hrp.CFrame*CFrame.Angles(0,math.rad(40),0) end

    -- Таргетинг
    if targeting and target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        local pos=target.Character.HumanoidRootPart.Position
        hrp.Velocity=(pos-hrp.Position).Unit*speed
    end

    -- Спиздить: поднимаемся и управляем
    if stealing then
        hum.PlatformStand=true
        local move=Vector3.zero
        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.W) then move=move+hrp.CFrame.LookVector end
        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.S) then move=move-hrp.CFrame.LookVector end
        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.A) then move=move-hrp.CFrame.RightVector end
        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.D) then move=move+hrp.CFrame.RightVector end
        hrp.Velocity=move*speed+Vector3.new(0,30,0)
    else
        hum.PlatformStand=false
    end

    -- Телепорт к цели
    if tpToTarget and target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        local pos=target.Character.HumanoidRootPart.Position
        local dist=(hrp.Position-pos).Magnitude
        if dist>5 then hrp.CFrame=hrp.CFrame:Lerp(CFrame.new(pos+Vector3.new(0,2,0)),0.3)
        else tpToTarget=false end
    end

    -- ESP
    if espPlayers then
        for _,v in ipairs(espFolder:GetChildren()) do v:Destroy() end
        for _,p in ipairs(plrs:GetPlayers()) do
            if p~=lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChildOfClass("Humanoid").Health>0 then
                local box=Instance.new("BoxHandleAdornment",espFolder)
                box.Adornee=p.Character.HumanoidRootPart
                box.Size=Vector3.new(4,6,2)
                box.Color3=Color3.new(1,0,0)
                box.Transparency=0.5
                box.AlwaysOnTop=true
            end
        end
    else
        for _,v in ipairs(espFolder:GetChildren()) do v:Destroy() end
    end
end)

-- 🛠 Кнопки
close.MouseButton1Click:Connect(function()
    gui:Destroy()
    stopped=true
    if conn then conn:Disconnect() end
    espFolder:Destroy()
end)

mini.MouseButton1Click:Connect(function()
    minimized=not minimized
    if minimized then
        for _,v in pairs(fr:GetChildren()) do if v~=mini and v~=close then v.Visible=false end end
        fr.Size=UDim2.new(0,60,0,40)
    else
        for _,v in pairs(fr:GetChildren()) do v.Visible=true end
        fr.Size=UDim2.new(0,240,0,500)
    end
end)

tgtBtn.MouseButton1Click:Connect(function()
    targeting=not targeting
    tgtBtn.Text=targeting and "🎯 Target (ON)" or "🎯 Target (OFF)"
end)

stealBtn.MouseButton1Click:Connect(function()
    stealing=not stealing
    stealBtn.Text=stealing and "🚀 Спиздить (ON)" or "🚀 Спиздить (OFF)"
end)

spinBtn.MouseButton1Click:Connect(function()
    spinning=not spinning
    spinBtn.Text=spinning and "🌀 Крутилка (ON)" or "🌀 Крутилка (OFF)"
end)

atkBtn.MouseButton1Click:Connect(function()
    attacking=not attacking
    atkBtn.Text=attacking and "⚔️ Авто-атака (ON)" or "⚔️ Авто-атака (OFF)"
end)

espBtn.MouseButton1Click:Connect(function()
    espPlayers=not espPlayers
    espBtn.Text=espPlayers and "👁️ ESP Players (ON)" or "👁️ ESP Players (OFF)"
end)

tpBtn.MouseButton1Click:Connect(function()
    if target then tpToTarget=true end
end)

--🔥 Готово! Всё вернул и добавил 😎
