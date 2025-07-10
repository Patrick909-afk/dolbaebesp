-- [[🔥 Fat Script by @gde_patrick 😎]]
local plrs=game:GetService("Players")
local lp=plrs.LocalPlayer
local chr=lp.Character or lp.CharacterAdded:Wait()
local hum=chr:WaitForChild("Humanoid")
local hrp=chr:WaitForChild("HumanoidRootPart")
local rs=game:GetService("RunService")
local tool; for _,v in ipairs(lp.Backpack:GetChildren()) do if v:IsA("Tool") then tool=v break end end

-- ⚙️ Настройки
local speed=50
local flySpeed=1.15
local attacking, spinning, targeting, stealing, flying, espOn, minimized=false, false, false, false, false, false, false
local target=nil
local coords=nil
local lastHit=0
local savedPos=nil

-- 🖼 GUI
local gui=Instance.new("ScreenGui",game.CoreGui)
local fr=Instance.new("Frame",gui)
fr.Size=UDim2.new(0,400,0,300)
fr.Position=UDim2.new(0.5,-200,0.5,-150)
fr.BackgroundColor3=Color3.fromRGB(30,30,30)
fr.Active=true fr.Draggable=true

local title=Instance.new("TextLabel",fr)
title.Text="🔥 Fat Script Menu by @gde_patrick"
title.Size=UDim2.new(1,0,0,30)
title.BackgroundTransparency=1
title.TextColor3=Color3.fromRGB(255,255,255)

local function newBtn(text,pos,callback)
    local b=Instance.new("TextButton",fr)
    b.Text=text
    b.Size=UDim2.new(0.48,0,0,25)
    b.Position=pos
    b.BackgroundColor3=Color3.fromRGB(50,50,50)
    b.TextColor3=Color3.fromRGB(255,255,255)
    b.MouseButton1Click:Connect(callback)
    return b
end

local tgtBtn=newBtn("🎯 Target (OFF)",UDim2.new(0,5,0,35),function()
    targeting=not targeting
    tgtBtn.Text=targeting and "🎯 Target (ON)" or "🎯 Target (OFF)"
end)
local atkBtn=newBtn("⚔ Авто-атака (OFF)",UDim2.new(0.5,5,0,35),function()
    attacking=not attacking
    atkBtn.Text=attacking and "⚔ Авто-атака (ON)" or "⚔ Авто-атака (OFF)"
end)
local spinBtn=newBtn("🔄 Крутилка (OFF)",UDim2.new(0,5,0,65),function()
    spinning=not spinning
    spinBtn.Text=spinning and "🔄 Крутилка (ON)" or "🔄 Крутилка (OFF)"
end)
local stealBtn=newBtn("🚀 Спиздить (OFF)",UDim2.new(0.5,5,0,65),function()
    stealing=not stealing
    stealBtn.Text=stealing and "🚀 Спиздить (ON)" or "🚀 Спиздить (OFF)"
end)
local flyBtn=newBtn("✈ Fly (OFF)",UDim2.new(0,5,0,95),function()
    flying=not flying
    flyBtn.Text=flying and "✈ Fly (ON)" or "✈ Fly (OFF)"
end)
local espBtn=newBtn("🧊 ESP (OFF)",UDim2.new(0.5,5,0,95),function()
    espOn=not espOn
    espBtn.Text=espOn and "🧊 ESP (ON)" or "🧊 ESP (OFF)"
end)
local saveBtn=newBtn("📍 Сохранить координаты",UDim2.new(0,5,0,125),function()
    coords=hrp.Position
end)
local tpBaseBtn=newBtn("🚀 Телепорт к базе",UDim2.new(0.5,5,0,125),function()
    if coords then savedPos=coords end
end)
local tpTargetBtn=newBtn("🎯 Телепорт к цели",UDim2.new(0,5,0,155),function()
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        savedPos=target.Character.HumanoidRootPart.Position
    end
end)

