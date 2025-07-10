-- 🔥 Fat Script by @gde_patrick
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
local fly=false
local spinning=false
local attacking=false
local targeting=false
local stealing=false
local target=nil
local espOn=false
local esp={}
local lastHit=0
local hitTime=0.02
local speed=16*1.15 -- чуть быстрее обычной скорости
local flySpeed=50
local minimized=false

-- 📦 GUI
local gui=Instance.new("ScreenGui",game.CoreGui)
local fr=Instance.new("Frame",gui)
fr.Size=UDim2.new(0,320,0,360)
fr.Position=UDim2.new(0.5,-160,0.5,-180)
fr.BackgroundColor3=Color3.fromRGB(30,30,30)
fr.Active=true fr.Draggable=true

local close=Instance.new("TextButton",fr)
close.Text="❌" close.Size=UDim2.new(0,30,0,30)
close.Position=UDim2.new(1,-35,0,5)
close.BackgroundColor3=Color3.fromRGB(50,50,50)

local mini=Instance.new("TextButton",fr)
mini.Text="⭐" mini.Size=UDim2.new(0,30,0,30)
mini.Position=UDim2.new(0,5,0,5)
mini.BackgroundColor3=Color3.fromRGB(50,50,50)

local lst=Instance.new("ScrollingFrame",fr)
lst.Size=UDim2.new(0.4,-10,1,-50)
lst.Position=UDim2.new(0,5,0,40)
lst.BackgroundColor3=Color3.fromRGB(40,40,40)
lst.ScrollBarThickness=5

local btns=Instance.new("Frame",fr)
btns.Size=UDim2.new(0.6,-15,1,-50)
btns.Position=UDim2.new(0.4+0.015,0,0,40)
btns.BackgroundTransparency=1

local function mkBtn(txt,y)
    local b=Instance.new("TextButton",btns)
    b.Text=txt
    b.Size=UDim2.new(1,-5,0,30)
    b.Position=UDim2.new(0,0,0,y)
    b.BackgroundColor3=Color3.fromRGB(50,50,50)
    return b
end

local btnFly=mkBtn("✈ Fly (OFF)",0)
local btnSpin=mkBtn("🔄 Крутилка (OFF)",35)
local btnAtk=mkBtn("⚔ Авто-атака (OFF)",70)
local btnEsp=mkBtn("🧊 ESP (OFF)",105)
local btnTgt=mkBtn("🎯 Target (OFF)",140)
local btnSteal=mkBtn("🚀 Спиздить (OFF)",175)
local btnTP=mkBtn("📍 Телепорт к цели",210)
local btnSave=mkBtn("💾 Сохранить coords",245)
local btnToBase=mkBtn("🚀 Телепорт к базе",280)

-- ✅ ESP функция
local function makeEsp(p)
    local box=Drawing.new("Square")
    local txt=Drawing.new("Text")
    local ln={}
    for i=1,5 do ln[i]=Drawing.new("Line") end
    esp[p]={
        box=box,text=txt,lines=ln
    }
end
local function removeEsp(p)
    if esp[p] then
        for _,o in pairs(esp[p]) do
            if typeof(o)=="table" then for _,l in pairs(o) do l:Remove() end
            else o:Remove() end
        end
        esp[p]=nil
    end
end

local function refreshPlayers()
    lst:ClearAllChildren()
    local y=0
    for _,p in ipairs(plrs:GetPlayers()) do
        if p~=lp then
            if espOn and not esp[p] then makeEsp(p) end
            local b=Instance.new("TextButton",lst)
            b.Text=(target==p and "✅ " or "")..p.Name
            b.Size=UDim2.new(1,-5,0,25)
            b.Position=UDim2.new(0,0,0,y)
            b.BackgroundColor3=Color3.fromRGB(60,60,60)
            b.MouseButton1Click:Connect(function()
                target=p
                refreshPlayers()
            end)
            y=y+26
        end
    end
    lst.CanvasSize=UDim2.new(0,0,0,y)
end
plrs.PlayerAdded:Connect(refreshPlayers)
plrs.PlayerRemoving:Connect(function(p) removeEsp(p) refreshPlayers() end)
refreshPlayers()

