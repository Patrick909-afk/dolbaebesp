-- [[🔥 Fat Script by @gde_patrick 😎]]

local plrs=game:GetService("Players")
local lp=plrs.LocalPlayer
local chr=lp.Character or lp.CharacterAdded:Wait()
local hum=chr:WaitForChild("Humanoid")
local hrp=chr:WaitForChild("HumanoidRootPart")
local rs=game:GetService("RunService")
local uis=game:GetService("UserInputService")
local cam=workspace.CurrentCamera
local tool=nil
local savedPos=nil

for _,v in ipairs(lp.Backpack:GetChildren()) do if v:IsA("Tool") then tool=v break end end

-- ⚙️ Настройки
local speed=lp.Character.Humanoid.WalkSpeed*1.1
local spin=40
local hitTime=0.02
local attacking=true
local spinning=false
local targeting=false
local stealing=false
local flying=false
local noClip=false
local teleporting=false
local target=nil
local lastHit=0
local flySpeed=50
local espEnabled=false
local espObjects={}
local minimized=false

-- 🖼 GUI
local gui=Instance.new("ScreenGui",game.CoreGui)
local fr=Instance.new("Frame",gui)
fr.Size=UDim2.new(0,400,0,400)
fr.Position=UDim2.new(0.5,-200,0.5,-200)
fr.BackgroundColor3=Color3.fromRGB(30,30,30)
fr.Active=true fr.Draggable=true

local close=Instance.new("TextButton",fr)
close.Text="❌" close.Size=UDim2.new(0,30,0,30)
close.Position=UDim2.new(1,-35,0,5)
close.BackgroundColor3=Color3.fromRGB(50,50,50)
close.TextColor3=Color3.fromRGB(255,255,255)

local mini=Instance.new("TextButton",fr)
mini.Text="⭐" mini.Size=UDim2.new(0,30,0,30)
mini.Position=UDim2.new(0,5,0,5)
mini.BackgroundColor3=Color3.fromRGB(50,50,50)
mini.TextColor3=Color3.fromRGB(255,255,255)

local title=Instance.new("TextLabel",fr)
title.Text="🔥 Fat Script Menu by @gde_patrick"
title.Size=UDim2.new(1,-80,0,30)
title.Position=UDim2.new(0,40,0,5)
title.BackgroundTransparency=1
title.TextColor3=Color3.fromRGB(255,255,255)
title.TextXAlignment=Enum.TextXAlignment.Left

local lst=Instance.new("ScrollingFrame",fr)
lst.Size=UDim2.new(0.45, -10,1,-100)
lst.Position=UDim2.new(0,5,0,40)
lst.BackgroundColor3=Color3.fromRGB(40,40,40)
lst.ScrollBarThickness=5 lst.BorderSizePixel=0

local btns=Instance.new("Frame",fr)
btns.Size=UDim2.new(0.5,-10,1,-50)
btns.Position=UDim2.new(0.5,5,0,40)
btns.BackgroundTransparency=1

local function newBtn(text,order,callback)
    local b=Instance.new("TextButton",btns)
    b.Text=text
    b.Size=UDim2.new(1,-10,0,30)
    b.Position=UDim2.new(0,5,0,(order-1)*35)
    b.BackgroundColor3=Color3.fromRGB(50,50,50)
    b.TextColor3=Color3.fromRGB(255,255,255)
    b.MouseButton1Click:Connect(callback)
    return b
end

-- 🛠 Кнопки
local tgtBtn=newBtn("🎯 Target (OFF)",1,function()
    targeting=not targeting
    tgtBtn.Text=targeting and "🎯 Target (ON)" or "🎯 Target (OFF)"
end)

local stealBtn=newBtn("🚀 Спиздить (OFF)",2,function()
    stealing=not stealing
    stealBtn.Text=stealing and "🚀 Спиздить (ON)" or "🚀 Спиздить (OFF)"
end)

local spinBtn=newBtn("🔄 Крутилка (OFF)",3,function()
    spinning=not spinning
    spinBtn.Text=spinning and "🔄 Крутилка (ON)" or "🔄 Крутилка (OFF)"
end)

local atkBtn=newBtn("⚔ Авто-атака (ON)",4,function()
    attacking=not attacking
    atkBtn.Text=attacking and "⚔ Авто-атака (ON)" or "⚔ Авто-атака (OFF)"
end)

local flyBtn=newBtn("✈ Fly (OFF)",5,function()
    flying=not flying
    flyBtn.Text=flying and "✈ Fly (ON)" or "✈ Fly (OFF)"
end)

