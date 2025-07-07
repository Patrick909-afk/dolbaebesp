local player = game.Players.LocalPlayer
local runService = game:GetService("RunService")
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.ResetOnSpawn = false

-- 🌟 Красивая анимация старта
local splash = Instance.new("TextLabel", gui)
splash.Size = UDim2.new(1,0,1,0)
splash.BackgroundColor3 = Color3.new(0,0,0)
splash.Text = "🌟 Loading Patrick Script... 🌟"
splash.TextScaled = true
splash.TextColor3 = Color3.new(0,1,0)
wait(2)
splash:Destroy()

-- 🌟 Меню
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 240, 0, 260)
frame.Position = UDim2.new(0.4,0,0.4,0)
frame.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
frame.BackgroundTransparency = 0.2
frame.Active = true
frame.Draggable = true

local stroke = Instance.new("UIStroke", frame)
stroke.Color = Color3.fromRGB(0,255,0)
stroke.Thickness = 2

-- 🌟 Кнопки
local function createButton(name, text, posY, sizeY)
    local btn = Instance.new("TextButton", frame)
    btn.Name = name
    btn.Size = UDim2.new(0, 220, 0, sizeY or 30)
    btn.Position = UDim2.new(0, 10, 0, posY)
    btn.Text = text
    btn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    btn.TextColor3 = Color3.new(0,0,0)
    btn.BackgroundTransparency = 0.1
    return btn
end

local noclipBtn = createButton("NoClipBtn", "NoClip: OFF", 10)
local espBtn = createButton("ESPBtn", "ESP Trains: OFF", 50)
local bondFarmBtn = createButton("BondFarmBtn", "Farm Bonds: OFF", 90)
local killAuraBtn = createButton("KillAuraBtn", "Kill Aura: OFF", 130)

local closeBtn = createButton("CloseBtn", "X", 0, 20)
closeBtn.Size = UDim2.new(0, 30, 0, 20)
closeBtn.Position = UDim2.new(1, -35, 0, 0)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
closeBtn.TextColor3 = Color3.new(1,1,1)

local minimizeBtn = createButton("MinimizeBtn", "-", 0, 20)
minimizeBtn.Size = UDim2.new(0, 30, 0, 20)
minimizeBtn.Position = UDim2.new(1, -70, 0, 0)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
minimizeBtn.TextColor3 = Color3.new(1,1,1)

-- Авторство
local author = Instance.new("TextLabel", frame)
author.Size = UDim2.new(0, 240, 0, 20)
author.Position = UDim2.new(0,0,1,-20)
author.Text = "Автор @gde_patrick | Подпишись @script_patrick"
author.TextScaled = true
author.TextColor3 = Color3.new(0,1,0)
author.BackgroundTransparency = 1

-- 🔧 Переменные
local noclipEnabled, espEnabled, bondFarmEnabled, killAuraEnabled = false,false,false,false
local espLabels, collected, minimized = {},0,false

-- 🚪 NoClip
noclipBtn.MouseButton1Click:Connect(function()
    noclipEnabled = not noclipEnabled
    noclipBtn.Text = "NoClip: "..(noclipEnabled and "ON" or "OFF")
end)
runService.Stepped:Connect(function()
    if noclipEnabled and player.Character then
        for _, part in pairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide=false end
        end
    end
end)

-- 🚂 ESP поездов
espBtn.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    espBtn.Text = "ESP Trains: "..(espEnabled and "ON" or "OFF")
    if not espEnabled then
        for _, lbl in pairs(espLabels) do lbl:Destroy() end
        espLabels = {}
    else
        spawn(function()
            while espEnabled do
                for _, lbl in pairs(espLabels) do lbl:Destroy() end
                espLabels={}
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj:IsA("Model") and obj.PrimaryPart then
                        local speed = obj.PrimaryPart.Velocity.Magnitude
                        local size = obj.PrimaryPart.Size.Magnitude
                        if speed>10 and size>10 then
                            local dist=(player.Character.HumanoidRootPart.Position - obj.PrimaryPart.Position).Magnitude
                            local bb=Instance.new("BillboardGui",obj)
                            bb.Size=UDim2.new(0,40,0,20)
                            bb.Adornee=obj.PrimaryPart
                            bb.AlwaysOnTop=true
                            bb.MaxDistance=500
                            local txt=Instance.new("TextLabel",bb)
                            txt.Size=UDim2.new(1,0,1,0)
                            txt.Text="🚂 "..math.floor(dist).."m"
                            txt.TextColor3=Color3.new(0,1,0)
                            txt.BackgroundTransparency=1
                            txt.TextScaled=true
                            table.insert(espLabels,bb)
                        end
                    end
                end
                wait(1)
            end
        end)
    end
end)

-- 🪙 Farm Bonds
bondFarmBtn.MouseButton1Click:Connect(function()
    bondFarmEnabled=not bondFarmEnabled
    bondFarmBtn.Text="Farm Bonds: "..(bondFarmEnabled and "ON" or "OFF")
    if bondFarmEnabled then
        collected=0
        local black=Instance.new("Frame",gui)
        black.Size=UDim2.new(1,0,1,0)
        black.BackgroundColor3=Color3.new(0,0,0)
        local counter=Instance.new("TextLabel",black)
        counter.Size=UDim2.new(0,300,0,50)
        counter.Position=UDim2.new(0.5,-150,0.1,0)
        counter.TextScaled=true
        counter.TextColor3=Color3.new(0,1,0)
        counter.BackgroundTransparency=1
        counter.Text="Собрано облигаций: 0"
        spawn(function()
            while bondFarmEnabled do
                local bonds={}
                for _,item in pairs(workspace:GetDescendants()) do
                    if item.Name=="Bond" and item:IsA("BasePart") then
                        table.insert(bonds,item)
                    end
                end
                if #bonds==0 then bondFarmEnabled=false;bondFarmBtn.Text="Farm Bonds: OFF";black:Destroy() break end
                for _,bond in ipairs(bonds) do
                    if not bondFarmEnabled then break end
                    player.Character.HumanoidRootPart.CFrame=bond.CFrame
                    collected=collected+1
                    counter.Text="Собрано облигаций: "..collected
                    wait(0.3)
                end
                wait(0.5)
            end
        end)
    end
end)

-- ⚔️ Kill Aura
killAuraBtn.MouseButton1Click:Connect(function()
    killAuraEnabled=not killAuraEnabled
    killAuraBtn.Text="Kill Aura: "..(killAuraEnabled and "ON" or "OFF")
    if killAuraEnabled then
        spawn(function()
            while killAuraEnabled do
                local char=player.Character
                if char then
                    local tool=char:FindFirstChildOfClass("Tool")
                    if tool and tool:FindFirstChild("Handle") then
                        for _,mob in pairs(workspace:GetDescendants()) do
                            if mob:IsA("Model") and mob:FindFirstChild("Humanoid") and not game.Players:GetPlayerFromCharacter(mob) then
                                tool:Activate()
                                wait(0.1)
                            end
                        end
                    end
                end
                wait(0.5)
            end
        end)
    end
end)

-- ❌ Закрыть меню
closeBtn.MouseButton1Click:Connect(function() gui:Destroy() end)

-- 🔽 Свернуть
minimizeBtn.MouseButton1Click:Connect(function()
    minimized=not minimized
    for _,child in pairs(frame:GetChildren()) do
        if child:IsA("TextButton") or child:IsA("TextLabel") then
            if child~=closeBtn and child~=minimizeBtn then
                child.Visible=not minimized
            end
        end
    end
end)