-- 🚀 Логика
rs.RenderStepped:Connect(function()
    chr=lp.Character or lp.CharacterAdded:Wait()
    hrp=chr:FindFirstChild("HumanoidRootPart")
    hum=chr:FindFirstChild("Humanoid")
    if not hrp or not hum then return end
    if attacking and tick()-lastHit>hitTime and tool then lastHit=tick() tool:Activate() end
    if spinning then hrp.CFrame=hrp.CFrame*CFrame.Angles(0,math.rad(40),0) end
    if stealing then hrp.Velocity=Vector3.new(0,100,0) end
    if targeting and target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        local pos=target.Character.HumanoidRootPart.Position
        hrp.CFrame=CFrame.lookAt(hrp.Position,pos)
        hrp.Velocity=(pos-hrp.Position).Unit*speed
    end
    if fly then
        local dir=cam.CFrame.LookVector
        local vel=Vector3.zero
        if uis:IsKeyDown(Enum.KeyCode.W) then vel=vel+dir end
        if uis:IsKeyDown(Enum.KeyCode.S) then vel=vel-dir end
        if uis:IsKeyDown(Enum.KeyCode.A) then vel=vel-cam.CFrame.RightVector end
        if uis:IsKeyDown(Enum.KeyCode.D) then vel=vel+cam.CFrame.RightVector end
        if uis:IsKeyDown(Enum.KeyCode.Space) then vel=vel+Vector3.new(0,1,0) end
        if uis:IsKeyDown(Enum.KeyCode.LeftShift) then vel=vel-Vector3.new(0,1,0) end
        hrp.Velocity=vel.Unit*flySpeed
    end
end)

-- 🛠 Кнопки
close.MouseButton1Click:Connect(function() gui:Destroy() for p in pairs(esp) do removeEsp(p) end end)
mini.MouseButton1Click:Connect(function()
    minimized=not minimized
    for _,v in pairs(fr:GetChildren()) do
        if v~=mini and v~=close then v.Visible=not minimized end
    end
    fr.Size=minimized and UDim2.new(0,70,0,40) or UDim2.new(0,320,0,360)
end)

btnFly.MouseButton1Click:Connect(function() fly=not fly btnFly.Text=fly and "✈ Fly (ON)" or "✈ Fly (OFF)" end)
btnSpin.MouseButton1Click:Connect(function() spinning=not spinning btnSpin.Text=spinning and "🔄 Крутилка (ON)" or "🔄 Крутилка (OFF)" end)
btnAtk.MouseButton1Click:Connect(function() attacking=not attacking btnAtk.Text=attacking and "⚔ Авто-атака (ON)" or "⚔ Авто-атака (OFF)" end)
btnEsp.MouseButton1Click:Connect(function()
    espOn=not espOn btnEsp.Text=espOn and "🧊 ESP (ON)" or "🧊 ESP (OFF)"
    if espOn then for _,p in ipairs(plrs:GetPlayers()) do if p~=lp then makeEsp(p) end end
    else for p in pairs(esp) do removeEsp(p) end end
end)
btnTgt.MouseButton1Click:Connect(function() targeting=not targeting btnTgt.Text=targeting and "🎯 Target (ON)" or "🎯 Target (OFF)" end)
btnSteal.MouseButton1Click:Connect(function() stealing=not stealing btnSteal.Text=stealing and "🚀 Спиздить (ON)" or "🚀 Спиздить (OFF)" end)
btnTP.MouseButton1Click:Connect(function()
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        local pos=target.Character.HumanoidRootPart.Position+Vector3.new(0,30,0)
        hrp.CFrame=CFrame.new(hrp.Position+Vector3.new(0,30,0))
        wait(0.1)
        hrp.CFrame=CFrame.new(pos)
    end
end)
btnSave.MouseButton1Click:Connect(function() savedPos=hrp.Position end)
btnToBase.MouseButton1Click:Connect(function()
    if savedPos then
        hrp.CFrame=CFrame.new(hrp.Position+Vector3.new(0,30,0))
        wait(0.1)
        hrp.CFrame=CFrame.new(savedPos+Vector3.new(0,30,0))
    end
end)

print("🔥 Fat Script loaded by @gde_patrick")
