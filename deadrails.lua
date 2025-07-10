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
for _,v in ipairs(lp.Backpack:GetChildren()) do if v:IsA("Tool") then tool=v break end end

-- ⚙️ Настройки
local attacking, spinning, targeting, stealing, flyMode, noclip, espOn = false,false,false,false,false,false,false
local speed=16*1.1 -- чуть быстрее стандартной
local spin=50
local hitTime=0.02
local target=nil
local savedCoords=nil
local lastHit=0
local espFolder=Instance.new("Folder",workspace)
espFolder.Name="ESP_PATRICK"
local pages={"⚔ Бой","🧭 ТП & Fly","👁 ESP & Прочее"}
local currentPage=1

-- 🖼 GUI
local gui=Instance.new("ScreenGui",game.CoreGui)
local fr=Instance.new("Frame",gui)
fr.Size=UDim2.new(0,400,0,300)
fr.Position=UDim2.new(0.5,-200,0.5,-150)
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
title.Text="🔥 Fat Script by @gde_patrick" title.Size=UDim2.new(1,-80,0,30)
title.Position=UDim2.new(0,40,0,5)
title.BackgroundTransparency=1 title.TextColor3=Color3.fromRGB(255,255,255)
title.TextXAlignment=Enum.TextXAlignment.Left

local lst=Instance.new("ScrollingFrame",fr)
lst.Size=UDim2.new(1,-10,1,-60)
lst.Position=UDim2.new(0,5,0,40)
lst.BackgroundColor3=Color3.fromRGB(40,40,40)
lst.ScrollBarThickness=5 lst.BorderSizePixel=0
lst.CanvasSize=UDim2.new()

local prev=Instance.new("TextButton",fr)
prev.Text="⬅" prev.Size=UDim2.new(0,30,0,30)
prev.Position=UDim2.new(0,40,1,-35)
prev.BackgroundColor3=Color3.fromRGB(50,50,50)
prev.TextColor3=Color3.fromRGB(255,255,255)

local nxt=Instance.new("TextButton",fr)
nxt.Text="➡" nxt.Size=UDim2.new(0,30,0,30)
nxt.Position=UDim2.new(1,-70,1,-35)
nxt.BackgroundColor3=Color3.fromRGB(50,50,50)
nxt.TextColor3=Color3.fromRGB(255,255,255)

local pg=Instance.new("TextLabel",fr)
pg.Text=pages[currentPage]
pg.Size=UDim2.new(0,80,0,30)
pg.Position=UDim2.new(0.5,-40,1,-35)
pg.BackgroundTransparency=1
pg.TextColor3=Color3.fromRGB(255,255,255)

-- 📦 Функции для кнопок
local function updatePage()
    lst:ClearAllChildren()
    local y=0
    local function addBtn(txt,func)
        local b=Instance.new("TextButton",lst)
        b.Text=txt b.Size=UDim2.new(1,-5,0,30)
        b.Position=UDim2.new(0,0,0,y)
        b.BackgroundColor3=Color3.fromRGB(60,60,60)
        b.TextColor3=Color3.fromRGB(255,255,255)
        b.MouseButton1Click:Connect(func)
        y=y+32
    end
    if currentPage==1 then
        addBtn((attacking and "⚔ Авто-атака (ON)" or "⚔ Авто-атака (OFF)"),function()
            attacking=not attacking
            updatePage()
        end)
        addBtn((spinning and "🔄 Крутилка (ON)" or "🔄 Крутилка (OFF)"),function()
            spinning=not spinning
            updatePage()
        end)
        addBtn((stealing and "🚀 Спиздить (ON)" or "🚀 Спиздить (OFF)"),function()
            stealing=not stealing
            updatePage()
        end)
        addBtn((targeting and "🎯 Target (ON)" or "🎯 Target (OFF)"),function()
            targeting=not targeting
            updatePage()
        end)
    elseif currentPage==2 then
        addBtn((flyMode and "✈ Fly (ON)" or "✈ Fly (OFF)"),function()
            flyMode=not flyMode
            updatePage()
        end)
        addBtn("📍 Сохранить координаты",function()
            savedCoords=hrp.Position
        end)
        addBtn("📍 Телепорт к базе",function()
            if savedCoords then target=nil targeting=false stealing=false
                coroutine.wrap(function()
                    local pos=savedCoords
                    while (hrp.Position-pos).Magnitude>5 do
                        hrp.Velocity=(pos-hrp.Position).Unit*16*1.15
                        wait()
                    end
                    hrp.Velocity=Vector3.new()
                end)()
            end
        end)
        addBtn("🧭 Телепорт к цели",function()
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                local pos=target.Character.HumanoidRootPart.Position
                coroutine.wrap(function()
                    while (hrp.Position-pos).Magnitude>5 do
                        hrp.Velocity=(pos-hrp.Position).Unit*16*1.15
                        wait()
                    end
                    hrp.Velocity=Vector3.new()
                end)()
            end
        end)
        addBtn((noclip and "🚪 NoClip (ON)" or "🚪 NoClip (OFF)"),function()
            noclip=not noclip
            updatePage()
        end)
    elseif currentPage==3 then
        addBtn((espOn and "👁 ESP (ON)" or "👁 ESP (OFF)"),function()
            espOn=not espOn
            updatePage()
        end)
        -- Список игроков
        for _,p in ipairs(plrs:GetPlayers()) do
            if p~=lp then
                local b=Instance.new("TextButton",lst)
                b.Text=((target==p and "✅ " or "")..p.Name)
                b.Size=UDim2.new(1,-5,0,25)
                b.Position=UDim2.new(0,0,0,y)
                b.BackgroundColor3=Color3.fromRGB(60,60,60)
                b.TextColor3=Color3.fromRGB(255,255,255)
                b.MouseButton1Click:Connect(function()
                    target=p
                    updatePage()
                end)
                y=y+27
            end
        end
    end
    lst.CanvasSize=UDim2.new(0,0,0,y)
    pg.Text=pages[currentPage]
