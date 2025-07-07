local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local runService = game:GetService("RunService")
local uis = game:GetService("UserInputService")

-- 🌟 GUI
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 300, 0, 400)
frame.Position = UDim2.new(0.4,0,0.3,0)
frame.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
frame.BackgroundTransparency = 0.2
frame.Active = true
frame.Draggable = true

local stroke = Instance.new("UIStroke", frame)
stroke.Color = Color3.fromRGB(0,255,0)
stroke.Thickness = 3

local scroll = Instance.new("ScrollingFrame", frame)
scroll.Size = UDim2.new(1,0,1,-40)
scroll.Position = UDim2.new(0,0,0,40)
scroll.CanvasSize = UDim2.new(0,0,0,800)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 6

local minimize = Instance.new("TextButton", frame)
minimize.Text = "🌟"
minimize.Size = UDim2.new(0, 30, 0, 30)
minimize.Position = UDim2.new(1,-60,0,5)
minimize.BackgroundColor3 = Color3.fromRGB(0,200,0)
minimize.TextColor3 = Color3.new(1,1,1)

local close = Instance.new("TextButton", frame)
close.Text = "❌"
close.Size = UDim2.new(0, 30, 0, 30)
close.Position = UDim2.new(1,-30,0,5)
close.BackgroundColor3 = Color3.fromRGB(200,0,0)
close.TextColor3 = Color3.new(1,1,1)

-- 📦 ESP
local espEnabled = false
local espPlayers = true
local espMobs = true
local espTrains = true
local espBoxes = true
local espObjects = {}

local espBtn = Instance.new("TextButton", scroll)
espBtn.Text = "ESP: OFF"
espBtn.Size = UDim2.new(1,-10,0,30)
espBtn.Position = UDim2.new(0,5,0,0)
espBtn.BackgroundColor3 = Color3.fromRGB(0,150,0)
espBtn.TextColor3 = Color3.new(1,1,1)

local function createCheckbox(name, default, posY)
    local btn = Instance.new("TextButton", scroll)
    btn.Text = name..": "..(default and "✅" or "❌")
    btn.Size = UDim2.new(1,-20,0,25)
    btn.Position = UDim2.new(0,10,0,posY)
    btn.BackgroundColor3 = Color3.fromRGB(0,100,0)
    btn.TextColor3 = Color3.new(1,1,1)
    return btn
end

local chkPlayers = createCheckbox("Игроки", true, 35)
local chkMobs = createCheckbox("Мобы", true, 65)
local chkTrains = createCheckbox("Поезда", true, 95)
local chkBoxes = createCheckbox("Ящики", true, 125)

-- 🧱 NoClip
local noclipEnabled = false
local noclipBtn = Instance.new("TextButton", scroll)
noclipBtn.Text = "NoClip: OFF"
noclipBtn.Size = UDim2.new(1,-10,0,30)
noclipBtn.Position = UDim2.new(0,5,0,165)
noclipBtn.BackgroundColor3 = Color3.fromRGB(0,150,0)
noclipBtn.TextColor3 = Color3.new(1,1,1)

-- 🩹 Хитбоксы
local hitboxSize = 1
local hitboxBtn = Instance.new("TextButton", scroll)
hitboxBtn.Text = "Хитбоксы x"..hitboxSize
hitboxBtn.Size = UDim2.new(1,-10,0,30)
hitboxBtn.Position = UDim2.new(0,5,0,205)
hitboxBtn.BackgroundColor3 = Color3.fromRGB(0,150,0)
hitboxBtn.TextColor3 = Color3.new(1,1,1)

-- 🔫 Отключить перезарядку
local noreload = false
local noreloadBtn = Instance.new("TextButton", scroll)
noreloadBtn.Text = "Без перезарядки: OFF"
noreloadBtn.Size = UDim2.new(1,-10,0,30)
noreloadBtn.Position = UDim2.new(0,5,0,245)
noreloadBtn.BackgroundColor3 = Color3.fromRGB(0,150,0)
noreloadBtn.TextColor3 = Color3.new(1,1,1)

-- 🌟 Логика
espBtn.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    espBtn.Text = "ESP: "..(espEnabled and "ON" or "OFF")
    if not espEnabled then
        for _,e in pairs(espObjects) do e:Destroy() end
        espObjects = {}
    end
end)

chkPlayers.MouseButton1Click:Connect(function()
    espPlayers = not espPlayers
    chkPlayers.Text = "Игроки: "..(espPlayers and "✅" or "❌")
end)
chkMobs.MouseButton1Click:Connect(function()
    espMobs = not espMobs
    chkMobs.Text = "Мобы: "..(espMobs and "✅" or "❌")
end)
chkTrains.MouseButton1Click:Connect(function()
    espTrains = not espTrains
    chkTrains.Text = "Поезда: "..(espTrains and "✅" or "❌")
end)
chkBoxes.MouseButton1Click:Connect(function()
    espBoxes = not espBoxes
    chkBoxes.Text = "Ящики: "..(espBoxes and "✅" or "❌")
end)

