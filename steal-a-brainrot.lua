local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

local AutoFling = false
local Tool = nil

-- Поиск тулла в рюкзаке или в руках
for _,v in pairs(LocalPlayer.Backpack:GetChildren()) do
    if v:IsA("Tool") then
        Tool = v
        break
    end
end
if not Tool and LocalPlayer.Character:FindFirstChildOfClass("Tool") then
    Tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
end

if not Tool then
    warn("Нужно взять тул в руки перед запуском!")
    return
end

-- Меню
local gui = Instance.new("ScreenGui", game.CoreGui)
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,200,0,80)
frame.Position = UDim2.new(0,100,0,100)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.Active = true
frame.Draggable = true
local uic = Instance.new("UICorner", frame)
uic.CornerRadius = UDim.new(0,8)

local btn = Instance.new("TextButton", frame)
btn.Size = UDim2.new(1,-20,0,30)
btn.Position = UDim2.new(0,10,0,10)
btn.Text = "Auto Fling: OFF"
btn.BackgroundColor3 = Color3.fromRGB(80,160,80)
btn.TextColor3 = Color3.new(1,1,1)
btn.Font = Enum.Font.Gotham
btn.TextSize = 14

local close = Instance.new("TextButton", frame)
close.Size = UDim2.new(1,-20,0,30)
close.Position = UDim2.new(0,10,0,45)
close.Text = "Close"
close.BackgroundColor3 = Color3.fromRGB(160,80,80)
close.TextColor3 = Color3.new(1,1,1)
close.Font = Enum.Font.Gotham
close.TextSize = 14

-- Вкл/выкл
btn.MouseButton1Click:Connect(function()
    AutoFling = not AutoFling
    btn.Text = "Auto Fling: "..(AutoFling and "ON" or "OFF")
end)

-- Закрыть
close.MouseButton1Click:Connect(function()
    gui:Destroy()
    AutoFling = false
end)

-- Основной цикл
RunService.Heartbeat:Connect(function()
    if AutoFling and Tool and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        -- Найти ближайшего игрока
        local closest,dist
        for _,plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0 then
                local d = (plr.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                if not dist or d < dist then
                    dist = d
                    closest = plr
                end
            end
        end
        if closest and dist and dist > 5 then
            -- Идём к нему
            LocalPlayer.Character.Humanoid:MoveTo(closest.Character.HumanoidRootPart.Position)
        elseif closest and dist and dist <= 6 then
            -- Если рядом, кликаем туллом
            pcall(function()
                Tool:Activate()
            end)
            wait(0.2)
        end
    end
end)