end
updatePage()

-- 🧠 ESP
local function updateESP()
    for _,v in pairs(espFolder:GetChildren()) do v:Destroy() end
    if espOn then
        for _,p in ipairs(plrs:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p~=lp then
                local box=Instance.new("BoxHandleAdornment",espFolder)
                box.Adornee=p.Character
                box.Size=Vector3.new(4,6,2)
                box.Color3=Color3.new(1,0,0)
                box.AlwaysOnTop=true
                box.ZIndex=5
                local txt=Instance.new("BillboardGui",espFolder)
                txt.Adornee=p.Character.HumanoidRootPart
                txt.Size=UDim2.new(0,100,0,20)
                txt.AlwaysOnTop=true
                local lbl=Instance.new("TextLabel",txt)
                lbl.Size=UDim2.new(1,0,1,0)
                lbl.Text=string.format("%s | %dm",p.Name,math.floor((p.Character.HumanoidRootPart.Position-hrp.Position).Magnitude))
                lbl.BackgroundTransparency=1
                lbl.TextColor3=Color3.new(1,1,1)
                lbl.TextScaled=true
            end
        end
    end
end

-- 🚀 Логика
rs.RenderStepped:Connect(function()
    if attacking and tick()-lastHit>hitTime and tool then lastHit=tick() tool:Activate() end
    if spinning then hrp.CFrame=hrp.CFrame*CFrame.Angles(0,math.rad(spin),0) end
    if stealing then hrp.Velocity=Vector3.new(0,60,0) end
    if flyMode then
        local dir=Vector3.zero
        if uis:IsKeyDown(Enum.KeyCode.W) then dir=dir+cam.CFrame.LookVector end
        if uis:IsKeyDown(Enum.KeyCode.S) then dir=dir-cam.CFrame.LookVector end
        if uis:IsKeyDown(Enum.KeyCode.A) then dir=dir-cam.CFrame.RightVector end
        if uis:IsKeyDown(Enum.KeyCode.D) then dir=dir+cam.CFrame.RightVector end
        if uis:IsKeyDown(Enum.KeyCode.Space) then dir=dir+Vector3.new(0,1,0) end
        if uis:IsKeyDown(Enum.KeyCode.LeftControl) then dir=dir+Vector3.new(0,-1,0) end
        hrp.Velocity=dir.Unit*speed*1.2
    end
    if targeting and target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        local pos=target.Character.HumanoidRootPart.Position
        hrp.Velocity=(pos-hrp.Position).Unit*speed
    end
    if noclip then
        for _,v in pairs(chr:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide=false end
        end
    end
    if espOn then updateESP() end
end)

-- 🛠 Кнопки
close.MouseButton1Click:Connect(function() gui:Destroy() attacking=false spinning=false stealing=false flyMode=false targeting=false noclip=false espOn=false end)
mini.MouseButton1Click:Connect(function()
    fr.Visible=not fr.Visible
end)
prev.MouseButton1Click:Connect(function()
    currentPage=currentPage-1 if currentPage<1 then currentPage=#pages end updatePage()
end)
nxt.MouseButton1Click:Connect(function()
    currentPage=currentPage+1 if currentPage>#pages then currentPage=1 end updatePage()
end)

-- ♻ Перезагрузка при смерти
lp.CharacterAdded:Connect(function(c)
    chr=c hum=chr:WaitForChild("Humanoid") hrp=chr:WaitForChild("HumanoidRootPart")
end)

-- Готово! Всё работает 🚀