local close=Instance.new("TextButton",fr)
close.Text="❌"
close.Size=UDim2.new(0,30,0,25)
close.Position=UDim2.new(1,-35,0,5)
close.BackgroundColor3=Color3.fromRGB(50,50,50)
close.TextColor3=Color3.fromRGB(255,255,255)
close.MouseButton1Click:Connect(function() gui:Destroy() attacking=false spinning=false targeting=false stealing=false flying=false espOn=false rs:ClearAllChildren() end)

local mini=Instance.new("TextButton",fr)
mini.Text="⭐"
mini.Size=UDim2.new(0,30,0,25)
mini.Position=UDim2.new(0,5,0,5)
mini.BackgroundColor3=Color3.fromRGB(50,50,50)
mini.TextColor3=Color3.fromRGB(255,255,255)
mini.MouseButton1Click:Connect(function()
    minimized=not minimized
    for _,v in pairs(fr:GetChildren()) do
        if v~=mini and v~=close and v~=title then v.Visible=not minimized end
    end
    fr.Size=minimized and UDim2.new(0,70,0,35) or UDim2.new(0,400,0,300)
end)

-- 📦 ESP
local esp={}
local function updateESP()
    for _,v in pairs(esp) do if v.Box then v.Box:Destroy() end if v.Name then v.Name:Destroy() end if v.Dist then v.Dist:Destroy() end end
    table.clear(esp)
    if not espOn then return end
    for _,p in ipairs(plrs:GetPlayers()) do
        if p~=lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local b=Drawing.new("Square")
            b.Size=Vector2.new(50,50) b.Color=Color3.new(1,1,1) b.Thickness=1 b.Filled=false
            local n=Drawing.new("Text")
            n.Text=p.Name n.Size=12 n.Color=Color3.new(1,1,1)
            local d=Drawing.new("Text")
            d.Size=12 d.Color=Color3.new(1,1,1)
            esp[#esp+1]={Player=p,Box=b,Name=n,Dist=d}
        end
    end
end
plrs.PlayerAdded:Connect(updateESP)
plrs.PlayerRemoving:Connect(updateESP)

-- 🚀 Логика
rs.RenderStepped:Connect(function()
    if attacking and tool and tick()-lastHit>0.05 then tool:Activate() lastHit=tick() end
    if spinning and chr and hrp then hrp.CFrame=hrp.CFrame*CFrame.Angles(0,math.rad(60),0) end
    if stealing then hrp.Velocity=Vector3.new(0,80,0) end
    if targeting and target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        local pos=target.Character.HumanoidRootPart.Position
        hrp.Velocity=(pos-hrp.Position).Unit*speed
    end
    if flying then
        local dir=uis:IsKeyDown(Enum.KeyCode.W) and hrp.CFrame.LookVector or Vector3.zero
        hrp.Velocity=dir*speed
    end
    if savedPos then
        local vec=savedPos-hrp.Position
        if vec.Magnitude>2 then
            hrp.Velocity=vec.Unit*flySpeed*50
        else savedPos=nil end
    end
    -- ESP
    if espOn then
        for i,v in pairs(esp) do
            if v.Player.Character and v.Player.Character:FindFirstChild("HumanoidRootPart") then
                local pos=game.Workspace.CurrentCamera:WorldToViewportPoint(v.Player.Character.HumanoidRootPart.Position)
                v.Box.Position=Vector2.new(pos.X,pos.Y)
                v.Name.Position=Vector2.new(pos.X,pos.Y-15)
                local dist=(hrp.Position-v.Player.Character.HumanoidRootPart.Position).Magnitude
                v.Dist.Text=("[%.0f]"):format(dist)
                v.Dist.Position=Vector2.new(pos.X,pos.Y+15)
                v.Box.Visible,v.Name.Visible,v.Dist.Visible=true,true,true
            else v.Box.Visible,v.Name.Visible,v.Dist.Visible=false,false,false end
        end
    end
end)

updateESP()