local tpBtn=newBtn("📍 Телепорт к цели",6,function()
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        teleporting=true
        local dest=target.Character.HumanoidRootPart.Position
        coroutine.wrap(function()
            local t0=tick()
            while teleporting and (tick()-t0)<10 do
                hrp.Velocity=(dest-hrp.Position).Unit*speed
                rs.RenderStepped:Wait()
            end
            teleporting=false
        end)()
    end
end)

local saveBtn=newBtn("📍 Сохранить координаты",7,function()
    savedPos=hrp.Position
end)

local tpBaseBtn=newBtn("📍 Телепорт к базе",8,function()
    if savedPos then
        teleporting=true
        local dest=savedPos
        coroutine.wrap(function()
            local t0=tick()
            while teleporting and (tick()-t0)<10 do
                hrp.Velocity=(dest-hrp.Position).Unit*speed
                rs.RenderStepped:Wait()
            end
            teleporting=false
        end)()
    end
end)

local cancelBtn=newBtn("🛑 Отмена телепорта",9,function()
    teleporting=false
end)

local noclipBtn=newBtn("🚪 No-Clip (OFF)",10,function()
    noClip=not noClip
    noclipBtn.Text=noClip and "🚪 No-Clip (ON)" or "🚪 No-Clip (OFF)"
end)

local espBtn=newBtn("🧊 ESP (OFF)",11,function()
    espEnabled=not espEnabled
    espBtn.Text=espEnabled and "🧊 ESP (ON)" or "🧊 ESP (OFF)"
end)

-- 📦 Список игроков
local function refreshPlayers()
    lst:ClearAllChildren()
    local y=0
    for _,p in ipairs(plrs:GetPlayers()) do
        if p~=lp then
            local b=Instance.new("TextButton",lst)
            b.Text=(target==p and "✅ " or "")..p.Name
            b.Size=UDim2.new(1,-5,0,25)
            b.Position=UDim2.new(0,0,0,y)
            b.BackgroundColor3=target==p and Color3.fromRGB(0,150,0) or Color3.fromRGB(60,60,60)
            b.TextColor3=Color3.fromRGB(255,255,255)
            b.MouseButton1Click:Connect(function()
                target=p
                refreshPlayers()
            end)
            y=y+26
        end
    end
    lst.CanvasSize=UDim2.new(0,0,0,y)
end
refreshPlayers()
plrs.PlayerAdded:Connect(refreshPlayers)
plrs.PlayerRemoving:Connect(refreshPlayers)

-- ✨ ESP функция
local function updateESP()
    for _,obj in pairs(espObjects) do obj:Destroy() end
    table.clear(espObjects)
    if not espEnabled then return end
    for _,p in ipairs(plrs:GetPlayers()) do
        if p~=lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local box=Instance.new("BoxHandleAdornment")
            box.Size=Vector3.new(4,6,2)
            box.Adornee=p.Character.HumanoidRootPart
            box.Color3=Color3.fromRGB(0,255,0)
            box.AlwaysOnTop=true
            box.ZIndex=10
            box.Parent=gui
            table.insert(espObjects,box)
        end
    end
end

-- 🚀 Логика
rs.RenderStepped:Connect(function()
    if attacking and tick()-lastHit>hitTime and tool then lastHit=tick() tool:Activate() end
    if spinning then hrp.CFrame=hrp.CFrame*CFrame.Angles(0,math.rad(spin),0) end
    if stealing then hrp.Velocity=Vector3.new(0,100,0) end
    if flying then
        local move=Vector3.new()
        if uis:IsKeyDown(Enum.KeyCode.W) then move=move+cam.CFrame.LookVector end
        if uis:IsKeyDown(Enum.KeyCode.S) then move=move-cam.CFrame.LookVector end
        if uis:IsKeyDown(Enum.KeyCode.A) then move=move-cam.CFrame.RightVector end
        if uis:IsKeyDown(Enum.KeyCode.D) then move=move+cam.CFrame.RightVector end
        hrp.Velocity=move.Unit*flySpeed
    end
    if noClip then for _,v in pairs(chr:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide=false end end end
    updateESP()
end)

close.MouseButton1Click:Connect(function() gui:Destroy() attacking=false spinning=false stealing=false targeting=false flying=false espEnabled=false teleporting=false end)

mini.MouseButton1Click:Connect(function()
    minimized=not minimized
    for _,v in pairs(fr:GetChildren()) do if v~=mini and v~=close then v.Visible=not minimized end end
    fr.Size=minimized and UDim2.new(0,70,0,40) or UDim2.new(0,400,0,400)
end)