noclipBtn.MouseButton1Click:Connect(function()
    noclipEnabled = not noclipEnabled
    noclipBtn.Text = "NoClip: "..(noclipEnabled and "ON" or "OFF")
end)

hitboxBtn.MouseButton1Click:Connect(function()
    hitboxSize = hitboxSize+1
    if hitboxSize>10 then hitboxSize=1 end
    hitboxBtn.Text = "Хитбоксы x"..hitboxSize
end)

noreloadBtn.MouseButton1Click:Connect(function()
    noreload = not noreload
    noreloadBtn.Text = "Без перезарядки: "..(noreload and "ON" or "OFF")
end)

close.MouseButton1Click:Connect(function() gui:Destroy() end)
local minimized = false
minimize.MouseButton1Click:Connect(function()
    minimized = not minimized
    scroll.Visible = not minimized
end)

-- 🧠 Исполнение
runService.Stepped:Connect(function()
    if noclipEnabled and player.Character then
        for _,p in pairs(player.Character:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide=false end
        end
    end
    -- Хитбоксы
    if hitboxSize>1 then
        for _,mob in pairs(workspace:GetDescendants()) do
            if mob:IsA("Model") and mob:FindFirstChild("HumanoidRootPart") then
                mob.HumanoidRootPart.Size=Vector3.new(hitboxSize,hitboxSize,hitboxSize)
                mob.HumanoidRootPart.Transparency=0.5
            end
        end
    end
end)

-- ESP
spawn(function()
    while wait(0.5) do
        if espEnabled then
            for _,e in pairs(espObjects) do e:Destroy() end
            espObjects={}
            -- Игроки
            if espPlayers then
                for _,pl in pairs(game.Players:GetPlayers()) do
                    if pl~=player and pl.Character and pl.Character:FindFirstChild("HumanoidRootPart") then
                        local dist=(player.Character.HumanoidRootPart.Position - pl.Character.HumanoidRootPart.Position).Magnitude
                        local bb=Instance.new("BillboardGui",pl.Character)
                        bb.Size=UDim2.new(0,100,0,40)
                        bb.Adornee=pl.Character.HumanoidRootPart
                        bb.AlwaysOnTop=true
                        local lbl=Instance.new("TextLabel",bb)
                        lbl.Size=UDim2.new(1,0,1,0)
                        lbl.Text=pl.Name.." "..math.floor(dist).."m"
                        lbl.TextColor3=Color3.fromRGB(0,255,0)
                        lbl.BackgroundTransparency=1
                        table.insert(espObjects,bb)
                    end
                end
            end
            -- Мобы
            if espMobs then
                for _,mob in pairs(workspace:GetDescendants()) do
                    if mob:IsA("Model") and mob:FindFirstChild("Humanoid") and not game.Players:GetPlayerFromCharacter(mob) then
                        local dist=(player.Character.HumanoidRootPart.Position - mob.PrimaryPart.Position).Magnitude
                        local bb=Instance.new("BillboardGui",mob)
                        bb.Size=UDim2.new(0,80,0,30)
                        bb.Adornee=mob.PrimaryPart
                        bb.AlwaysOnTop=true
                        local lbl=Instance.new("TextLabel",bb)
                        lbl.Size=UDim2.new(1,0,1,0)
                        lbl.Text="Mob "..math.floor(dist).."m"
                        lbl.TextColor3=Color3.fromRGB(255,0,0)
                        lbl.BackgroundTransparency=1
                        table.insert(espObjects,bb)
                    end
                end
            end
            -- Поезда
            if espTrains then
                for _,obj in pairs(workspace:GetDescendants()) do
                    if obj:IsA("Model") and obj:FindFirstChild("TrainPart") then
                        local dist=(player.Character.HumanoidRootPart.Position - obj.PrimaryPart.Position).Magnitude
                        local bb=Instance.new("BillboardGui",obj)
                        bb.Size=UDim2.new(0,80,0,30)
                        bb.Adornee=obj.PrimaryPart
                        bb.AlwaysOnTop=true
                        local lbl=Instance.new("TextLabel",bb)
                        lbl.Size=UDim2.new(1,0,1,0)
                        lbl.Text="Train "..math.floor(dist).."m"
                        lbl.TextColor3=Color3.fromRGB(0,0,255)
                        lbl.BackgroundTransparency=1
                        table.insert(espObjects,bb)
                    end
                end
            end
            -- Ящики
            if espBoxes then
                for _,box in pairs(workspace:GetDescendants()) do
                    if box:IsA("Part") and box.Name=="Box" then
                        local dist=(player.Character.HumanoidRootPart.Position - box.Position).Magnitude
                        local bb=Instance.new("BillboardGui",box)
                        bb.Size=UDim2.new(0,60,0,20)
                        bb.Adornee=box
                        bb.AlwaysOnTop=true
                        local lbl=Instance.new("TextLabel",bb)
                        lbl.Size=UDim2.new(1,0,1,0)
                        lbl.Text="Box "..math.floor(dist).."m"
                        lbl.TextColor3=Color3.fromRGB(255,255,0)
                        lbl.BackgroundTransparency=1
                        table.insert(espObjects,bb)
                    end
                end
            end
        end
    end
end)
