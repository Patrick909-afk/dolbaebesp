local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")

-- Создание GUI
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "PatrickNoClip"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 200, 0, 100)
frame.Position = UDim2.new(0.4,0,0.4,0)
frame.BackgroundColor3 = Color3.fromRGB(0,255,0)
frame.BackgroundTransparency = 0.2
frame.Active = true
frame.Draggable = true

local noclipBtn = Instance.new("TextButton", frame)
noclipBtn.Text = "Toggle NoClip"
noclipBtn.Size = UDim2.new(1,0,0,30)
noclipBtn.Position = UDim2.new(0,0,0,0)
noclipBtn.BackgroundColor3 = Color3.fromRGB(0,200,0)

local killAuraBtn = Instance.new("TextButton", frame)
killAuraBtn.Text = "KillAura"
killAuraBtn.Size = UDim2.new(1,0,0,30)
killAuraBtn.Position = UDim2.new(0,0,0,35)
killAuraBtn.BackgroundColor3 = Color3.fromRGB(0,200,0)

local closeBtn = Instance.new("TextButton", frame)
closeBtn.Text = "X"
closeBtn.Size = UDim2.new(0,30,0,30)
closeBtn.Position = UDim2.new(1,-30,0,0)
closeBtn.BackgroundColor3 = Color3.fromRGB(200,0,0)

-- NoClip логика
local noclip = false
noclipBtn.MouseButton1Click:Connect(function()
    noclip = not noclip
end)

game:GetService("RunService").Stepped:Connect(function()
    if noclip and char and hum and hum.Health > 0 then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
        char:Move(Vector3.new(0,0,0), true) -- фиксим падение
    end
end)

-- ESP поездов
local function createESP(part)
    local billboard = Instance.new("BillboardGui", part)
    billboard.Size = UDim2.new(0,50,0,50)
    billboard.AlwaysOnTop = true
    local img = Instance.new("ImageLabel", billboard)
    img.Image = "rbxassetid://12812846838" -- иконка поезда или свою подставь
    img.Size = UDim2.new(1,0,1,0)
    img.BackgroundTransparency = 1
    return billboard
end

for _, obj in pairs(workspace:GetDescendants()) do
    if obj:IsA("Model") and obj.Name:lower():find("train") then
        createESP(obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart"))
    end
end

workspace.DescendantAdded:Connect(function(obj)
    if obj:IsA("Model") and obj.Name:lower():find("train") then
        wait(0.5)
        createESP(obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart"))
    end
end)

-- Килл-аура логика
killAuraBtn.MouseButton1Click:Connect(function()
    local range = 25 -- радиус действия ауры
    for _, npc in pairs(workspace:GetDescendants()) do
        if npc:IsA("Model") and npc:FindFirstChildOfClass("Humanoid") then
            local hrp = npc:FindFirstChild("HumanoidRootPart")
            if hrp and (hrp.Position - char.PrimaryPart.Position).Magnitude < range then
                npc.Humanoid.Health = 0
            end
        end
    end
end)

-- Закрытие
closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)
