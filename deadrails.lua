-- // НАСТРОЙКИ //
local speed = 80 -- скорость
local jumpPower = 90
local flightTime = 5 -- секунд облёта если упёрся

local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local char = lp.Character or lp.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local hum = char:WaitForChild("Humanoid")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local toggled = false
local gui -- потом создадим

-- // GUI //
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0,200,0,300)
frame.Position = UDim2.new(0.1,0,0.1,0)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.Active = true
frame.Draggable = true
frame.Parent = ScreenGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,30)
title.Text = "🌟 BangBot"
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1
title.Parent = frame

local toggle = Instance.new("TextButton")
toggle.Size = UDim2.new(1,0,0,30)
toggle.Position = UDim2.new(0,0,0,40)
toggle.Text = "ON"
toggle.TextColor3 = Color3.new(0,1,0)
toggle.BackgroundTransparency = 0.2
toggle.Parent = frame

local playerList = Instance.new("ScrollingFrame")
playerList.Size = UDim2.new(1,0,0,200)
playerList.Position = UDim2.new(0,0,0,80)
playerList.CanvasSize = UDim2.new(0,0,0,0)
playerList.BackgroundTransparency = 0.3
playerList.Parent = frame

local close = Instance.new("TextButton")
close.Size = UDim2.new(0,30,0,30)
close.Position = UDim2.new(1,-30,0,0)
close.Text = "✖"
close.Parent = frame

local minimized = false
local mini = Instance.new("TextButton")
mini.Size = UDim2.new(0,30,0,30)
mini.Position = UDim2.new(1,-60,0,0)
mini.Text = "🌟"
mini.Parent = frame

-- // Обработка //
toggle.MouseButton1Click:Connect(function()
    toggled = not toggled
    toggle.Text = toggled and "OFF" or "ON"
    toggle.TextColor3 = toggled and Color3.new(1,0,0) or Color3.new(0,1,0)
end)

close.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

mini.MouseButton1Click:Connect(function()
    minimized = not minimized
    for _,child in ipairs(frame:GetChildren()) do
        if child ~= title and child ~= mini and child ~= close then
            child.Visible = not minimized
        end
    end
    frame.Size = minimized and UDim2.new(0,80,0,30) or UDim2.new(0,200,0,300)
end)

-- // Обновляем список игроков //
local function updateList()
    playerList:ClearAllChildren()
    local y = 0
    for _,p in ipairs(Players:GetPlayers()) do
        if p ~= lp then
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1,0,0,20)
            lbl.Position = UDim2.new(0,0,0,y)
            lbl.Text = p.Name
            lbl.TextColor3 = Color3.new(1,1,1)
            lbl.BackgroundTransparency = 1
            lbl.Parent = playerList
            y = y + 20
        end
    end
    playerList.CanvasSize = UDim2.new(0,0,0,y)
end
Players.PlayerAdded:Connect(updateList)
Players.PlayerRemoving:Connect(updateList)
updateList()

-- // Анти‑фолл //
RunService.RenderStepped:Connect(function()
    if hum.FloorMaterial == Enum.Material.Air then
        hrp.Velocity = Vector3.new(0,2,0)
    end
end)

-- // Анти‑стоп //
hum.PlatformStand = false
hum.Seated:Connect(function(active)
    if active then hum.Sit = false end
end)

-- // Логика бота //
spawn(function()
    while true do
        if toggled then
            hum.WalkSpeed = speed
            hum.JumpPower = jumpPower

            -- Найдём ближайшего врага
            local closest,dist
            for _,p in ipairs(Players:GetPlayers()) do
                if p~=lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local d = (p.Character.HumanoidRootPart.Position - hrp.Position).Magnitude
                    if not dist or d<dist then
                        closest=p
                        dist=d
                    end
                end
            end

            if closest and closest.Character then
                local dir = (closest.Character.HumanoidRootPart.Position - hrp.Position).Unit
                hrp.Velocity = dir * speed

                -- Проверим, упёрся ли в стену
                local ray = Ray.new(hrp.Position, hrp.CFrame.LookVector * 3)
                local part,pos = workspace:FindPartOnRay(ray, char)
                if part then
                    -- Откат назад
                    hrp.CFrame = hrp.CFrame - hrp.CFrame.LookVector * 5
                    wait(1)
                    -- Взлет вверх и вперёд
                    local goal = hrp.Position + Vector3.new(0,15,0) + dir*20
                    local tween = TweenService:Create(hrp, TweenInfo.new(flightTime), {CFrame = CFrame.new(goal)})
                    tween:Play()
                    tween.Completed:Wait()
                end
            end
        end
        wait(0.1)
    end
end)
