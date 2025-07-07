local player = game.Players.LocalPlayer
local runService = game:GetService("RunService")
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.ResetOnSpawn = false

-- 🌟 Основная рамка
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 220, 0, 220)
frame.Position = UDim2.new(0.4,0,0.4,0)
frame.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
frame.BackgroundTransparency = 0.3
frame.Active = true
frame.Draggable = true

local stroke = Instance.new("UIStroke", frame)
stroke.Color = Color3.fromRGB(0,255,0)
stroke.Thickness = 2

-- 🌟 Кнопки
local function createButton(name, text, posY)
    local btn = Instance.new("TextButton", frame)
    btn.Name = name
    btn.Size = UDim2.new(0, 200, 0, 30)
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

local closeBtn = createButton("CloseBtn", "X", 0)
closeBtn.Size = UDim2.new(0, 30, 0, 20)
closeBtn.Position = UDim2.new(1, -35, 0, 0)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
closeBtn.TextColor3 = Color3.new(1,1,1)

-- Авторство
local author = Instance.new("TextLabel", frame)
author.Size = UDim2.new(0, 220, 0, 20)
author.Position = UDim2.new(0,0,1,-20)
author.Text = "Автор @gde_patrick | Подпишись @script_patrick"
author.TextScaled = true
author.TextColor3 = Color3.new(0,1,0)
author.BackgroundTransparency = 1

-- 🔧 Переменные
local noclipEnabled = false
local espEnabled = false
local bondFarmEnabled = false
local killAuraEnabled = false
local espLabels = {}
local collected = 0

-- 🚪 NoClip
noclipBtn.MouseButton1Click:Connect(function()
    noclipEnabled = not noclipEnabled
    noclipBtn.Text = "NoClip: " .. (noclipEnabled and "ON" or "OFF")
end)

runService.Stepped:Connect(function()
    if noclipEnabled and player.Character then
        for _, part in pairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- 🚂 ESP поездов
espBtn.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    espBtn.Text = "ESP Trains: " .. (espEnabled and "ON" or "OFF")
    if not espEnabled then
        for _, lbl in pairs(espLabels) do lbl:Destroy() end
        espLabels = {}
    else
        spawn(function()
            while espEnabled do
                for _, lbl in pairs(espLabels) do lbl:Destroy() end
                espLabels = {}
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj:IsA("Model") and obj:FindFirstChild("TrainPart") then
                        local dist = (player.Character.HumanoidRootPart.Position - obj.PrimaryPart.Position).Magnitude
                        local bb = Instance.new("BillboardGui", obj)
                        bb.Size = UDim2.new(0,40,0,20)
                        bb.Adornee = obj.PrimaryPart or obj:FindFirstChild("TrainPart")
                        bb.AlwaysOnTop = true
                        bb.MaxDistance = 500
                        local txt = Instance.new("TextLabel", bb)
                        txt.Size = UDim2.new(1,0,1,0)
                        txt.Text = "🚂 "..math.floor(dist).."m"
                        txt.TextColor3 = Color3.new(0,1,0)
                        txt.BackgroundTransparency = 1
                        txt.TextScaled = true
                        table.insert(espLabels, bb)
                    end
                end
                wait(1)
            end
        end)
    end
end)

-- 🪙 Фарм облигаций
bondFarmBtn.MouseButton1Click:Connect(function()
    bondFarmEnabled = not bondFarmEnabled
    bondFarmBtn.Text = "Farm Bonds: " .. (bondFarmEnabled and "ON" or "OFF")
    if bondFarmEnabled then
        local blackScreen = Instance.new("Frame", gui)
        blackScreen.Size = UDim2.new(1,0,1,0)
        blackScreen.BackgroundColor3 = Color3.new(0,0,0)
        blackScreen.BackgroundTransparency = 0
        local counter = Instance.new("TextLabel", blackScreen)
        counter.Size = UDim2.new(0,300,0,50)
        counter.Position = UDim2.new(0.5,-150,0.1,0)
        counter.TextScaled = true
        counter.TextColor3 = Color3.new(0,1,0)
        counter.BackgroundTransparency = 1
        spawn(function()
            while bondFarmEnabled do
                for _, item in pairs(workspace:GetDescendants()) do
                    if item.Name=="Bond" and item:IsA("BasePart") then
                        player.Character.HumanoidRootPart.CFrame = item.CFrame
                        collected = collected+1
                        counter.Text = "Собрано облигаций: "..collected
                        wait(0.2)
                    end
                end
                wait(0.5)
            end
            blackScreen:Destroy()
        end)
    end
end)

-- ⚔️ Kill Aura
killAuraBtn.MouseButton1Click:Connect(function()
    killAuraEnabled = not killAuraEnabled
    killAuraBtn.Text = "Kill Aura: " .. (killAuraEnabled and "ON" or "OFF")
    if killAuraEnabled then
        spawn(function()
            while killAuraEnabled do
                local char = player.Character
                if char then
                    local tool = char:FindFirstChildOfClass("Tool")
                    if tool then
                        for _, mob in pairs(workspace:GetDescendants()) do
                            if mob:IsA("Model") and mob:FindFirstChild("Humanoid") and not game.Players:GetPlayerFromCharacter(mob) then
                                mob.Humanoid.Health = 0
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
closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)
